function [ti,yi] = fcnInterpolateProbCurves(x,y); 


[xx,yy] = stairs(x,y);
xx = xx+(1:length(xx))'*.01; 
ti = linspace(0,22,100); 
yi = interp1(xx,yy,ti); 