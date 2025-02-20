function [mP, LP, UP, mN, LN,UN]=fcnGetLRPandLRN(r,y)
sum(r & y);
sum(~r&~y);
for i = 1:10000
    data = datasample([r y],length(r));
    rr = data(:,1); yy = data(:,2); 
    se = sum(rr==1 & yy==1)/sum(yy==1);
    sp = sum(rr==0 & yy==0)/sum(yy==0);
    acc = sum(rr==yy)/length(yy);
    lrp(i) = se/(1-sp) ;
    lrn(i) = (1-se)/sp;
    
end

UP = quantile(lrp,0.95);
LP = quantile(lrp,0.05);
% mP = quantile(lrp,0.5); 

UN = quantile(lrn,0.95);
LN = quantile(lrn,0.05);
% mN = quantile(lrn,0.5); 

%% report non-bootstrapped numbers for mN, mP
se = sum(r==1 & y==1)/sum(y==1);
sp = sum(r==0 & y==0)/sum(y==0);
acc = sum(r==y)/length(y);
mP = se/(1-sp) ;
mN = (1-se)/sp;