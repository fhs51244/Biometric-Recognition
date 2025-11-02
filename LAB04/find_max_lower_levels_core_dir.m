%finds coordinates for maximum in next level
%use the direction information dir
%
function [rr_c,cc_c,max3]=find_max_lower_levels_core_dir(magn,w_size,bias,r_coord,c_coord,dir)

    ss=size(magn);
    bias=4;%s4->s3 +4 gradient filter is 9x9
    
    %coord transf between levels
    tr_r1=r_coord*2+bias;
    tr_c1=c_coord*2+bias;
    
    %calculate window
    offset=-w_size*dir;%complex
    dr=imag(offset);
    dc=real(offset);
    %
    %% if small dr,dc more uniform search areas should be implemented
    %if abs(dr)<4;dr=sign(dr)*4;end
    %if abs(dc)<4;dc=sign(dc)*4;end
    if abs(dr)<5;tr_r1=tr_r1-5;dr=11;end
    if abs(dc)<5;tr_c1=tr_c1-5;dc=11;end
    
    r_wind=round(tr_r1 + dr);
    c_wind=round(tr_c1 + dc);
    
    if r_wind < 1 ;r_wind=1;end
    if r_wind > ss(1);r_wind=ss(1);end
    if c_wind < 1;c_wind=1;end
    if c_wind > ss(2);c_wind=ss(2);end
    
    if r_wind < tr_r1;r_start=r_wind; r_end=tr_r1;else r_start=tr_r1;r_end=r_wind;end
    if c_wind < tr_c1;c_start=c_wind; c_end=tr_c1;else c_start=tr_c1;c_end=c_wind;end
    
    %r_start
    %r_end
    %c_start
    %c_end
    %pause;
    %windowed area
    %rr3b=-w_size+tr_r1;rr3e=tr_r1+w_size;cc3b=-w_size+tr_c1;cc3e=tr_c1+w_size;
   
    %if rr3b<1;rr3b=1;end
    %if rr3e>ss(1);rr3e=ss(1);end
    %if cc3b<1;cc3b=1;end
    %if cc3e>ss(2);cc3e=ss(2);end

    %find maximum in windowed area
    max3=max(max(magn(r_start:r_end,c_start:c_end)));
    [rr_c,cc_c]=find(magn(r_start:r_end,c_start:c_end)==max3);
    
    rr_c=rr_c+(r_start-1);cc_c=cc_c+(c_start-1);
  
   
   
    
    