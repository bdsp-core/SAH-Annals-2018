function fcnWriteDataToTxtFile(A); 

sid=A(:,1); 
natime=A(:,2); 
nastat=A(:,3); 
ndtime=A(:,4); 
ndstat=A(:,5); 
risk=A(:,6); 
T = table(sid,natime,nastat,ndtime,ndstat,risk)
writetable(T,'tabledata2.txt','Delimiter','\t','WriteRowNames',false)