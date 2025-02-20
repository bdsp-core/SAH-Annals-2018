function fcnPlotPredictionCurve_v2(filename, riskTitle,Talarm,Tdind,ylabelOn)  

%% plot risk vs time for an individual

T=20;
Te=15;
% Talarm=6.5; 
% Tdind=9; 

gc = [0.2 .6 .2];
yc = [1 0.6 0]; 

% load(filename); % t y ye
%[p25n,t]=fcnPredictEndFromNoAlarm(y,t,T); 
%[p25a,t]=fcnPredictEndFromAlarm(y,t,T); 

data = fcnImportPredictionData(filename);
t = data(:,2); s0 = data(:,3); s1 = data(:,6); 
[~,p25n]=fcnGetInterpolatedSurvivalFcn(t,s0); p25n(1:2) = p25n(3); 
[t,p25a]=fcnGetInterpolatedSurvivalFcn(t,s1); p25a(1:2) = p25a(3); 

% load HAZDATA1
% load(filename);  % t y ye
% load HAZDATA1

h=plot(t,p25n,'b--','linewidth',3); set(h,'color',gc); 
hold on; 
h=plot(t,p25a,'r--','linewidth',3);   set(h,'color',yc);

ind=find(t<=Talarm); 
t0=t(ind); 
y0=p25n(ind);
hold on; 
h=plot(t0,y0,'b','linewidth',3); set(h,'color',gc'); 
h=plot(t0(end),y0(end),'bo','markersize',10); set(h,'color',gc');
set(h,'markerfacecolor',gc); 

ind=find(t>Talarm & t<=Tdind); 
t1=t(ind); 
y1=p25a(ind); 
h=plot(t1,y1,'r','linewidth',3); set(h,'color',yc); 

if ~isempty(t1); 
    if t1(end)<t(end)
        h = plot(t1(1),y1(1),'markersize',15); set(h,'color',yc); 
        h=plot(t1(end),1.02*y1(end),'ro','markersize',10); 
        set(h,'markerfacecolor','r'); 
    else
        h=plot(t1(end),.9*y1(end),'ro','markersize',10); 
        set(h,'color',yc); set(h,'markerfacecolor',yc); 
    end

    
    xx=[t1(1) t1(1)]; 
    yy=[y0(end) y1(1)];
    % plot(xx,yy,'k--','linewidth',2); 
    arrow([xx(1) yy(1)],[xx(2) yy(2)*.999],'BaseAngle',30,'Length',15); 
end
xlim([min(t) Te]);  
ylim([0 1]); 
xlabel('Days after SAH','fontsize',12); 
if ylabelOn
    ylabel('Probability of DCI by day 20','fontsize',12); 
else
    set(gca,'ytick',[]); 
    set(gca,'yticklabel',[]); 
end
% title(riskTitle,'fontsize',12);
grid on
set(gca,'ygrid','on')
box off
set(gca,'tickdir','out','fontsize',12); 
set(gcf,'color','w'); 
xlim([0 20]); 
ylim([0 1]); 

%% put in y grid lines
y = 0.2:.2:1;
for i = 1:5; 
    yy = [y(i) y(i)]; 
    xx = [0 20]; 
    plot(xx,yy,'color', [0.8 0.8 0.8]); 
end
