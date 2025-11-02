%hyperbol.m
%(x+i*y) g(x,y) = x*g(x)*g(y) + i*y*g(y)*g(x)
%(x-i*y) g(x,y)

function h1=hyperbol(s)

%odd size filters
M=2*round(3*s)+1;%odd size
x=-(M-1)/2:(M-1)/2;
%x=-round(3*s):round(3*s);
y=x';

gx=exp(-(x.*x)/2/s/s);%gauss x-direction
gy=gx';%gauss y-direction

fx1=x.*gx;%x*g(x)
fy1=y.*gy;%y*g(y)


h1=(gy*fx1)+i.*(fy1*gx);

h1=h1./sum(sum(abs(h1)));%normalisation

