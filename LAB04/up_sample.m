%up_sample.m
%p must be 2^k

function DFu=up_sample(im,p)

%design smoothing filters
s=1.2;
sx=gaussgen(s,'gau',[1,2*round(3*s)+1]);
sy=sx';

%do it in steps of 2
[sr,sc]=size(im);

kend=log2(p);
for k=1:kend
    DFu=zeros(2*sr,2*sc);
    DFu(1:2:2*sr,1:2:2*sc)=im;
    DFu=filter2(sy,filter2(sx,DFu));
    
    [sr,sc]=size(DFu);
    im=DFu;
end
    