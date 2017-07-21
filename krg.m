
function [zci]=krg(x,y,x_survey,y_survey,z_survey,A)
% x et y sont les coordonnees des points de controle
% x_survey,y_survey et z_survey sont les coordonnees et valeurs de data_survey
% le code est le meme sur interp_krg en modifiant pour ne pas prendre sur une matrice mais sur un vecteur

    [GAMMA,h,a] = interp_nuee(x_survey,y_survey,z_survey);
    
    zci = nan(size(x));
    d = nan(size(x_survey));
    iA = pinv(A);
    
    for k=1:size(x,1)
            B=[];
            for i = 1:size(x_survey,1)
                d(i) = sqrt((x_survey(i)-x(k)).^2+(y_survey(i)-y(k)).^2);
                gammai0 = gammaMC( d(i),a);
				% on stocke le gamma dans le vecteur
                B(i,1) = gammai0;
            end
            B(end+1)=1;
            param = iA*B;
            zci(k) = sum(param (1:end-1).*z_survey);
    
    end


end
