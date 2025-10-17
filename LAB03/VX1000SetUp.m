%Microsoft LifeCam VX-1000 webcamera
%Set up file

clear all

% Create video input object. 
%vid = videoinput('winvideo',1,'RGB24_320x240');
vid = videoinput('winvideo',1,'YUY2_640x480');

% Set video input object properties for this application.
vid.FramesPerTrigger = Inf; %continous capturing
%vid.ReturnedColorspace = 'grayscale';
vid.ReturnedColorspace = 'rgb';
vid.LoggingMode = 'memory';
triggerconfig(vid, 'immediate');
%vid.TriggerFrameDelay=5; %5 frames delay before capturing 
vid.FrameGrabInterval = 5;

