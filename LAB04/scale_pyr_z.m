%build a Gauss pyramid of the gradient image Z
%scale_pyr_z.m
%input: orientation field (tensor)
%
%folder research/spring_04

function [Z5,Z4,Z3,Z2,Z1]=scale_pyr_z(Z)

%design smoothing filters
s=1.2;
sx=gaussgen(s,'gau',[1,2*round(3*s)+1]);
sy=sx';

%level 1
Z1=filter2(sy,filter2(sx,Z,'same'),'same');%smooth
[k,l]=size(Z1);
Z1=Z1(1:2:k,1:2:l);%downsample by 2

%level 2
Z2=filter2(sy,filter2(sx,Z1,'same'),'same');%smooth
[k,l]=size(Z2);
Z2=Z2(1:2:k,1:2:l);%downsample by 2

%level 3
Z3=filter2(sy,filter2(sx,Z2,'same'),'same');%smooth
[k,l]=size(Z3);
Z3=Z3(1:2:k,1:2:l);%downsample by 2

%level 4
Z4=filter2(sy,filter2(sx,Z3,'same'),'same');%smooth
[k,l]=size(Z4);
Z4=Z4(1:2:k,1:2:l);%downsample by 2

%level 5
Z5=filter2(sy,filter2(sx,Z4,'same'),'same');%smooth
[k,l]=size(Z5);
Z5=Z5(1:2:k,1:2:l);%downsample by 2


