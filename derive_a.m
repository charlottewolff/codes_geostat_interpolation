function [d] = derive_a(C,A,x)
    d = -2*C*x.^2/A.^3*exp(-x.^2/A.^2);
end