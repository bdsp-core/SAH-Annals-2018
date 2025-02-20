function stats = fcnFixStatsProblems(stats); 

% %% fix problems
% ii = 4; ind = find(stats(:,ii)<0); stats(ind,ii)=0; ind = find(stats(:,ii)>1); stats(ind,ii)=1;
% ii = 5; ind = find(stats(:,ii)<0); stats(ind,ii)=0; ind = find(stats(:,ii)>1); stats(ind,ii)=1; 
% ii = 6; ind = find(stats(:,ii)<0); stats(ind,ii)=0; ind = find(stats(:,ii)>1); stats(ind,ii)=1; 
% ii = 7; ind = find(stats(:,ii)<0); stats(ind,ii)=0; ind = find(stats(:,ii)>1); stats(ind,ii)=1; 
% ii = 8; ind = find(stats(:,ii)>50); stats(ind,ii)=1; 

for i = 1:size(stats,2); % loop over columns
   y = stats(:,i); % remove nan
   ind = find(isnan(y)); 
   y(ind) = nanmedian(y); 
   stats(:,i)=y; 
end
