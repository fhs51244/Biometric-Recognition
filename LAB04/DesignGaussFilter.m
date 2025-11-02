%DesignGaussFilter.m
%Designs 2D gaussian filters in x directions in [0,pi[
%
clear all;
%Filter in x number of directions,
%here x=6.
dir=[0,pi/6,pi/3,pi/2,2*pi/3,5*pi/6];
for p=1:length(dir)
    %gaussian kernel
    gg(:,:,p)=gaussian_kernel_1(7,1,dir(p));%dx,dy,theta; (7,1,:)
    figure(56);subplot(2,3,p);imagesc(gg(:,:,p));colormap(gray);axis image
    figure(57);subplot(2,3,p);mesh(gg(:,:,p));axis ij
    %pause;
end