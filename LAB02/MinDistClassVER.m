%MinDistClassVER.m
%
%Make an verification (one-to-one matching).
%Threshold value is needed
%
%Usage: [VerID,VerDist]=MinDistClassVER(dist,DB,T,ID,TH);
%Example: [Ver,Dist08]=MinDistClassVER('eucl',DB08,T08,3,2.6)
%Example: [Ver,Dist08]=MinDistClassVER('eucl',DB08,T08,1:5,2.6)
%
%inputs:
%dist: 'eucl' or 'euclw'.
%DB: reference-vectors as column vectors in DB.
%T: test-vectors as column vectors in T.
%ID: identification number. Can be a list of numbers.
%TH=threshold value
%
%outputs:
%VerId: 0=verified, 1=FR (not verified).
%VerDist: distance.

function [VerId,VerDist]=MinDistClassVER(distm,DB,T,ID,TH)

%sDBr=number of features in DB
%sDBc=number of classes in DB
[sDBr,sDBc]=size(DB);

%sTr=number of features
%sTc=number of query vectors
[sTr,sTc]=size(T);

%SDBr and STr must be of the same size,
%i.e. the same number of features.

VerId=[];
VerDist=[];
switch distm
    case{'eucl'}
        for k=1:length(ID)%for all test-vectors (hands)
           tt=ID(k);%index in T and DB
           %euclidean distance
           Tv=T(:,tt);%test vector
           DBv=DB(:,tt);%reference vector
           EUd=sqrt(sum((DBv-Tv).*(DBv-Tv)));%eucl.dist to refvector
        
           %Threshold
           ClassID=0;%assume verified
           %close indicate a small distance!
           if EUd>TH
               ClassID=1;%not verified    
           end%if
        
           %output the verification result
           VerId(k,1)=ClassID;%column vectors
           VerDist(k,1)=EUd;
        end%k
        
    case{'euclw'}
        %weighted euclidean distance
        %weighted by the variance in each feature
        %
        %compute the variance across each feature
        %in the class vectors
        for r=1:sDBr%for each feature
            sigma(r)=var(DB(r,:));%variance
        end%r
        %compute distances
        for k=1:length(ID)%for all ID
           tt=ID(k);%index in T and DB
           Tv=T(:,tt);%test vector
           DBv=DB(:,tt);%ref vector
           Temp1=(DBv-Tv).*(DBv-Tv);%squarediff
           for r=1:sDBr
               Temp2(r,:)=Temp1(r,:)./sigma(r);%weighting
           end%r
           EUd=sqrt(sum(Temp2));%Eucl dist to all classes
           [val,ind]=sort(EUd,'ascend');%sort small-to-large
        
           %Threshold
           ClassID=0;%assume verified
           %close indicate a small distance!
           if EUd>TH
               ClassID=1;%not verified (FR)     
           end%if
        
           %output the verification result
           VerId(k,1)=ClassID;%column vectors
           VerDist(k,1)=EUd;
        end%k
        
    otherwise
        disp('error in distance measure')
end%switch

