%LinjInt.m
%Shows for each pixel in position (r,c):
%-the local orientation fi(r,c), angle in the interval [0,180] in degrees
%-the gray-value in position (r,c) for each of the six filtered images
%
%Input: r,c,S
%-(r,c) is the position of the pixel; r=1:352 (row), c=1:248 (column)
%-S is a matrix S(352,248,8) containing 8 images of size 352 x 248
%(image 1=local orientation image fi; angle in the interval [0,180] in degrees)
%(images 2-7=six filtered images fim for directions 0,30,60,90,120,150 degrees)
%(image 8=n/a)
%
%Output: out
%out=column vector with 7 values
%[fi(r,c),fim0(r,c),fim30(r,c),...fim150(r,c)]
%
%Usage: 
%load S; 
%r=188;
%c=43;
%out=LinjInt(r,c,S);


function out=LinjInt(r,c,S)
s=size(S);
if r>s(1);error('rowindex >352!');end;
if c>s(2);error('colindex>248!');end;

%out=reshape(S(r,c,:),8,1);%col vector [fi,fim1:fim6,F]
out=reshape(S(r,c,1:7),7,1);%col vector [fi,fim1:fim6]
