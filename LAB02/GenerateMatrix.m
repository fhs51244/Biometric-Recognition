%Read in vectors in a matrix.
%GenerateMatrix.m
%Kenneth Nilsson 2009-09-25
%
%Vectors are input as a row-vector
%and are put in the matrix as a column-vector.
%
%The size of the matrix is n x m.
%
%Usage DB=GenerateM(9,20);
%generates a matrix DB with 20 column-vectors each with 9 elements.
%
%size of the matrix n x m is input variables.
%the matrix M is the output.

function M=GenerateMatrix(n,m)

M=zeros(n,m);%size of the matrix nxm (9x20)
[row,col]=size(M);
xn=['[x1,x2,.....x' num2str(n) '] '];

for m=1:col
    disp('Put the values in a row-vector as')
    k=input(xn);
    M(:,m)=k' %put in as a column in the matrix M
end