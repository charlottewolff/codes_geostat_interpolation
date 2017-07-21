function main_interp

%on ferme toutes les fenetres pouvant etre ouvertes
close all
%chargement des donnees
data = load('data_survey');
data2 = load('data_control');

%construction des vecteurs colonnes x,y,z
x = data(:, 1);
y = data(:, 2);
z = data(:, 3);


xc = data2(:, 1);
yc = data2(:, 2);
zc = data2(:, 3);

[m,e] = moyenne_ecartT(zc);

%affichage des donnees
hold on
%plot_data(x, y, z)
plot_data(xc, yc, zc)
% On genere une grille reguliere en x et y
[xg, yg] = meshgrid(linspace(min(x),max(x),10),linspace(min(y),max(y),10));
% On calcule les valeurs interpolees en chaque point de grille, ici par ppv



% %interpolation par les plus proches voisins
%[zg1,m1,e1,m12,e12] = interp_ppv(x, y, z, xg, yg, xc, yc,zc);
% % 
% % %interpolation lineaire a partir de triangulations
%[zg2,m2,e2,m22,e22] = interplin(x, y, z, xg, yg,xc,yc,zc);
% 
% % %interpolation par inverse des distances à differentes puissances
%[zg3,m3,e3,m32,e32] = interp_dst(x,y,z,xg,yg,2,10, xc,yc,zc)
% 
% %interpolation avec les splines
%[zg4,m4,e4,m42,e42] = interp_splines(x,y,z,xg,yg,100,xc,yc,zc)

%interpolation par krigeage
%[gamma,h,a] = interp_nuee(x,y,z);
[zg5,mc,ec,m52,e52] = interp_krg(x,y,z,xg,yg,xc,yc,zc);

%On trace la surface correspondante
figure;
surf(xg, yg , zg5);
%contrainte du graphique sur les valeurs min et max
caxis([min(z), max(z)]);
shading interp;
view(0, 90);
xlim([min(x), max(x)]);
ylim([min(y), max(y)]);
zlim([min(z)*0.9, max(z)*1.1]);
colorbar;

function plot_data(x, y, z)
%fonction qui trace les resultats

	% Nuage de points
	figure; hold on;
	grid on; box on; axis('equal');
	plot(x, y,'.');
	
	% Nuage de points colores
	figure; hold on;
	grid on; box on; axis('equal');
	scatter3(x, y ,z , 25, z(:), 'filled'); view(0,90);
	colorbar;

   
end


% moyenne = [m;m1;m2;m3;m4];
% ecart = [e;e1;e2;e3;e4];
end