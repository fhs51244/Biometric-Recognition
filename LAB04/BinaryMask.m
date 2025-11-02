%BinaryMask.m
%ZZ is the smoothed gradient image
%gxLS is the smoothing filter

function BB=BinaryMask(ZZ,gxLS)

ZB=abs(ZZ);
ZBU=up_sample(ZB,8);%same size as Z0
%smooth it s=1.6
%same size as r0c
ZBU=filter2(gxLS',filter2(gxLS,ZBU,'valid'),'valid');
ZBU=ZBU/max(max(ZBU));%[0,1]
BMask=ZBU>0.1;%manually from histogram

%Make the active area smaller
%first, make sure a black border
[sr,sc]=size(BMask);
BMask(1,:)=0;
BMask(sr,:)=0;
BMask(:,1)=0;
BMask(:,sc)=0;
%then make it smaller
se1=strel('disk',10);%radius=10pixel
BB=imerode(BMask,se1);