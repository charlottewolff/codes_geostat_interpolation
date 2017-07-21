function [moyenne,ecartT] = moyenne_ecartT(z)
%calcul la moyenne et ecart type des valeurs de z
    
    id = find(~isnan(z));
    new_z = z(id);
    
    moyenne = nanmean(new_z);
    ecartT = nanstd(z);
    
end