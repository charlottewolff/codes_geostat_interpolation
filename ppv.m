(* ::Package:: *)

function [z]=ppv(x,y,x_survey,y_survey,z_survey)
% x et y sont les coordonnees des points de controle
% x_survey,y_survey et z_survey sont les coordonnees et valeurs de data_survey
% le code est le meme sur interp_ppv en modifiant pour ne pas prendre sur une matrice mais sur un vecteur
distMin = sqrt((x_survey(1)-x).^2+(y_survey(1)-y).^2);
z = z_survey(1);

for i=1:size(x_survey)
    distance = sqrt((x_survey(i)-x).^2+(y_survey(i)-y).^2);
    if distance<distMin
        distMin=distance;
        z=z_survey(i);
    end
    
end

end

