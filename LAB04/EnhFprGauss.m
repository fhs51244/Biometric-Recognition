%Enhancement of fingerprints
%2D gaussian kernel
%Orientation information is estimated from the local direction of the pattern
%Six orientations are used, and the two "closest" are linearly weighted together
%The weight vector w includes the weights for each pixel.

%EnhFprGauss.m
%input:im grayscale image
%output: F filtered image

% %FPCard sensor 200x152 image
% im=double(imread('kn1.bmp'));
% im=im(200:-1:1,:,1);%
% [sr,sc]=size(im);

% %Database FVC 364x256 image
% im=double(imread('41_4.tif'));
% im=im(3:362,:);%clip to 360x256;up/down sample by 2!
% [sr,sc]=size(im);
% %pause;

function F=EnhFprGauss(im);
[sr,sc]=size(im);

%Filter in x number of directions,
%here x=6.
dir=[0,pi/6,pi/3,pi/2,2*pi/3,5*pi/6];
fim=zeros(sr,sc,length(dir));

for p=1:length(dir)
    %gaussian kernel
    gg=gaussian_kernel_1(7,1,dir(p));%dx,dy,theta; (7,1,:)
    fim(:,:,p)=filter2(gg,im);%360x256x6
    figure(55);subplot(2,3,p);imagesc(fim(:,:,p));colormap(gray);axis image
%     if p<length(dir)
%         disp('press a button to continue');
%         pause;
%     end
end
%disp('press a button to continue');
%pause;

%Compute the direction field Z0
%Z0 is computed by 'valid'
%'valid';9x9 filter if s1=1.2; offset=4
[i20_0,i11_0,Z0]=orientation_map(im,1.2,2.1);%s1=1.2;s2=2.1
%Smooth it, and select a smoothed DF
%Z0 ha size 352x248
[Z5,Z4,Z3,Z2,Z1]=scale_pyr_z(Z0);%
DF=Z3;%Z3
%DF=Z2;%Z2
%Up-sample to the same size as image
%here 8 times (if Z3).
%Do it in steps of 2.
DF8=up_sample(DF,8);%DF=Z3 (8)
%DF8=up_sample(DF,4);%DF=Z2 (4)

% figure(1);
% quiver(real(DF8),imag(DF8));axis ij; axis image;
% pause;

%weight the filter responses according to the local direction
[yr,yc,yz]=size(fim);%360x256x6
[sr,sc]=size(DF8);%local direction image; 352x248
%pause;
for y=1:sr
    for x=1:sc
        fi=mod(angle(DF8(y,x))/2 +pi/2,pi);%orientation [0,pi[
        w=find_weights(fi,dir);%compute weight vector 1x6
        %add filtered images
        %add 5 to y and x coord when s1=1.2 (offset+1)
        F(y,x)=sum(reshape(fim(y+5,x+5,:),1,yz).*w);
    end%y
end%x
        
figure(49);
subplot(1,2,1);imagesc(im);colormap(gray);axis image
title('original image');
subplot(1,2,2);imagesc(F);colormap(gray);axis image
title('enhanced image');
%pause;
        
        

        
        
        
        
        

