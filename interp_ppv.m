function [zi,m,e,mc,ec] = interp_ppv(x,y,z,xi,yi,xc,yc,zc)

% METHODE DETERMINISTE
% Fonction qui interpole par le plus proche voisin.




% ATTENTION : x,y et z sont des vecteurs colonnes.
% x,y contiennent les coordonn\[EAcute]es des sites d'observation.
% z contient les observations (soit la profondeur).
% xi,xi la grille des sites inconnus



% On initialise une matrice zi, de dimensions celles de xi.
% On la remplit de nan (not a number).
zi = nan(size(xi));


% On parcourt lignes et colonnes pour trouver les sites.
for i = 1:size(xi,1) % lignes
	for j =1:size(xi,2) % colonnes
        
		% On determine la distance entre chaque point de la grille,
		% soit entre les points de coordonnees xi(i,j) et yi (i,j).
       
        % distance est aussi un vecteur colonne, de meme taille que x et y.
        distance = sqrt((xi(i,j)-x).^2+(yi(i,j)-y).^2);
		
    % On determine la valeur et le rang du point de distance minimale
    % (plus proche voisin).
		[dmin, rang] = min(distance);
    
		% On calcule la valeur interpolee.
        zi(i,j) = z(rang);
        
	end % j
end % i

% On determine la moyenne et l'ecart-type sur l'ensemble des valeurs de zi.
[m1,e1] = moyenne_ecartT(zi);

% On determine la moyenne des valeurs.
m = nanmean(m1);

% On determine l'ecart-type des valeurs.
e = nanstd(e1);

% calcul de la moyenne et de l'ecart-type sur les zi de controle
%zverif = [];
%zverif = nan(size(zc));

size(xc) %50x1
size(yc) %50x1
size(zc) %50x1
zci = nan(size(zc));

for i=1:size(xc,1)
   
	zci(i) = ppv(xc(i),yc(i),x,y,z);
	
end
zci

mc = nanmean(zci-zc)
ec = nanstd(zci-zc)

% on peut egalement regarder ce que donne visuellement le resultat
plot_data(xc, yc, zci);
