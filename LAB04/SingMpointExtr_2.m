%SingMpointExtr_2.m
%Singular and Minutiae point extraction
%Fingerprint images from database db2A fvc2000
%
%Start at level 3 (Z3) to search for Sing points
%M-points is serch for in level 0 (Z0).

clear all;%clear variables

%*** CAPTURE ***
%Capture the fingerprint image
%from database db2A FVC200.
%Capacitive sensor, 500 dpi, 364x256 image
imo=double(imread('41_4.tif'));%41_4 default, 41_x also
%Clip the image to fit up- downsample by 2 (3 times)
imo=imo(3:362,:);%360x256
%*** CAPTURE ***

%**** CHANGE HERE ****
ENHANCE=0;%don't do enhancement
%ENHANCE=1;%do enhancement
%**** CHANGE HERE ****

switch ENHANCE
    case{0}
       %*** NO ENHANCEMENT ***
       %original image must be clipped to the same size as the enhanced
       imo=imo(5:356,5:244);%original image 352x248
       im=imo;%original image 352x248
       imd=imo;fig=50;%display
       %*** NO ENHANCEMENT ***
    case{1}
        disp('showing intermediate images of the enhancement process');
        %*** ENHANCEMENT ***
        %by directional Gaussian filtering
        %imh is of size 352x248 (s1=1.2)
        imh=EnhFprGauss(imo);
        im=imh;%enhanced image 352x248
        imd=imh;fig=51;%display
        %imd=imo(5:356,5:244);fig=51;%display
        disp('enhancement finished, press a button to continue');
        pause;
        disp('**************************');
        %*** ENHANCEMENT ***
    otherwise
        disp('error in the ENHANCE choice');
end
        
%*** FEATURE EXTRACTION ***
%Extract Singular points and Minutiae points
%by complex filtering.

%Design first order symmetry filters (hyperbolic)
std_h1=1.6;% 1.6
h1=hyperbol(std_h1);%11x11 filter
[h_h1,w_h1]=size(h1);
h1_b=(h_h1+1)/2;%odd size filter

%Vector representation
%Compute gradient image Z0
[i20_0,i11_0,Z0]=orientation_map(im,1.2,2.1);%s1=1.2;s2=2.1
%Compute the Gaussian scale pyramid of the gradient image
[Z5,Z4,Z3,Z2,Z1]=scale_pyr_z(Z0);
%display
% figure(1);
% figure_number=1;
% figure(figure_number);
% subplot(1,2,1);imagesc(im);colormap(gray); axis image
% title('Fingerprint image');
% subplot(1,2,2);quiver(real(Z3),imag(Z3));axis('ij'); axis image
% title('Direction image (DR), computed at level 3')

% [I5,I4,I3,I2,I1]=scale_pyr_z(im);

figure_number=1;
figure(figure_number);
% subplot(1,3,1);imagesc(im);colormap(gray); axis image
% title('Fingerprint image at level 0');
% subplot(1,3,2);imagesc(I2);colormap(gray); axis image
% title('Fingerprint image at level 2');
% subplot(1,3,3);imagesc(I3);colormap(gray); axis image
% title('Fingerprint image at level 3');
% 
% figure_number=figure_number+1;
% figure(figure_number);
subplot(1,3,1);imagesc(im);colormap(gray); axis image
title('Fingerprint image at level 0');
subplot(1,3,2);quiver(real(Z3),imag(Z3));axis('ij'); axis image
title('Direction image (DR), computed at level 3')
subplot(1,3,3);quiver(real(Z4),imag(Z4));axis('ij'); axis image
title('Direction image (DR), computed at level 4')
%set(gcf, 'Position', get(0,'Screensize')); % Maximize figure.

disp('Observe how singular points appear in the DR image at different levels.');
disp('Can you identify the position of singular points in the DR image at levels 3 or 4?');
disp('Can you identify the position of m-points in the DR image at levels 3 or 4? Why not?');
disp('press a button to continue');
pause;
disp('**************************');

% figure(2);
figure_number=figure_number+1;
figure(figure_number);
im_mp=marker(im,130,35,'square');%Mark m-point
subplot(1,3,1);imagesc(im_mp);colormap(gray); axis image
title('Fingerprint image, with an m-point indicated');
ZD=Z0(116:136,17:43);%minutia point
subplot(1,3,2);quiver(real(ZD),imag(ZD));axis('ij'); axis image
title('Direction image (DR) computed at level 0 around the m-point')
ZD=Z3(round((116:136)/8),round((17:43)/8));%minutia point
subplot(1,3,3);quiver(real(ZD),imag(ZD));axis('ij'); axis image
title('Direction image (DR) computed at level 3 around the m-point')

disp('Can you now identify the position of an m-point in the DR image? At which level?');
disp('press a button to continue');
pause;
disp('**************************');

%First order complex filtering (parabolic symmetry)
%complex output rxc and rxd, x=scale number, c=core, and d=delta
%for scales 3->0 only
%[r5c,r5d]=hyperbol_2Dfiltering(h1,Z5);
%[r4c,r4d]=hyperbol_2Dfiltering(h1,Z4);
[r3c,r3d]=hyperbol_2Dfiltering(h1,Z3);%'valid';11x11 (std_h1=1.6)
[r2c,r2d]=hyperbol_2Dfiltering(h1,Z2);
[r1c,r1d]=hyperbol_2Dfiltering(h1,Z1);
[r0c,r0d]=hyperbol_2Dfiltering(h1,Z0);

% r3c(1:5,:)=0; r3c(end-5+1:end,:)=0; r3c(:,1:5)=0; r3c(:,end-5+1:end)=0;
% r3d(1:5,:)=0; r3d(end-5+1:end,:)=0; r3d(:,1:5)=0; r3d(:,end-5+1:end)=0;


%display
% figure(3);
figure_number=figure_number+1;
figure(figure_number);
subplot(1,3,1);imagesc(im(20:end-19,20:end-19));colormap(gray);axis image
title('Fingerprint image');
subplot(1,3,2);quiver(real(Z3(6:end-5,6:end-5)),imag(Z3(6:end-5,6:end-5)));axis('ij'); axis image
title('Direction image (DR), computed at level 3')
subplot(1,3,3);imagesc(abs(r3c));colormap(gray);axis image
title('Magnitude of filter response for core-point (computed at level 3)');

figure_number=figure_number+1;
figure(figure_number);
subplot(1,3,1);imagesc(im(20:end-19,20:end-19));colormap(gray);axis image
title('Fingerprint image');
subplot(1,3,2);quiver(real(Z3(6:end-5,6:end-5)),imag(Z3(6:end-5,6:end-5)));axis('ij'); axis image
title('Direction image (DR), computed at level 3')
subplot(1,3,3);imagesc(abs(r3d));colormap(gray);axis image
title('Magnitude of filter response for delta-point (computed at level 3)');

disp('Now we apply the filters to detect core and delta points at level 3 (figures 3 and 4).');
disp('They should produce a strong response in the position of the points. Is it the case?');
disp('It is easy to find the position of brightest point on this level (level 3)!');
% figure(4);
% subplot(1,2,1);imagesc(abs(r2c));colormap(gray);axis image
% title('filter response core-point (level 2)');
% subplot(1,2,2);imagesc(abs(r2d));colormap(gray);axis image
% title('filter response delta-point (level 2)');
disp('press a button to continue');
pause;
disp('**************************');
     
%SSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSS
%Singular points extraction, start on level 3
%and stop on level 1.

%**********SCALE 3 (lowest resolution)*************
%Find "most possible" singular points at level 3 
%by search for maximum in magnitude response r3c and r3d
[r_3c,c_3c,max1]=find_ref_point_max(abs(r3c),7);%1:st corepoint
[r_3d,c_3d,max2]=find_ref_point_max(abs(r3d),7);%1:st deltapoint
%[r_4d,c_4d,max2]=find_ref_point_max(abs(r4d),5);%1:st deltapoint

%maximum values, complex
max_3c=r3c(r_3c,c_3c);%1:st core
max_3d=r3d(r_3d,c_3d);%1:st delta
    
%*********************************************************************
%Use the orientation information from higher scales to enhance the magnitude
%filter response, and search locally for maximum (windowing)

%************SCALE 2*********************
%CCCCCCCCCCCCCCC CORE_point CCCCCCCCCCCCCCCCCCCCCCC
%sharpen the filter response
nn3=r3c(r_3c,c_3c);%direction core 1
nn3=nn3/abs(nn3);%length=1
new_mva_2c=abs(r2c).*real(r2c.*conj(nn3));%1:st core

%find coordinates
%1:st core
f2=4;
w1=40;%search size w1*(-nn3)
%w1=20;
[r_2c,c_2c]=find_max_lower_levels_core_dir(new_mva_2c,w1,f2,r_3c,c_3c,nn3);
max_2c=r2c(r_2c,c_2c);     
%CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
     
%DDDDDDDDDDD DELTA point DDDDDDDDDDDDDDDDDD
%attenuate filter response by orientation information nnx
nn3=r3d(r_3d,c_3d);%direction delta 1
nn3=nn3/abs(nn3);%length=1
new_mva_2d=abs(r2d).*real(r2d.*conj(nn3));%1:st delta

%find coordinates
w1=6;
[r_2d,c_2d]=find_max_lower_levels_hom(new_mva_2d,w1,r_3d,c_3d);
max_2d=r2d(r_2d,c_2d);%1:st delta

% %display
% % figure(5);
% figure_number=figure_number+1;
% figure(figure_number);
% subplot(1,2,1);imagesc(new_mva_2c);colormap(gray);axis image
% title('Magnitude of filter response for core-point (level 2)');
% subplot(1,2,2);imagesc(new_mva_2d);colormap(gray);axis image
% title('Magnitude of filter response for delta-point (level 2)');

figure_number=figure_number+1;
figure(figure_number);
subplot(1,3,1);imagesc(im(20:end-19,20:end-19));colormap(gray);axis image
title('Fingerprint image');
subplot(1,3,2);quiver(real(Z2(6:end-5,6:end-5)),imag(Z2(6:end-5,6:end-5)));axis('ij'); axis image
title('Direction image (DR), computed at level 2')
subplot(1,3,3);imagesc(new_mva_2c);colormap(gray);axis image
title('Magnitude of filter response for core-point (computed at level 2)');

figure_number=figure_number+1;
figure(figure_number);
subplot(1,3,1);imagesc(im(20:end-19,20:end-19));colormap(gray);axis image
title('Fingerprint image');
subplot(1,3,2);quiver(real(Z2(6:end-5,6:end-5)),imag(Z2(6:end-5,6:end-5)));axis('ij'); axis image
title('Direction image (DR), computed at level 2')
subplot(1,3,3);imagesc(new_mva_2d);colormap(gray);axis image
title('Magnitude of filter response for delta-point (computed at level 2)');

disp('Next we apply the filters to detect core and delta points at level 2 (figures 5 and 6).');
disp('Easy to find the position of the brightest point?');
disp('Yes, if you use the positions found in level 3 as guidance!')
disp('press a button to continue');
pause;
disp('**************************');

%DDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDD
        
%************SCALE 1*********************
%CCCCCCCCCCCCCCCCCCCCCCCCCCC core_point CCCCCCCCCCCCCCCC
%sharpen filter response core 1
nn2=r2c(r_2c,c_2c);%direction core 1
nn2=nn2/abs(nn2);%length=1
new_mva_1c=abs(r1c).*real(r1c.*conj(nn2));%1:st core

%find coordinates
f2=4;
w1=60;
%w1=20;
[r_1c,c_1c]=find_max_lower_levels_core_dir(new_mva_1c,w1,f2,r_2c,c_2c,nn2);
max_1c=r1c(r_1c,c_1c);%1:st core
     
%nn1=r1c(r_1c,c_1c);%direction core 1
%nn1=nn1/abs(nn1);%length=1
%CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
     
%DDDDDDDDDDDDDDDDDDDDDDD delta_point DDDDDDDDDDDDDDDDDD
%attenuate filter response by orientation information nnx
nn2=r2d(r_2d,c_2d);%direction delta 1
nn2=nn2./abs(nn2);%length=1
new_mva_1d=abs(r1d).*real(r1d.*conj(nn2));%1:st delta

%find coordinates
w1=6;
[r_1d,c_1d]=find_max_lower_levels_hom(new_mva_1d,w1,r_2d,c_2d);
max_1d=r1d(r_1d,c_1d);%1:st core

% %display
% % figure(6);
% figure_number=figure_number+1;
% figure(figure_number);
% subplot(1,2,1);imagesc(new_mva_1c);colormap(gray);axis image
% title('Magnitude for filter response for core-point (level 1)');
% subplot(1,2,2);imagesc(new_mva_1d);colormap(gray);axis image
% title('Magnitude of filter response for delta-point (level 1)');

figure_number=figure_number+1;
figure(figure_number);
subplot(1,3,1);imagesc(im(20:end-19,20:end-19));colormap(gray);axis image
title('Fingerprint image');
subplot(1,3,2);quiver(real(Z1(6:end-5,6:end-5)),imag(Z1(6:end-5,6:end-5)));axis('ij'); axis image
title('Direction image (DR), computed at level 1')
subplot(1,3,3);imagesc(new_mva_1c);colormap(gray);axis image
title('Magnitude of filter response for core-point (computed at level 1)');

figure_number=figure_number+1;
figure(figure_number);
subplot(1,3,1);imagesc(im(20:end-19,20:end-19));colormap(gray);axis image
title('Fingerprint image');
subplot(1,3,2);quiver(real(Z1(6:end-5,6:end-5)),imag(Z1(6:end-5,6:end-5)));axis('ij'); axis image
title('Direction image (DR), computed at level 1')
subplot(1,3,3);imagesc(new_mva_1d);colormap(gray);axis image
title('Magnitude of filter response for delta-point (computed at level 1)');

disp('Now we apply the filters to detect core and delta points at level 1 (figures 7 and 8).');
disp('Can you refine further the position of the brightest points?');
disp('Yes, if you use the positions found in higher levels as guidance');
disp('(observe other small bright points that appear at this level)!')
disp('press a button to continue');
pause;
disp('**************************');

%DDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDD

%(r_1c,c_1c) is the position of the Core singular point (level 1)
%(r_1d,c_1d) is the position of the Delta singular point (level 1)
%SSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSS
     
%MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
%Extract minutia points by parabolic symmetry PS
%and inhibition by (1-abs(LS)), i.e. PSi=PS(1-abs(LS)).
%Extract only at the highest resolution (Z0)

%Compute LS-parameter i20LS and i11LS
%by filtering
std1=std_h1;%=1.6; same size as parabol filtering!
gxLS=gaussgen(std1,'gau',[1,2*round(3*std1)+1]);
i20LS=filter2(gxLS',filter2(gxLS,Z0,'valid'),'valid');
i11LS=filter2(gxLS',filter2(gxLS,abs(Z0),'valid'),'valid');
kkLS=sqrt(mean(mean(abs(Z0))));%
LS0=i20LS./(i11LS+kkLS);

%Compute complex m-responce PSi=PS(1-abs(LS))
%r0c is the parabolic symmetry PS
%r0c and LS0 are of same size if std1=std_h1
PSi=r0c.*(1-abs(LS0));
     
%Compute a binary mask BB to avoid border problem.
%Use a smoothed gradient image (here Z3).
%BB must have the same size as PSi (smooth with gxLS)!
BB=BinaryMask(Z3,gxLS);

%Mask the complex m-responce
PSi=PSi.*BB;
     
%Find Minutia points as local Max in abs(Psi)
%BWPSi is binary
howmany=60;
[LMImage,Rcoord,Ccoord]=SearchMpoints(abs(PSi),howmany);
%(Rcoord,Ccoord) are the position of M-points (level 0)

%display
% figure(7);
figure_number=figure_number+1;
figure(figure_number);
subplot(1,3,1);imagesc(imd);colormap(gray);axis image
title('fingerprint image')
subplot(1,3,2);imagesc(abs(PSi));colormap(gray);axis image
title('Magnitude of filter response for m-points (level 0)');
%subplot(1,3,3);imagesc(LMImage.*abs(PSi));colormap(gray);axis image
subplot(1,3,3);imagesc(LMImage);colormap(gray);axis image
title('Center of white bright dots');
disp('Now we apply the filter to detect m-points.')
disp('Remember that m-points have the maximum detail at level 0.')
disp('Observe that magnitudes of filter responses are too fuzzy, specially in noisy parts!')
%disp('Do local max operation! Does the local max operation help?');
disp('Is the detection of bright dots reliable?');
disp('press a button to continue');
pause;
disp('**************************');

%MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM

%(r_1c,c_1c) is the position of the core singular point (level 1)
%(r_1d,c_1d) is the position of the delta singular point (level 1)
%(Rcoord,Ccoord) are the position of M-points (level 0)
%*** FEATURE EXTRACTION ***


%Display position of extracted Singularpoints and Minutia points   
%*********** position from level 1 ************
%f2=37;%level 3
%f2=13;%level 1
%f2=9;%level 0

%!!!!!!!!!!!!!!!!!!!!!!!!!!!
%select displayed image
%original or enhanced
%imd=imo;
%imd=imh;
%!!!!!!!!!!!!!!!!!!!!!!!!!!!
 
%Mark singular points
f2=13;%r=1 -> 15
im1=marker(imd,f2+2*r_1c,f2+2*c_1c,'square');%level 1
%im1=marker(im1,f2+2*r_1c_2,f2+2*c_1c_2,'circle');%level 1
im1=marker(im1,f2+2*r_1d,f2+2*c_1d,'plus');%level 1
%and minutia points   
for kk=1:length(Rcoord)
   im2=marker(imd,Rcoord(kk)+9,Ccoord(kk)+9,'circlesmall');
   imd=im2;
end
%Display extracted S- and M_points   
figure(fig);
subplot(1,2,1);imshow(im1/255);axis on
title('square=corepoint  plus=deltapoint')
subplot(1,2,2);imshow(im2/255);axis on
title('minutia points')
disp('Observe the result of detection of S and M points');

   