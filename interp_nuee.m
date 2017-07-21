function [GAMMA,h,a] = interp_nuee(x,y,z)

% METHODE STOCHASTIQUE
% On veut afficher la nuee variographique et le variogramme experimental.

      %%%%%%%%%%%%%%%%%%%%%%%%%%%%
      %% 1) Nuee Variographique %%
      %%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Declaration de la matrice dans laquelle on stockera
% les ecarts.
graphe1 = [];

% Declaration de la matrice dans laquelle on stockera
% les distances.
graphe2 = [];

for i = 1:length(x) %lignes
    for n = 1:length(x) %colonnes
        
        % On calcule les ecarts des z
        ecart = 1/2*(z(i)-z(n)).^2;
        
        % On calcule les distances
        dist = sqrt((x(i)-x(n)).^2+(y(n)-y(i)).^2);
        
        % On remplit les matrices 
        graphe1 = [graphe1;dist];
        graphe2 = [graphe2;ecart];
    end %n
end %i

% On peut ainsi tracer la nuee variographique, soit les 
% ecarts en fonction de la distance.
figure; 
hold on;
grid on; box on;;
plot(graphe1, graphe2,'.');
  % abscisse : distances
  % ordonnee : ecarts
  % representation : points
  

  
      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      %% 2) Variogramme Experimental %%
      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% On selectionne un certain pas entre les valeurs des distances.
pas = 10;

% On veut tracer le variogramme sur certains intervalles.

% On determine quelles valeurs prendront h en abscisse du trace.
h = 0:pas:max(graphe1);
%[0,10,20,30]

A = [];

for k = 1:length(h)-1
    % la fonction find renvoie les RANGS des points respectant
    % les conditions enoncees, soit ceux se trouvant dans un 
    % certain intervalle de valeurs (ie dans une certaine classe).
    id = find (graphe1>=h(k) & graphe1<h(k+1));
    
    % On calcule les differentes valeurs du variogramme sur les 
    % valeurs de la classe selectionne.
    gamma(k) = mean(graphe2(id)); 
end %for


% On estime le milieu de chaque classe.
h = (h(1:end-1)+h(2:end))/2;

% On affiche les gammas (valeurs ponctuelles du variogramme) 
% en fonction de h (milieu de chaque classe de valeurs).
plot(h,gamma,'xr')
  % On obtient un ensemble de points relies entre eux.

  
% On veut desormais faire passer une vraie courbe par ces points
% On observe un caractere lineaire du variogramme sur une partie
% du schema. On regarde jusqu'ou ce caractere s'etend : environ
% h=4500. 
% On ne veut plus afficher les valeurs au-dela de h=4500.
% On va donc selectionner tous les h inferieurs a 4500 et 
% leur attribuer un id. Les valeurs restantes n'ayant pas 
% de id (cela revient a leur attribuer un gamma nul), 
% elles ne s'afficheront pas.
id = find(h<=4500);
h = h(id);

% On corrige l'ensemble des valeurs contenues dans gamma.
gamma = gamma(id);

% On peut maintenant determiner le modele de la droite.
% Le variogramme etant lineraire, pour calculer le 
% coefficient directeur de la droite, il suffit d'inverser
% le systeme Y=A*X.
% Or, les vecteurs ne sont pas aux bonnes dimensions, il 
% faut les transposer.
% le systeme : gamma=h*a  =>  a=h'*h\h'*gamma
gammai = transpose(gamma);
hi = h';

% On en revient au systeme suivant : hi'*hi\hi'*gammai
a = hi'*hi\hi'*gammai

% Maintenant qu'on a le coefficient directeur de la droite, 
% on peut tracer le variogramme experimental corrige en 
% fonction de h.
GAMMA = a*h;

% On affiche la courbe.
plot(h,GAMMA,'ob','LineWidth',2)
  % abscisse : h
  % ordonnee : GAMMA
  % representation : ronds bleus
  % largeur de la droite : 2


end
