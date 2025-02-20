function [m,L,U]=fcnReportStats(stats,m)

statsNames = {'Se' 'Sp' 'LR+' 'LR-' 'DOR' 'ARI' 'ARD' 'NNT' 'PTP' 'PPV' 'NPV'};
% stats = [se sp lrp lrn dor ari ard nnt p0 pp np];
% m = median(stats);
L = quantile(stats,0.05);
U = quantile(stats,0.95);
boxplot(stats(:,1:7))
m = (m); L = (L); U = (U); 
L=L*100; U=U*100; m=m*100; 

for i=1:length(statsNames); 
    if L(i)>U(i); t0 = L(i); t1 = U(i); L(i) = t1; U(i) = t0; end
    if ismember(i,[3 4 5 8])
        L(i)=L(i)/100; U(i) = U(i)/100; m(i)=m(i)/100; 
        str = sprintf('%s: %0.2f\t[%0.2f, %0.2f]',statsNames{i},m(i),L(i),U(i)); 
    else
        str = sprintf('%s: %0.0f\t[%0.0f, %0.0f]%%',statsNames{i},m(i),L(i),U(i));
    end
   disp(str); 
end