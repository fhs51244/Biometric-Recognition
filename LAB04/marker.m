%markers
%val 'plus' or 'square'
%im image, r,c point to mark

function im=marker(im,r,c,val)

switch val
   case {'plus'}

%plus 21x21
im(-10+r:r+10,c)=zeros(21,1);
im(-10+r:r+10,c-1)=zeros(21,1);
im(r,-10+c:c+10)=zeros(1,21);
im(r-1,-10+c:c+10)=zeros(1,21);

case {'pluswhite'}

%plus 21x21
im(-10+r:r+10,c)=ones(21,1)*255;
im(-10+r:r+10,c-1)=ones(21,1)*255;
im(r,-10+c:c+10)=ones(1,21)*255;
im(r-1,-10+c:c+10)=ones(1,21)*255;

case {'square'}

%square 21x21
im(-10+r:r+10,c+10)=zeros(21,1);
im(-10+r:r+10,c+9)=zeros(21,1);
im(-10+r:r+10,c-10)=zeros(21,1);
im(-10+r:r+10,c-9)=zeros(21,1);

im(r+10,-10+c:c+10)=zeros(1,21);
im(r+9,-10+c:c+10)=zeros(1,21);
im(r-10,-10+c:c+10)=zeros(1,21);
im(r-9,-10+c:c+10)=zeros(1,21);

case {'squarewhite'}

%square 21x21
im(-10+r:r+10,c+10)=ones(21,1)*255;
im(-10+r:r+10,c+9)=ones(21,1)*255;
im(-10+r:r+10,c-10)=ones(21,1)*255;
im(-10+r:r+10,c-9)=ones(21,1)*255;

im(r+10,-10+c:c+10)=ones(1,21)*255;
im(r+9,-10+c:c+10)=ones(1,21)*255;
im(r-10,-10+c:c+10)=ones(1,21)*255;
im(r-9,-10+c:c+10)=ones(1,21)*255;

case {'circle'}
%circle 21x21    
for k=0:pi/40:2*pi
  im(r+round(10*cos(k)),c+round(10*sin(k)))=0;
  im(r+round(9*cos(k)),c+round(9*sin(k)))=0;
end

case {'circlewhite'}
%circle 21x21    
for k=0:pi/40:2*pi
  im(r+round(10*cos(k)),c+round(10*sin(k)))=255;
  im(r+round(9*cos(k)),c+round(9*sin(k)))=255;
end

case {'circlesmall'}
%circle 11x11    
for k=0:pi/40:2*pi
  im(r+round(6*cos(k)),c+round(6*sin(k)))=0;
  im(r+round(5*cos(k)),c+round(5*sin(k)))=0;
end

otherwise
end
