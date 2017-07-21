function[gammaInitialise]= gammaSolution(h,C0,a0)

%C0=7000;
%a0=102;

gammaInitialise = nan(length(h),1);
for m=1:length(h)
    gammaInitialise(m) = C0*(1-exp(-h(m)^2/a0^2));
end
    
    
end



