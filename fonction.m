function [h] = fonction(x)
    h = (x(1).^2+x(2).^2)*log(sqrt(x(1).^2+x(2).^2));
end