
function [zi,m,e,mc,ec] = interp_dst(x,y,z,xi,yi,p,n,xc,yc,zc)

% METHODE DETERMINISTE
% Fonction qui interpole par inverse des distances, a differentes puissances.
% On va attribuer un poids inversement proportionnel a la distance entre les 
% sites et le point a estimer.
% Pour determiner la variable regionalisee, on doit calculer la formule situee 
% en 2.3 du cours, p .20.


% x,y coordonn\[EAcute]es des sites d'observations
% z: observations
% xi, yi: grilles des sites inconnus
% zi : valeurs interpol\[EAcute]es


% On initialise une matrice zi, de dimensions celles de xi.
% On la remplit de nan (not a number).
zi = nan(size(xi));

% On parcourt lignes et colonnes pour trouver les sites.
for i = 1:size(xi,1) % lignes
	for j =1:size(xi,2) % colonnes
  
        % On calcule les distances entre chaque point de la grille
        % et le site d'observation.
        norme = (sqrt((xi(i,j) - x).^2 + (yi(i,j) - y).^2)).^p;
          % Retourne un vecteur colonne.
        
        % On ordonne le vecteur norme dans l'ordre croissant.
        [norme_sort, id_sort] = sort(norme);
          % Retourne un id pour chaque element de norme. On pourra 
          % ainsi recuperer instantanement la norme souhaitee.
        
        % On choisit le nombre de termes sur lequel on veut faire 
        % l'etude (sinon on ferait des calculs sur des intervalles
        % infinis).
        selection=id_sort(1:n);
        
        % On calcule la somme au nominateur (cf formule 2.3 p .20)
        S1 = sum(z (selection)./norme(selection));
        
        % On calcule la somme au denominateur (cf formule 2.3 p .20)
        S2 = sum(1./norme(selection));
        
        % On peut desormais calculer la variable regionalisee :
        zi(i,j)=S1/S2;
        
    end % j
end % i

[m1,e1] = moyenne_ecartT(zi);
m = nanmean(m1);
e = nanstd(e1);

% calcul de la moyenne et de l'\[EAcute]cart-type sur les zi de controle
zci = []
for i=1:length(xc)
   
	zci1 = dst(xc(i),yc(i),x,y,z,p,n);
    zci = [zci;zci1];
	
end

mc = nanmean(zci-zc)
ec = nanstd(zci-zc)

% on peut egalement regarder ce que donne visuellement le resultat
plot_data(xc, yc, zci)

end
