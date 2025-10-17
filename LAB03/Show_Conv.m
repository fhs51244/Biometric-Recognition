%example of linear filtering (convolution)
%

clear all;
%black and white image
SV=ones(256,256)*255; %white
SV(1:256,1:128)=zeros(256,128);%vertical edge
%SV(1:128,1:256)=zeros(128,256);%horisontal edge

figure(37);imagesc(SV);colormap(gray);truesize
title('original')

%pause;

%design filters 2D
%Lowpassfilters
%hLP=ones(21,21)*(1/441);%sum=1
%hLP=ones(41,41)*(1/(41*41));%Bigger filter; sum=1
hLP=ones(11,11)*(1/(11*11));%Smaller filter; sum=1

%Highpassfilters
hHP=[-ones(3,1),zeros(3,1),ones(3,1)];%detect vertical edge;sum=0
%hHP=[-ones(1,3);zeros(1,3);ones(1,3)];%detect horisontal edge;sum=0

%do filtering
SV_LP=conv2(SV,hLP,'valid');
SV_HP=abs(conv2(SV,hHP,'valid'));
%and display
figure(38);imagesc(SV_LP);colormap(gray);truesize
title('lowpass filtered')
%pause;
figure(39);imagesc(SV_HP);colormap(gray);truesize
title('highpass filtered')