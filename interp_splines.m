

function [zi,m,e,mc,ec] = interp_splines(x,y,z,xi,yi,p,xc,yc,zc)

% METHODE DETERMINISTE
% Fonction qui interpole par splines (avec un coefficient de lissage qui varie).
% On peut rentrer en parametre de cette fonction un coefficient de lissage, p.
% Les splines d'interpolation (p=0) passent exactement par les points d'observation.
% Les splines de lissages (p!=0) passent a proximite des points d'observation.
% Plus p est grand, plus la surface tend vers un plan.

% Pour obtenir la variable regionalisee, on doit resoudre le systeme matriciel 
% en 2.5.3, p .26, soit un systeme de la forme : M*param=Z.



% On initialise une matrice zi, de dimensions celles de xi.
% On la remplit de nan (not a number).
zi = nan(size(xi));

% On construit la matrice Z, de taille celle de z plus 3.
Z = [z;0;0;0];

% La matrice M a construire est divisee en 4 blocs : on commence par creer
% chacun de ces blocs, puis on les assemble : M =[A, phi;
%                                                 C, A']


% Construction du bloc en haut a gauche :
A = [ones(size(x)), x, y];


% Construction du bloc en bas a gauche 
C0 = [zeros(3)];

% Construction de la moitie basse de la matrice :
C = [C0, A'];
  % Le bloc bas gauche, de dimension 3x3, ne contient que des 0.
  % Le bloc bas droit est en fait la transposee de la matrice A

  
% Construction du bloc haut droit, dependant du coefficient p.
% On initialise phi en la remplissant de nan.
phi = nan(length(x));

% On parcourt les lignes et les colonnes de cette matrice phi
for m = 1:(size(x)) % lignes
    for n = 1:(size(x)) % colonnes
        if m == n
            % Sur la diagonale, on place le coefficient de lissage p.
            phi(m,n) = p;
        else
            % Sinon, on calcule la bonne valeur avec la fonction
            % adequate (cf fonction.m). 
            phi(m,n) = fonction([x(m),y(m)]-[x(n),y(n)]);
        end % if
    end % j
end % i

% On peut desormais construire la matrice M.
M = [A,phi;C];

% On peut ainsi determiner les parametres inconnus
% en inversant l'eaquation : 
param = M\Z;
  % M divise Z.

% Maintenant qu'on a determine les parametres inconnus, on peut
% calculer la variable regionalisee.  

  
for i = 1:size(xi,1) % lignes
    for j =1:size(xi,2) % colonnes
        
        % On calcule les distances entre les sites et le point 
        % d'interet (contrainte de proximite au site d'observation).
        distance=sqrt((xi(i,j)-x).^2+(yi(i,j)-y).^2);
        
        % On calcule le terme situe en fin d'equation, la somme.
        S=0; 
          % Somme initialisee a 0.
        for numero=1:size(distance,1)
            S=S+param(3+numero)*distance (numero)^2*log(distance(numero));
        end % for
        
        % On peut ainsi calculer la variable regionalisee 
        % conformement a l'equation en 2.5.3, p .26.
        zi(i,j) = param(1)+param(2)*xi(i,j)+param(3)*yi(i,j)+S;
   
    end % j
end % i


[m1,e1] = moyenne_ecartT(zi);
m = nanmean(m1);
e = nanstd(e1);

% calcul de la moyenne et de l'\[EAcute]cart-type sur les zi de controle
zci = []
for i=1:length(xc)
   
	zci1 = splines(xc(i),yc(i),p,x,y,z);
    zci = [zci;zci1];
	
end

mc = nanmean(zci-zc)
ec = nanstd(zci-zc)

% on peut egalement regarder ce que donne visuellement le resultat
plot_data(xc, yc, zci)

end
