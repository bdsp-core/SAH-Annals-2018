function fcnMakeStackedProbPlot(pstate1,pstate2,pstate3,pstate4,time); 

%% Make stacked probability plots from R data
t=time; 
y1=pstate1; 
y2=pstate1+pstate2; 
y3=y2+pstate3; 
y4=y3+pstate4; 

[xi,y1]=fcnGetInterpolatedSurvivalFcn(t,y1);
[xi,y2]=fcnGetInterpolatedSurvivalFcn(t,y2);
[xi,y3]=fcnGetInterpolatedSurvivalFcn(t,y3);
[xi,y4]=fcnGetInterpolatedSurvivalFcn(t,y4);
t=xi;
y=[y1; y2; y3; y4];
x=t; 

% initial values for all y's should be 1 -- for some reason they are not.fix this. 
for j=1:4
    ct=length(y(1,:)); 
    for i=1:(length(y(j,:))-1); 
        ct=ct-1; if y(j,ct+1)==1; y(j,ct)=1; end        
    end
end

% make regions to color in
xx=[x fliplr(x)]; yy=[y(1,:)*0 fliplr(y(1,:))];
hold on; 
hp=patch(xx,yy,[0 0.5 0]); 
set(hp,'facealpha',0.3)

xx=[x fliplr(x)]; yy=[y(1,:) fliplr(y(2,:))];
hold on; patch(xx,yy,'y','facealpha',0.3); 

xx=[x fliplr(x)]; yy=[y(2,:) fliplr(y(3,:))];
hold on; patch(xx,yy,[1 0 0],'facealpha',0.3); 

xx=[x fliplr(x)]; yy=[y(3,:) fliplr(y(4,:))];
hold on; patch(xx,yy,[1 0 0],'facealpha',0.4); 

set(gca,'tickdir','out')
plot(x,y,'k','linewidth',1); 

axis([0 20 0 1]); 
set(gcf,'color','w');
xlabel('Days since SAH'); 
ylabel('Stacked state probabilities')
