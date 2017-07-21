function [h] = gamma_app(C,A,x)
    h = C*(1-exp(-x.^2/A.^2));
end