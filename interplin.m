

function [zi,m,e,mc,ec] = interplin(x,y,z,xi,yi,xc,yc,zc)

% METHODE DETERMINISTE
% Fonction qui interpole lineairement a partir d'une triangulation.
% On veut determiner la variable regionalisee qui s'ecrit :
% zi= a*x+b*y+c.
% On peut determiner les inconnues (a,b,c) en resolvant un systeme 
% d'equations. Ici, on travaille avec des matries.


   TRI = delaunay(x,y);
   % La fonction "delaunay" renvoie une matrice \[AGrave] 3 colonnes,
   % chacune relative a l'un des sommets du triangle.
   % Plus precisement, elle retourne les indices correspondant 
   % a la position de chaque sommet dans les vecteurs colonnes x et y.
    
    
    
   % On initialise la matrice zi.
   zi = nan(size(xi));
   
   
    for i = 1:size(xi,1) % lignes
        for j =1:size(xi,2) % colonnes
            
            % On cherche l'indice i relatif a un triangle
            t = tsearchn([x, y], TRI, [xi(i,j), yi(i,j)]);
            % tsearchn renvoie la ligne de la matrice TRI a laquelle
            % se trouvent les indices relatifs au triangle dans 
            % lequel se trouve le point d'interet.
            
           
            
            if ~isnan(t)
            % Si le point n'appartient pas a un triangle, 
            % on ne fait pas l'interpolation.
                
                % Creation de la matrice contenant les coordonnes
                % des sommets du triangle d'interet.
                
                % On cree la premiere colonne : elle contient les 
                % abscisses des 3 sommets du triangle.
                X = [x(TRI(t,1));x(TRI(t,2));x(TRI(t,3))];
                
                % On cree la deuxieme colonne : elle contient les 
                % ordonnees des 3 sommets du triangle.
                Y = [y(TRI(t,1));y(TRI(t,2));y(TRI(t,3))];
                
                Z = [z(TRI(t,1));z(TRI(t,2));z(TRI(t,3))];
                
                % On cree la troisieme colonne : elle contient des 1
                % En effet, dans la combinaison lineaire permettant 
                % de resoudre le probleme, le 3e terme est un simple
                % coefficient (cf ligne6).
                un = [1;1;1];
                
                % On assemble ces 3 colonnes en une seule matrice.
                A = [X Y un];
                
                % On a desormais la matrice obeissant a l'equation suivante :
                % A*param=Z, avec param le vecteur colonne contenant les 
                % parametres recherches.
                
                % Pour trouver Mat, il suffit donc d'inverser l'equation :
                param = A\Z;
                  % A divise Z.
                
                
                % On peut ainsi determiner la variable regionalisee.
                zi(i,j)= param(1)*xi(i,j) + param(2)*yi(i,j) + param(3);
                
            end % if
            
     
        end % j
    end % i

[m1,e1] = moyenne_ecartT(zi);
m = nanmean(m1);
e = nanstd(e1);

% calcul de la moyenne et de l'ecart-type sur les zi de controle
%zci = nan(size(xc));

   
	zci = plin(xc,yc,x,y,z);
	

mc = nanmean(zci-zc)
ec = nanstd(zci-zc)


% on peut egalement regarder ce que donne visuellement le resultat
plot_data(xc, yc, zci)

end
