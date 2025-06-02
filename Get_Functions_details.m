function [FunName,Dim,LB,UB,opt_f] = Get_Functions_details(FunIndex)
% Dim = 10;
Dim = 20;

switch(FunIndex)
    % FunIndex from 1 to 12 are CEC2022 functions
    %% FunIndex: 1-12-->CEC2022
    % Unimodal Function
    case {1}
        FunName='f1: Shifted and full Rotated Zakharov Function';
        lb = -100; ub = 100;
        opt_f = 300;
        % Multimodal Functions
    case {2}
        FunName='f2: Shifted and full Rotated Rosenbrock’s Function';
        lb = -100; ub = 100;
        opt_f = 400;
    case {3}
        FunName='f3: Shifted and full Rotated Expanded Scaffer’s F6 Function';
        lb = -100; ub = 100;
        opt_f = 600;
    case {4}
        FunName='f4: Shifted and full Rotated Non-Continuous Rastrigin’s Function';
        lb = -100; ub = 100;
        opt_f = 800;
    case {5}
        FunName='f5: Shifted and full Rotated Lévy Function';
        lb = -100; ub = 100;
        opt_f = 900;
        % Hybrid Functions
    case {6}
        FunName='f6: Hybrid Function 1 (N=3)';
        lb = -100; ub = 100;
        opt_f = 1800;
    case {7}
        FunName='f7: Hybrid Function 2 (N=6)';
        lb = -100; ub = 100;
        opt_f = 2000;
    case {8}
        FunName='f8: Hybrid Function 3 (N=5)';
        lb = -100; ub = 100;
        opt_f = 2200;
        % Composition Functions
    case {9}
        FunName='f9: Composition Function 1 (N=5)';
        lb = -100; ub = 100;
        opt_f = 2300;
    case {10}
        FunName='f10: Composition Function 2 (N=4)';
        lb = -100; ub = 100;
        opt_f = 2400;
    case {11}
        FunName='f11: Composition Function 3 (N=5)';
        lb = -100; ub = 100;
        opt_f = 2600;
    case {12}
        FunName='f12: Composition Function 4 (N=6)';
        lb = -100; ub = 100;
        opt_f = 2700;
end

LB = lb;
UB = ub;
end