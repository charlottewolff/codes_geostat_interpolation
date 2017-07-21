

function [ zi, m,e,mc,ec ] = interp_krg( x,y,z,xi,yi,xc,yc,zc)
% methode du krigeage

% on veut recuperer le parametre a(coefficient de la droite) du modele variographique
	[GAMMA,h,a] = interp_nuee(x,y,z);


    zi = nan(size(xi));
    d = nan(size(x));
    gamma = nan(size(x));

% on construit la matrice A, la matrice constante avec les gammas entre chaque z
% donc pour chaque z, on calcule le gamma avec tous les autres z, on fait donc 2 boucles
    for i = 1:size(x,1)
        for j =1:size(x,1)
            if i==j
                gamma(i,j) = 0;
            else
			% calcul de la distance entre chaque z
            d(i,j) = sqrt((x(i)-x(j)).^2+((y(i)-y(j)).^2));
			% calcul pour chaque du gamma correspondant a rentrer dans la matrice
            gamma(i,j) = gammaMC( d(i,j), a);
            end

        end
    end
    gamma;
	% on construit ensuite la matrice A, page 43 du cours. 
	%Cette matrice est constante sur toute la grille. On ne la cree donc qu'une seule fois
	% on cree d'abord la matrice gamma \[AGrave] laquelle on ajoute une ligne de 1
    A = [gamma; ones(1,length(gamma))];
	% on cree un vecteur avec que des 1 et on ajoute un 0
    A2 = ones(length(gamma),1);
    
    A2 =[A2;0];
	% on ajoute cette colonne a la matrice precedente
    size(A);
    size(A2);
    A = [ A, A2];
    iA = pinv(A);
   
    % On s'occupe ensuite du vecteur B egalement a la fin de la page 43 du cours
	% Ce vecteur B varie sur toute la grille. On parcourt donc toute la grille (xi,yi)
	% Pour ce vecteur, on calcul la distance du point dont la valeur est a interpolee 
	% avec les points connus de la grille
	% Puis pour chaque distance, on calcule le gamma0
    for k=1:size(xi,1)
        for j=1:size(xi,2)
            B=[];
            for i = 1:size(x,1)
                d(i) = sqrt((x(i)-xi(k,j)).^2+(y(i)-yi(k,j)).^2);
                gammai0 = gammaMC( d(i), a);
				% on stocke le gamma dans le vecteur
                B(i,1) = gammai0;
            end
			
			% On rajoute au vecteur un 1
            B(end+1)=1;

			% On inverse la matrice pour trouver les parametres necessaires 
			% pour faire le calcul des estimations
            param = iA*B;

			% On applique la contrainte de linearite, haut de p .42 pour trouver 
			% les valeurs interpolees
            zi(k,j) = sum(param (1:end-1).*z);
        end
    end
    
    [m1,e1] = moyenne_ecartT(zi);
    m = nanmean(m1);
    e = nanstd(e1);

    % calcul de la moyenne et de l'ecart-type sur les zi de controle
zci = nan(size(zc));

	zci = krg(xc,yc,x,y,z,A);
	


mc = nanmean(zci-zc)
ec = nanstd(zci-zc)

% on peut egalement regarder ce que donne visuellement le resultat
plot_data(xc, yc, zci);

    mc = nanmean(zci-zc)
    ec = nanstd(zci-zc)

    % on peut egalement regarder ce que donne visuellement le resultat
    plot_data(xc, yc, zci)


end

