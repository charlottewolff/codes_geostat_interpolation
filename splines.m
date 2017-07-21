(* ::Package:: *)

function [zci] = splines(x,y,p,x_survey,y_survey,z_survey)
% x et y sont les coordonnees des points de controle
% x_survey,y_survey et z_survey sont les coordonnees et valeurs de data_survey
% le code est le meme sur interp_splines en modifiant pour ne pas prendre sur une matrice mais sur un vecteur

    zci = x(1);
    Z = [z_survey;0;0;0];
    A = [ones(size(x_survey)), x_survey, y_survey];
    C0 = [zeros(3)];
    C = [C0, A'];
    phi = nan(length(x_survey));
    for m = 1:(size(x_survey))
        for n = 1:(size(x_survey))
            if m == n
                phi(m,n) = p;
            else
                phi(m,n) = fonction([x_survey(m),y_survey(m)]-[x_survey(n),y_survey(n)]);
            end
        end
    end
    
    M = [A,phi;C];
    param = M\Z;
    
    for i = 1:size(x,1)
        distance=sqrt((x(i)-x_survey).^2+(y(i)-y_survey).^2);
        S=0;
        
        for numero=1:size(distance,1)
            S=S+param(3+numero)*distance (numero)^2*log(distance(numero));
        end
        
        zci(i) = param(1)+param(2)*x(i)+param(3)*y(i)+S;
            


end
