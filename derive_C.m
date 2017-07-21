function [d] = derive_C(C,A,x)
    d = 1-exp(-(x/A).^2);
end