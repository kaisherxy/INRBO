% Copyright (c) 2024, Premkumar Manoharan
% Copyright (c) 2025, Xueyan Ru
%
% All rights reserved.

% Modified by Xueyan Ru in 2025 for performance enhancement.

% The original information is as follows.
% ---------------------------------------------------------------------------------------------------------------------- %
%  Authors, Inventors, and Programmers: Dr. Sowmya R, Dr. M. Premkumar, and Dr. Pradeep Jangir
%  E-Mail: mprem.me@gmail.com
% ---------------------------------------------------------------------------------------------------------------------- %
% ---------------------------------------------------------------------------------------------------------------------- %
% Please Refer the Following:
% Newton-Raphson-based optimizer: A new population-based metaheuristic algorithm for continuous optimization problems
% Engineering Applications of Artificial Intelligence,
% Volume 128, 2024,107532.
% ISSN 0952-1976
% https://doi.org/10.1016/j.engappai.2023.107532.
% https://www.sciencedirect.com/science/article/pii/S0952197623017165)
% Cite As: R. Sowmya, M. Premkumar, and P. Jangir, “Newton-Raphson-Based Optimizer: A New Population-Based Metaheuristic Algorithm for Continuous Optimization Problems,”
% Engineering Applications of Artificial Intelligence, Vol. 128, pp. 107532, February 2024.
% Website: https://premkumarmanoharan.wixsite.com/mysite/downloads
% ---------------------------------------------------------------------------------------------------------------------- %

function [Best_Score, Best_Pos, CG_curve, it] = INRBO(N, MaxIt, LB, UB, dim, fobj, MaxFEs)

% Input arguments:
% N     - Number of particles in the population
% MaxIt - Maximum number of iterations
% LB    - Lower bound of the search space
% UB    - Upper bound of the search space
% dim   - Dimensionality of the search space
% fobj  - Objective function to minimize/maximize

% Deciding Factor for Trap Avoidance Operator
DF = 0.6;
FEs = 0;                  % Number of Function Evaluations

% Initialize the bounds for each dimension
LB = ones(1, dim) * LB;
UB = ones(1, dim) * UB;

% Initialization of the population
Position = initialization(N, dim, UB, LB);
Fitness = zeros(N, 1); % Vector to store individual costs

% Calculate the initial fitness for each particle
for i = 1:N
    Fitness(i) = fobj(Position(i,:));
end

% Determine the best and worst fitness in the initial population
[~, Ind] = sort(Fitness);
Best_Score = Fitness(Ind(1));
Best_Pos = Position(Ind(1),:);

% Initialize convergence curve
CG_curve = zeros(1, MaxIt);

% Main optimization loop
it = 0;
while (it <= MaxIt)&&(FEs <= MaxFEs)
    it=it+1;
    % Dynamic parameter delta, decreases over iterations
    delta = (1 - ((2 * it) / MaxIt)) .^ 5;

    % Loop over all particles in the population
    for i = 1:N
        % Randomly select two different indices for differential evolution
        P1 = randperm(N, 2);
        a1 = P1(1); a2 = P1(2);

        % Calculate the step size rho
        rho = rand * (Best_Pos - Position(i,:)) + rand * (Position(a1,:) - Position(a2,:));

        % Apply Newton-Raphson Search Rule
        Flag = 1;
        NRSR = SearchRule(Best_Pos, mean(Position), Position(i,:), rho, Flag);
        X1 = Position(i,:) - NRSR + rho;
        X2 = Best_Pos - NRSR + rho;

        % Update position of particle
        Xupdate = zeros(1, dim);
        for j = 1:dim
            X3 = Position(i,j) - delta * (X2(j) - X1(j));
            a1 = rand; a2 = rand;
            Xupdate(j) = a2 * (a2 * X1(j) + (1 - a2) * X2(j)) + (1 - a2) * X3; % Eq.26 in the NRBO paper
        end

        % Trap Avoidance Operator to prevent local optima
        if rand < DF
            theta1 = -1 + 2 * rand(); theta2 = -0.5 + rand();
            beta = rand < 0.5;
            u1 = beta * 3 * rand + (1 - beta); u2 = beta * rand + (1 - beta);

            % dFDB
            if rand<0.5
                Best_Pos=Best_Pos;
            else
                fdbIndex = dFDB(Position, Fitness, 10, it, MaxIt);
                Best_Pos=Position(fdbIndex,:);
            end

            if u1 < 0.5
                X_TAO = Xupdate +  theta1 * (u1 * Best_Pos - u2 * Position(i,:)) + theta2 * delta * (u1 * mean(Position) - u2 * Position(i,:));
            else
                X_TAO = Best_Pos + theta1 * (u1 * Best_Pos - u2 * Position(i,:)) + theta2 * delta * (u1 * mean(Position) - u2 * Position(i,:));
            end
            Xnew = X_TAO;
        else
            Xnew = Xupdate;
        end

        % Enforce boundary conditions
        Xnew = min(max(Xnew, LB), UB);

        % Evaluate new solution
        Xnew_Cost = fobj(Xnew);
        FEs=FEs+1;

        % Update the best and worst positions
        if Xnew_Cost < Fitness(i)
            Position(i,:) = Xnew;
            Fitness(i) = Xnew_Cost;

            % Update the global best solution
            if Fitness(i) < Best_Score
                Best_Pos = Position(i,:);
                Best_Score = Fitness(i);
            end
        end
        if FEs>=MaxFEs; return; end
    end

    % Gap evolution
    for i=1:N
        JK=randperm(N,3);
        JK(JK==i)=[];
        Gap1=Best_Pos-mean(Position);
        Gap2=sign( Fitness(JK(2))-Fitness(JK(1)) ) * ( Position(JK(1),:)-Position(JK(2),:) );
        Xnew = Position(i,:) + rand(1, dim) .* (trnd(it,[1,dim]).*Gap2 + randn.* Gap1);

        % Boundary Check
        Xnew=min(max(Xnew,LB),UB);

        %==Evaluate Fitness
        Xnew_Cost = fobj(Xnew);
        FEs=FEs+1;

        % Update the best
        if Xnew_Cost < Fitness(i)
            Position(i,:) = Xnew;
            Fitness(i) = Xnew_Cost;

            % Update the global best solution
            if Fitness(i) < Best_Score
                Best_Pos = Position(i,:);
                Best_Score = Fitness(i);
            end
        end

        if FEs>=MaxFEs; return; end
    end

    % Last optimization
    [~, index]=sort(Fitness);
    Position(index(end-2),:)=LB+rand(1,dim).*(UB-LB);
    Position(index(end-1),:)=LB+rand(1,dim).*(UB-LB);
    Position(index(end),:)=LB+rand(1,dim).*(UB-LB);

    % Update convergence curve
    CG_curve(it) = Best_Score;

    % Display iteration information
    disp(['INRBO Iteration ' num2str(it) ': Best Fitness = ' num2str(CG_curve(it))]);
    if (it==MaxIt)&&(FEs<MaxFEs)
        iter=iter-1;
    end
end
end