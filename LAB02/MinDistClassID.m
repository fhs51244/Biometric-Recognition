%MinDistClassID.m
%Make an identification (one-to-many), closest
%ref vector is the winner.
%
%Usage: [IDNumb,IDDist]=MinDistClassID(dist,DB,T,ID);
%Example: [ID08,Dist08]=MinDistClassID('eucl',DB08,T08,3);
%Example: [ID08,Dist08]=MinDistClassID('eucl',DB08,T08,1:14);
%
%inputs:
%dist: 'eucl' or 'euclw'.
%DB: reference-vectors as column vectors in DB.
%T: test-vectors as column vectors in T.
%ID: identification numbers.
%Can be a list or a single number.
%
%outputs:
%IDNumb: sorted id-numbers(integer); sorted by distance
%small->large
%IDDist: distances.

function [IDNumb,IDDist]=MinDistClassID(distm,DB,T,ID)

%sDBr=number of features in DB
%sDBc=number of classes in DB
[sDBr,sDBc]=size(DB);

%sTr=number of features
%sTc=number of query vectors
[sTr,sTc]=size(T);

%SDBr and STr must be of the same size,
%i.e. the same number of features.

IDNumb=[];
IDDist=[];
switch distm
    case{'eucl'}
        %euclidean distance
        for k=1:length(ID) %for all test-vectors
           tt=ID(k); %index in T
           Tv=T(:,tt)*ones(1,sDBc);%query matrix (same size as DB) 
           EUd=sqrt(sum((DB-Tv).*(DB-Tv)));%eucl.dist to all classes
           [val,ind]=sort(EUd,'ascend');%sort small-to-large
           %Identification list
           IDNumb(:,k)=uint8(ind(1:length(ind)))';%id-number
           IDDist(:,k)=val(1:length(val))';%distances
        end%k
        
    case{'euclw'}
        %weighted euclidean distance
        %weighted by the variance in each feature
        %
        %compute the variance across each feature
        %in the enrolled vectors
        for r=1:sDBr%for each feature
            sigma(r)=var(DB(r,:));%variance
        end%r
        %compute distances
        for k=1:length(ID) %for all ID
           tt=ID(k); %index in T
           Tv=T(:,tt)*ones(1,sDBc);%query vector (same size as DB)
           Temp1=(DB-Tv).*(DB-Tv);%squarediff to all classes
           for r=1:sDBr
              Temp2(r,:)=Temp1(r,:)./sigma(r);%weighting
           end%r
           EUdw=sqrt(sum(Temp2));%Eucl dist to all classes
           [val,ind]=sort(EUdw,'ascend');%sort small-to-large
           %Identification list
           IDNumb(:,k)=uint8(ind(1:length(ind)))';%id-number, integer
           IDDist(:,k)=val(1:length(val))';%distances
        end%k
        
    otherwise
        disp('error in distance measure')
end%switch

