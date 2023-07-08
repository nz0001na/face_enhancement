clear;clc;

param.imageSize = [100 60];
param.orientationsPerScale = [8 8 8 8];
param.numberBlocks = 6;
param.fc_prefilt = 4;
param.G = gistb;
[fb_real, fb_imag] = getGaborBank; 

%read images to be cropped
pathFolder = 'F:\zn1\znMCM\MsCeleb1M_code\phometric_norm_output\middle_rgb_measure';
d = dir(pathFolder);
isub = [d(:).isdir]; % returns logical vector
nameFolds = {d(isub).name}';
nameFolds(ismember(nameFolds,{'.','..'})) = [];

%creat result folder
dst = '../cropped_output/phometric_norm/middle_rgb_measure/';
    if ~exist(dst, 'dir')
        mkdir('../cropped_output/phometric_norm/middle_rgb_measure/');  
    end
    
landmarkdir = 'F:\zn1\znMCM\MsCeleb1M_code\code_openface\landmarks\illum_middle_rgb_measure\';

for j = 1:length(nameFolds)
    fprintf('%d/%d, %s\n', j, length(nameFolds),nameFolds{j});
    subject_id = nameFolds{j};
    
    landmark = [landmarkdir subject_id '/'];
    %destination
    dstqq = [dst subject_id '/'];
    if ~exist(dstqq, 'dir')
        mkdir([dst subject_id '/']);  
    end
      
    %read jpgs of subjects
    srcimage = [pathFolder '/' subject_id '/' ]
    files = dir([srcimage '*.jpg']);
    for i=1:length(files)
        srcname = files(i).name;

        %read pts pose angle
        pname = [srcname(1:end-4) '_det_0.pts'];
        [FileId errmsg] = fopen([landmark pname]);  
        if(FileId == -1)%file not exist,just copy to destination from src
%             source = [srcimage srcname];
%             copyfile(source,dstqq);
            continue;
        end
        %read 68 points
        npoints = textscan(FileId,'%f %f ',68,'HeaderLines',3);
        Y = cell2mat(npoints);
               
        landmarks_x = Y(:,1);
        landmarks_y = Y(:,2);        
        %crop
        I = imread([srcimage srcname]); % change it to your own face images       
        
%         if max(size(I))>1200 % avoid too large image
%             I = imresize(I, 1200/max(size(I)), 'bilinear');
%         end
        
        Igr = im2double(I);
        try
            Igr = rgb2gray(Igr);
        catch exception
        end
        
        landmarks_6 = [landmarks_x(37), landmarks_x(40), landmarks_x(43), landmarks_x(46), landmarks_x(61), landmarks_x(65), landmarks_x(31), ...
                       landmarks_y(37), landmarks_y(40), landmarks_y(43), landmarks_y(46), landmarks_y(61), landmarks_y(65), landmarks_y(31)];                                      
        
        crgr = faceLandMarkNormSimple2(Igr, landmarks_6');
        imwrite(crgr, [dstqq srcname]);
        fclose(FileId);
    end
       
end   
        
        
        
 


