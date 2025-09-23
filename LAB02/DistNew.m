%DistNew.m
%Kenneth Nilsson 2009-09-22.
%
%Compute distances for same hands(ShDist) and 
%different hands (OhDist).
%
%Usage: [ShDist,OhDist]=DistNew(distm,T,Q);
%Usage: [ShDist,OhDist]=DistStat('eucl',DB08,Q08);
%
%input: distm 'eucl' or 'euclw'
%input: database-matrix T and query-matrix Q
%
%output:distances from same hands (ShDist)
%output:distances from different hands (OhDist)
%
%matrix D
%In D the diagonale is "genuine distances" (same hands)
%and off diagonale elements are "imposter distances" (different hands).
%
function [ShDist,OhDist]=DistNew(distm,T,Q)

[sTr,sTc]=size(T);
[sQr,sQc]=size(Q);

D=ones(sQc,sTc).*1000;%distance matrix

switch distm
    
    case {'eucl'}

      %Compute distances
      for m=1:sQc%for all query-vectors in Q
          %compute distance to all ref-vectors in T
          Qv=Q(:,m)*ones(1,sTc);%query vector (same size as T)
          EUd=sqrt(sum((T-Qv).*(T-Qv)));%eucl dist to all classes
          D(m,:)=EUd;%distance matrix
      end%m
      
    case {'euclw'}
        %compute variance for each feature
        for r=1:sTr%for each feature
            sigma(r)=var(T(r,:));%variance
        end%r
      %Compute distances
      for m=1:sQc%for all query vectors in Q
          %compute distance to all class vectors in T
          Qv=Q(:,m)*ones(1,sTc);%query vector (same size as T)
          Temp1=(T-Qv).*(T-Qv);%squarediff to all classes
          for k=1:sTr
            Temp2(k,:)=Temp1(k,:)./sigma(k);%weighting
          end%k
          EUdw=sqrt(sum(Temp2));%Eucl dist to all classes
          D(m,:)=EUdw;%
      end%m
           
    otherwise
        disp('error in distance measure')
end%switch

%Extract genuine distances (diagonale elements in D)
ShDist=diag(D);%distances "same hand"
%Extract imposter distances (off diagonale elements in D)
[sDr,sDc]=size(D);
k=1;
Offelements=0;
for m=1:sDr
    for n=1:sDc
        if m~=n
            Offelements(k)=D(m,n);
            k=k+1;
        end%if
    end%n
end%m
OhDist=Offelements;%distr "diffrent hands




