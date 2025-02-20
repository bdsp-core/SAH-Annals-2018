clear all; clc; format compact

%% Make histogram for patients with eventual DINDs after alarms of time to DIND
load CoxMatrix.mat % format: TIMES(j,:)=[sid(j) alarm_time(j) dind_time(j) end_time(j)];
ind=find(TIMES(:,4)>21); TIMES(ind,4)=23;
S=TIMES(:,1); A=TIMES(:,2); D=TIMES(:,3); E=TIMES(:,4); % disp([A D E])

x=(A<inf); 
y=(D<inf); 

disp([x y])

for i=0:1
    for j=0:1
        n(i+1,j+1)=sum(x==i & y==j); 
    end
end
p=n/sum(n(:))
p11=p(1,1); p00=p(2,2); 
p10=p(1,2); p01=p(2,1); 
or=p11*p00/(p10*p01); 
disp(or)

%% 
pos = sum(y)
neg = sum(y==0)
testPos = sum(A<inf)
tp = sum(y==1 & A<inf & A<D)
fp = sum((y==0 & A<inf)|(D<A) )

disp('********'); 
testNeg = sum(~(A<inf))
fn = sum(A==inf & D<inf)
tn = sum(A==inf & D==inf)