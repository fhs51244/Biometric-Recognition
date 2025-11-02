%------------------------------------------------------------------------
%gaussian_kernel
%creates a 2D gaussian convolution mask
%------------------------------------------------------------------------

%dx=spread in x-direction
%dy=spread in y-direction
%theta local direction in radians
function gg = gaussian_kernel(stdx,stdy,theta)
    %design square filters
    std=max(stdx,stdy);%maximal std
    ss= 2*round(3*std)+1;%odd filter size
    [x,y] = meshgrid(-(ss-1)/2:(ss-1)/2,-(ss-1)/2:(ss-1)/2);
    
    xp    = x*cos(theta)+y*sin(theta);
    yp    = -x*sin(theta)+y*cos(theta);
    gg     = exp(-xp.^2/stdx.^2-yp.^2/stdy.^2);
    
    %normalize
    gg=gg/sum(sum(gg));
    
%end function gaussian_kernel