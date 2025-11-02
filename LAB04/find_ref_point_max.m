%find_ref_point_max.m
%no must be uneven number

function [sing_r,sing_c,max_rc]=find_ref_point_max(im,no)

%find singular point
test=im;
sr=[];sc=sr;

%find the "no" strongest filter responses
%sr are the r_coord, sc are the c_coord
for m=1:no%uneven number!
   [rr,cc]=find(test==max(max(test)));
   sr=[sr rr];sc=[sc cc];%save coord
   test(rr,cc)=0;
end

%the median in the coordinate vectors are choosen 
%as the position of a singular point
sing_r=median(sr);
sing_c=median(sc);

%max_rc=im(sing_r,sing_c);%response in sing_point
%find maximum around (5 x 5) sing_r,sing_c
ss=size(im);
rstart=-2+sing_r;rend=sing_r+2;cstart=-2+sing_c;cend=sing_c+2;
if rstart<1;rstart=1;end
if rend>ss(1);rend=ss(1);end
if cstart<1;cstart=1;end
if cend>ss(2);cend=ss(2);end

area=im(rstart:rend,cstart:cend);
max_rc=max(max(area));
[sing_r,sing_c]=find(area==max_rc);
sing_r=sing_r+(rstart-1);
sing_c=sing_c+(cstart-1);