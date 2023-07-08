%all images
clear; clc;
close all;

pathFolder = 'F:\zn1\znMCM\IJBA_orig_w_eyeLoc\data';
d = dir(pathFolder);
isub = [d(:).isdir]; 
nameFolds = {d(isub).name}';
nameFolds(ismember(nameFolds,{'.','..'})) = [];

%creat result file
dst = 'F:\zn1\znMCM\MsCeleb1M_code\phometric_norm_output\middle\';
    if ~exist(dst, 'dir')
        mkdir('F:\zn1\znMCM\MsCeleb1M_code\phometric_norm_output\middle\');  
    end
    
% illumlist = 'F:\zn1\znMCM\MsCeleb1M_code\code_openface\illum\middle\';

for n = 1:length(nameFolds)
    fprintf('%d/%d %s\n', n, length(nameFolds), nameFolds{n});
    subject_id = nameFolds{n};
    
    %images
    src = ['F:\zn1\znMCM\MsCeleb1M_code\code_openface\outputrgb/' subject_id '/middle/'];
    files = dir([src '*.jpg']);
    %list
%     fidm = fopen([illumlist subject_id '_illum_list.csv'], 'r');
%     C = textscan(fidm, '%s');
%     C1=C{1}; 
    %destination
    dstq = [dst subject_id '/'];
    if ~exist(dstq, 'dir')
        mkdir([dst subject_id '/']);
    end

    for j = 1:length(files)    
      X = imread([src files(j).name]); % change it to your own face images
%       flag = 0;
     
%       for i=1:length(C1)
%         if( strcmp(C1{i},files(j).name))
%            flag=1; %exist in list
%            break;
%         end
%       end
%       if(flag == 0)
%           source = [src files(j).name] ;
%           copyfile(source,dstq); 
%           continue;
%       end
      
       try
            X = rgb2gray(X);
        catch exception
       end
        
      img_out_name = [dstq files(j).name]; 
      X=normalize8(imresize(X,[128,128],'bilinear'));
      %% Apply the photometric normalization techniques
      %Weberfaces
      Y = weberfaces(X); %reflectance
      out_image = normalize8(Y);
      imshow(normalize8(Y),[]);
      % Save results
      imwrite(out_image/256,img_out_name);
    end
%     fclose(fidm);
end