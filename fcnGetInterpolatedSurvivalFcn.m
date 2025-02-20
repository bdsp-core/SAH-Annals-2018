function [xi,yi]=fcnGetInterpolatedSurvivalFcn(t,y)

[tt,yy]=stairs(t,y);
for j=2:length(tt); 
    if abs(tt(j)-tt(j-1))<1e-6; 
        tt(j)=tt(j)+1e-3; 
    end
end
xi=linspace(0,max(tt),500); 
yi=interp1(tt',yy',xi); 
yi(1:2)=0; 
