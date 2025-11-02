%2Dhyperbol_filtering.m
%do hyperbolic filtering (first order symmetry)
%output is i20/i11 
%detects core and delta pattern in fingerprints
%im is a complex image Z

function [r_c,r_d]=hyperbol_2Dfiltering(h1,im)

%fix the border problem
%by expanding the edge pixels
%[h_h1,w_h1]=size(h1);
%h1_b=(h_h1+1)/2;%odd size filter

%im=copy_border(im,h1_b);

%changed 'valid' to 'same'(default)
%valid default
i20_c=filter2(conj(h1),im,'valid');%2D filtering
i20_d=filter2(h1,im,'valid');
i11=filter2(abs(h1),abs(im),'valid');

%regularization term kk
%kk=10;%avoid div 0;kk=10 normal
kk=sqrt(mean(mean(abs(im))));

r_c=i20_c./(i11+kk);%core
r_d=i20_d./(i11+kk);%delta

