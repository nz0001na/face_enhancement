% FaceLandmarkImg
% 
% Single image analysis
% 
% -f <filename> the image file being input, can have multiple -f flags
% -of <filename> location of output file for landmark points, gaze and action units
% -op <filename> location of output file for 3D landmark points and head pose
% -oi <filename> location of output image with landmarks
% -root <dir> the root directory so -f, -of, -op, and -oi can be specified relative to it
% -inroot <dir> the input root directory so -f can be specified relative to it
% -outroot <dir> the root directory so -of, -op, and -oi can be specified relative to it
% 
% Batch image analysis
% 
% -fdir <directory> - runs landmark detection on all images (.jpg and .png) in a directory, if the directory contains .txt files (image_name.txt) with bounding box (min_x min_y max_x max_y), it will use those for initialisation
% -ofdir <directory> directory where detected landmarks, gaze, and action units should be written
% -oidir <directory> directory where images with detected landmarks should be stored
% -opdir <directory> directory where pose files are output (3D landmarks in images together with head pose and gaze)
% 
clear;clc;

setenv('LD_LIBRARY_PATH', '/usr/lib/x86_64-linux-gnu/libstdc++.so.6');

binpath = '/media/guo/DEF23F27F23F02F7/OpenFace/build/bin/FaceLandmarkImg';
rootPath = '/media/guo/DEF23F27F23F02F7/MsCeleb1M/data/MsCelebV1-Faces-Cropped.Samples/MsCelebV1-Faces-Cropped.Samples/';
subject = 'm.0qfnmpt';
fdir = [rootPath subject '/'];

ofdir = ['/media/guo/DEF23F27F23F02F7/MsCeleb1M/lmoutput/' subject '/images/'];
oidir = ['/media/guo/DEF23F27F23F02F7/MsCeleb1M/lmoutput/' subject '/meta1/'];
opdir = ['/media/guo/DEF23F27F23F02F7/MsCeleb1M/lmoutput/' subject '/meta2/'];

if ~exist(ofdir,'dir') && ~exist(oidir,'dir') && ~exist(opdir,'dir')
    mkdir(ofdir);
    mkdir(oidir);
    mkdir(opdir);
end

command = [binpath ' -fdir' fdir ' -ofdir' ofdir ' -oidir' oidir ' -opdir' opdir];

[status,cmdout] = system(command)


