%finds coordinates for maximum in next level
%in a homogenous area around (r_coord,c_coord)
%in a magnitude image
%
function [rr_c,cc_c]=find_max_lower_levels_hom(magn,w_size,r_coord,c_coord)

    %if r_coord<0;r_coord=1;end
    %if c_coord<0;c_coord=1;end
    
    ss=size(magn);
    bias=4;%s4->s3 +4 gradient filter is 9x9
    
    %coord transf between levels
    tr_r1=r_coord*2+bias;
    tr_c1=c_coord*2+bias;
    
    %windowed area
    rr3b=-w_size+tr_r1;rr3e=tr_r1+w_size;cc3b=-w_size+tr_c1;cc3e=tr_c1+w_size;
   
    if rr3b<1;rr3b=1;end
    if rr3e>ss(1);rr3e=ss(1);end
    if cc3b<1;cc3b=1;end
    if cc3e>ss(2);cc3e=ss(2);end

    %find maximum in windowed area
    max3=max(max(magn(rr3b:rr3e,cc3b:cc3e)));
    [rr_c,cc_c]=find(magn(rr3b:rr3e,cc3b:cc3e)==max3);
    
    rr_c=rr_c+(rr3b-1);cc_c=cc_c+(cc3b-1);
  
   
   
    
    