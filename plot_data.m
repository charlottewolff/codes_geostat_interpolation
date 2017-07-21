

function plot_data(x, y, z)
% fonction qui trace les resultats

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
