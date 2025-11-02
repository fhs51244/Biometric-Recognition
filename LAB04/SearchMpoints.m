%SearchMpoints.m

function [LMImage,rcoord,ccoord]=SearchMpoints(SIm,number)

BWPSi=RegionalMax(abs(SIm));

%sort and take the strongest one
rr=0;cc=0;kk=0;strong=0;
[rr,cc]=find(BWPSi==1);%coordinates 
for kk=1:length(rr)
    strong(kk)=abs(SIm(rr(kk),cc(kk)));
end  
val=0;ind=0;
[val,ind]=sort(strong',1,'descend');%largest to smallest
%take the 60 strongest
howmany=min(number,length(rr));

ss=size(SIm);
rcoord=zeros(1,howmany);
ccoord=zeros(1,howmany);
LMImage=zeros(ss(1),ss(2));
for kk=1:howmany
    rcoord(kk)=rr(ind(kk));ccoord(kk)=cc(ind(kk));
    LMImage(rr(ind(kk)),cc(ind(kk)))=1;     
end