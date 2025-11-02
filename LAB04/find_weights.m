%find_weights.m
%refdir=[0,....,pi[ important to start with zero
%
%
function W=find_weights(Ld,refdir)

deltadir=refdir(2)-refdir(1);
aug_refdir=[refdir,pi];
%Compute distances to refdir
%and sort them in ascending order.
diffdist=abs(aug_refdir-Ld);
[val,ind]=sort(diffdist,'ascend');

%Interpolate linearly from the two closest
%(angle is a cyclic variable).
W=zeros(1,length(refdir));%weight-vector

if ind(1)==length(aug_refdir)
   W(1)=1-abs((pi-Ld)-refdir(1))/deltadir;
else
    W(ind(1))=1-abs(Ld-refdir(ind(1)))/deltadir;
end

if ind(2)==length(aug_refdir)
   W(1)=1-abs((pi-Ld)-refdir(1))/deltadir;
else
    W(ind(2))=1-abs(Ld-refdir(ind(2)))/deltadir;
end
%W

% %take the closest only
% W=zeros(1,length(refdir));%weight-vector
% if ind(1)==length(aug_refdir)
%    W(1)=1-abs((pi-Ld)-refdir(1))/deltadir;
% else
%     W(ind(1))=1-abs(Ld-refdir(ind(1)))/deltadir;
% end