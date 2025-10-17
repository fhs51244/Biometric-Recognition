%GaussianLive.m
%Live_processing with webcam Microsoft LifeCam VX-1000
%KN 2015-02-15/Sensorsystem course

VX1000SetUp; %configure the web cam

%design 2D derivative filter
%hsobel=fspecial('sobel');

%create a smoothing gaussian filter with:
s=1.4;
hsobel=fspecial('gaussian',2*round(3*s)+1,s);

% Create a figure window.
figure(20); 

% Start acquiring frames.
start(vid);

% Capture and filter 100 images.
    while(vid.FramesAcquired<=100)
        data = double(rgb2gray(getdata(vid,1)));
        fy=imfilter(data,hsobel);
        fx=imfilter(data,hsobel');
        gr=fx+1i*fy;
        edge=abs(gr);
        imagesc(edge);colormap(gray);truesize;
        drawnow % update figure window
    end
stop(vid)
delete(vid);