(* ::Package:: *)

function [zci]= plin(x,y,x_survey,y_survey,z_survey)
% x et y sont les coordonnees des points de controle
% x_survey,y_survey et z_survey sont les coordonnees et valeurs de data_survey
% le code est le meme sur interpin en modifiant pour ne pas prendre sur une matrice mais sur un vecteur

 TRI = delaunay(x_survey,y_survey);
 zci = nan(size(x));
 
 for i = 1:size(x)
     t = tsearchn([x_survey, y_survey], TRI, [x(i), y(i)]);
     if ~isnan(t)
         
         X = [x_survey(TRI(t,1));x_survey(TRI(t,2));x_survey(TRI(t,3))];
         Y = [y_survey(TRI(t,1));y_survey(TRI(t,2));y_survey(TRI(t,3))];
         Z = [z_survey(TRI(t,1));z_survey(TRI(t,2));z_survey(TRI(t,3))]; 
         
         un = [1;1;1];
          A = [X Y un];
          param = A\Z;
          zci(i)= param(1)*x(i) + param(2)*y(i) + param(3);
     end
     
 end


end
