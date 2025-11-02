%RegionalMax.m
%
%compute regional max in an image
%regional max is a point that has a gray value
%greater than its neighboors

function RegMax=RegionalMax(inim)

ss=size(inim);

%Neighbourhood 9x9
N=ones(9,9);
N(1:2,1:2)=zeros(2,2);
N(1:2,8:9)=zeros(2,2);
N(8:9,1:2)=zeros(2,2);
N(8:9,8:9)=zeros(2,2);
N(1,3)=0; N(1,7)=0;
N(3,1)=0; N(3,9)=0;
N(7,1)=0; N(7,9)=0;
N(9,3)=0; N(9,7)=0;
N(5,5)=0;%midpoint
NumberOfOnes=56;%9x9-25
stopN=9;
start=5;stopr=ss(1)-4;stopc=ss(2)-4;

% %Neighbourhood 5x5
% N=ones(5,5);
% N(1,1)=0; N(1,5)=0;
% N(5,1)=0; N(5,5)=0;
% N(3,3)=0;%midpoint
% NumberOfOnes=20;%5x5-5
% stopN=5;
% start=3;stop=73;


kn=inim.*(inim>0);%be sure inim>0
RegMax=zeros(ss(1),ss(2));%
Nr=1:stopN;
for rr=start:stopr%inside the image
    Nc=1:stopN;
    for cc=start:stopc
        midpoint=kn(rr,cc);
        if midpoint~=0   
           Reg=N.*kn(Nr,Nc);
           %compare
           T1=midpoint<Reg;
           T=sum(sum(T1));
           if T==0;
              RegMax(rr,cc)=1;
           end%if
        end%if
        Nc=Nc+1;
    end%cc
    Nr=Nr+1;;
end%rr
        
%figure(27);subplot(1,2,1);imagesc(kn);colormap(gray);axis image
%figure(27);subplot(1,2,2);imagesc(RegMax);colormap(gray);axis image
