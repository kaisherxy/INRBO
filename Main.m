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

clear;
close all;
clc;

Population=30;                % Number of Population
% MaxFEs = 2*1E5;             % Max number of function evaluations for D=10 of CEC2022
MaxFEs = 10*1E5;              % Max number of function evaluations for D=20 of CEC2022
MaxIt = ceil(MaxFEs/Population);  % MaxIter: Max number of  iterations
for Func_name = 1:12
    % Load details of the selected benchmark function
    [FunName,dim,LB,UB,opt_f]=Get_Functions_details(Func_name);
    fprintf('%s, opt_f=%1.8E, Population=%d, dim=%d, MaxFEs=%d...\n', FunName, opt_f, Population, dim, MaxFEs);
    fobj = @(x) cec22_test_func(x',Func_name);
    [Best_Score,Best_Pos,CG_curve,it] = NRBO(Population,MaxIt,LB,UB,dim,fobj, MaxFEs);     % NRBO
    [IBest_Score,IBest_Pos,ICG_curve,Iit] = INRBO(Population,MaxIt,LB,UB,dim,fobj, MaxFEs);% INRBO
    fprintf('\nBest fitness at MaxFEs %s for CEC2022 f%s: NRBO %s using %s-iteration, INRBO %s using %s-iteration... \n\n', ...
        num2str(MaxFEs), num2str(Func_name), num2str(Best_Score), num2str(round(it)), num2str(IBest_Score), num2str(round(Iit)));
    display(['Best soulution found by NRBO is : ', num2str(Best_Pos)]);
    display(['Best soulution found by INRBO is : ', num2str(IBest_Pos)]);
end