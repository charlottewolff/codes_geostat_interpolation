(* ::Package:: *)

function [zci]= dst(x,y,x_survey,y_survey,z_survey,p,n)
% x et y sont les coordonnees des points de controle
% x_survey,y_survey et z_survey sont les coordonnees et valeurs de data_survey
% le code est le meme sur interp_dst en modifiant pour ne pas prendre sur une matrice mais sur un vecteur
    
	zci = z_survey(1);
    for i = 1:size(x,1) % lignes
        norme = (sqrt((x(i) - x_survey).^2 + (y(i) - y_survey).^2)).^p;
        [norme_sort, id_sort] = sort(norme);
        selection=id_sort(1:n);
        S1 = sum(z_survey (selection)./norme(selection));
        S2 = sum(1./norme(selection));
        zci(i)=S1/S2
    end



end
