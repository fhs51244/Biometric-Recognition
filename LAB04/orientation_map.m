%compute the LS tensor and the complex orientation field z
%inputs:
%grayscaleimage im
%sigma derivation filter s1
%sigma averaging filter s2
%outputs:
%LS(:,:,1)=i20
%LS(:,:,2)=arg{i20}
%LS(:,:,3)=i11
%z
%
%orientation_map.m


function [i20,i11,z]=orientation_map(im,s1,s2)

%design filters
%derivation filters
%s1=1.2;
%s1=4.8;
gx=gaussgen(s1,'gau',[1,2*round(3*s1)+1]);
gy=gx';%y-axis is pointed down
dx=gaussgen(s1,'dxg',[1,2*round(3*s1)+1]);
dy=dx';%y-axis is pointed down

%averaging filters
%sigma=4-6 Bazen
%s2=4.2;
%s2=1.8;
gg=gaussgen(s2,'gau',[1,2*round(3*s2)+1]);

%compute gradients
fx=filter2(dx,filter2(gy,im,'valid'),'valid');%valid
fy=filter2(dy,filter2(gx,im,'valid'),'valid');%valid

%complex gradient, double angle representation
zg=(fx + i*fy);%gradient field
z=zg.*zg;%orientation field (double angle repr)

%averaging
i20=filter2(gg',filter2(gg,z,'same'),'same');%complex
i11=filter2(gg',filter2(gg,abs(z),'same'),'same');%scalar

%linear symmetry tensor
%LS(:,:,1)=i20;
%LS(:,:,2)=mod(angle(i20),2*pi);
%LS(:,:,3)=i11;


