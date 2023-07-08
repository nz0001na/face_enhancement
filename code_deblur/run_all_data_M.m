clear;clc;
close all;

addpath(genpath('boundary_proc_code'));
addpath(genpath('fina_deconvolution_code'));
addpath(genpath('boundary_proc'));
k_size = [19, 17, 15, 27, 13, 21, 23, 23];

%read original images, not QAoutput gray images
pathFolder = 'F:\zn1\znMCM\MsCeleb1M_code\code_openface\outputrgb';
% pathFolder = 'F:\zn1\znMCM\MsCeleb1M_code\code_openface\QAoutput';
d = dir(pathFolder);
isub = [d(:).isdir]; 
nameFolds = {d(isub).name}';
nameFolds(ismember(nameFolds,{'.','..'})) = [];

%creat result file
dst = '../deblur_output/middle_output/';
    if ~exist(dst, 'dir')
        mkdir('../deblur_output/middle_output/');  
    end
    
blurlist = 'F:\zn1\znMCM\MsCeleb1M_code\code_openface\blur\middle\';

for n = 1:length(nameFolds)
    fprintf('%d/%d %s\n', n, length(nameFolds), nameFolds{n});
    subject_id = nameFolds{n};
    
    %read rgb images
    src = ['F:\zn1\znMCM\MsCeleb1M_code\code_openface\outputrgb/' subject_id '/middle/'];
%     src = ['F:\zn1\znMCM\MsCeleb1M_code\code_openface\QAoutput/' subject_id '/middle/'];
    files = dir([src '*.jpg']);
    %list
    fidm = fopen([blurlist subject_id '_blur_list.csv'], 'r');
    C = textscan(fidm, '%s');
    C1=C{1}; 
    %destination
    dstq = [dst subject_id '/'];
    if ~exist(dstq, 'dir')
        mkdir([dst subject_id '/']);
    end
    
    for j = 1:length(files)    
      testImg = imread([src files(j).name]); % change it to your own face images
      flag = 0;
     
      for i=1:length(C1)
        if( strcmp(C1{i},files(j).name))
           flag=1; %exist in list, do deblur
           break;
        end
      end
      if(flag == 0) %not exist, just copy rgb files to deblur_output
          source = [src files(j).name] ;
          copyfile(source,dstq); 
          continue;
      end
   
%       y_color = repmat(testImg,[1 1 3]);
      if size(testImg,3) == 3
          blurred = rgb2gray(testImg);
      end
      blurred = im2double(blurred);
     
      img_out_name= [dstq files(j).name];
      eval(sprintf(['load ../deblur_output/middle_match_examplar/' subject_id '/' files(j).name(1:end-4)]))
      
      Matched = imread(['./find_structures_code/Training/' match_name]);
      Matched = imresize(Matched,[size(blurred,1), size(blurred,2)],'bilinear');
      maskname = match_name(1:end-4);
      maskname = [maskname '_mask.png'];
      Mask = imread(['./find_structures_code/Training_mask/' maskname]);
      Mask = imresize(Mask,[size(blurred,1), size(blurred,2)],'bilinear');
      opts.kernel_size  = 13;%k_size(j);
      opts.xk_iter = 50;
      opts.gamma_correct = 1.0;
      % Blind Deblur
      [interim_latent, kernel] = blind_deconv(blurred, Matched, Mask, opts);
      % With Coarse-to-fine 
      %[interim_latent, kernel] = blind_deconv_coarse_to_fine(blurred, Matched, Mask, opts);
      % Final deblur
      y_color = double(y_color)/255;
      deblur = [];
      for cc = 1:size(y_color,3)
          deblur(:,:,cc)=deconvSps(y_color(:,:,cc),kernel,0.001,100);
      end
      % Save results
      imwrite(deblur,img_out_name);
      
    end  
    fclose(fidm);
end
