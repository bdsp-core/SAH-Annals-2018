function [t,y,ye]=fcnGetHazData(time,Haz,varHaz); 

% figure(1); clf; 
ind=find(diff(time)<0);
for i=1:3 %length(ind)
    if i==1; i0=1; end
    i1=ind(i); 
    i01(i,:)=[i0 i1];
    idx=i0:i1; 
    x(i,:)=[0 time(idx)']; 
    y(i,:)=[0 Haz(idx)']; 
    ye(i,:)=[0 varHaz(idx)']; 
    i0=i1+1;
end
t=x(1,:); 
% figure(1); clf; 
% plot(t,exp(-y)); hold on

y=exp(-y); 