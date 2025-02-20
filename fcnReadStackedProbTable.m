function [time,pstate1,pstate2,pstate3,pstate4] = fcnReadStackedProbTable(filename); 

T = readtable(filename);
pstate1 = T.pstate1; 
pstate2 = T.pstate2; 
pstate3 = T.pstate3; 
pstate4 = T.pstate4; 
time = T.time; 
[~,pstate1] = fcnInterpolateProbCurves(time,pstate1); pstate1(1:2) = 1; 
[~,pstate2] = fcnInterpolateProbCurves(time,pstate2); pstate2(1) = 0; 
[~,pstate3] = fcnInterpolateProbCurves(time,pstate3); pstate3(1) = 0; 
[time,pstate4] = fcnInterpolateProbCurves(time,pstate4); pstate4(1)=0; 
