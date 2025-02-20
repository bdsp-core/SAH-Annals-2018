function fcnReportStats_OnlyMain(m)

statsNames = {'Se' 'Sp' 'LR+' 'LR-' 'DOR' 'ARI' 'ARD' 'NNT' 'PTP' 'PPV' 'NPV'};
% stats = [se sp lrp lrn dor ari ard nnt p0 pp np];
% m = median(stats);
m = (m); 
m=m*100; 

for i=1:length(statsNames); 
    if ismember(i,[3 4 5 8])
        m(i)=m(i)/100; 
        str = sprintf('%s: %0.2f',statsNames{i},m(i)); 
    else
        str = sprintf('%s: %0.0f',statsNames{i},m(i));
    end
   disp(str); 
end