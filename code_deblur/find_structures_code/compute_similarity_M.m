lear; clc;
close all;

addpath(genpath('fitting_function'));
inpath = '.\Training\*.png';
dir_im = dir(inpath);

%read original images, not QAoutput gray images
pathFolder = 'F:\zn1\znMCM\MsCeleb1M_code\code_openface\outputrgb';
% pathFolder = 'F:\zn1\znMCM\MsCeleb1M_code\code_openface\QAoutput';
d = dir(pathFolder);
isub = [d(:).isdir]; 
nameFolds = {d(isub).name}';
nameFolds(ismember(nameFolds,{'.','..'})) = [];

%creat result file
dst = '../../deblur_output/';
    if ~exist(dst, 'dir')
        mkdir('../../deblur_output/');
        mkdir('../../deblur_output/middle_match_examplar/');  
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
    namelist = {};
    fidm = fopen([blurlist subject_id '_blur_list.csv'], 'r');
    C = textscan(fidm, '%s');
    C1=C{1}; 
    %destination
    dstq = ['../../deblur_output/middle_match_examplar/' subject_id '/'];
    if ~exist(dstq, 'dir')
        mkdir(['../../deblur_output/middle_match_examplar/' subject_id '/']);
    end
    
%     destination = dstq;
   for j = 1:length(files)    
      testImg = imread([src files(j).name]); % change it to your own face images
      flag = 0;
     
      for i=1:length(C1)
        if( strcmp(C1{i},files(j).name))
           flag=1; %exist in list,do deblur enhancement
           break;
        end
      end
      if(flag == 0) %not exist, overlook it
%           source = [src files(j).name] ;
%           copyfile(source,destination); 
          continue;
      end

    % For speed, we imresize the input and exemplar.
    testImg = imresize(testImg,[size(testImg,1), size(testImg,2)]/2,'bilinear');
    %figure; imshow(testImg)
    ori_test = double(testImg);
    if size(testImg,3) == 3
        testImg = rgb2gray(testImg);
    end
    testImg = im2double(testImg);
    % Imgx = conv2(testImg, dx, 'valid');
    % Imgy = conv2(testImg, dy, 'valid');
    [Imgx, Imgy] = gradient(testImg);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    Imgx = Imgx./norm(Imgx(:));
    Imgy = Imgy./norm(Imgy(:));
    test_grad = [Imgx(:); Imgy(:)];
    %%
    val = zeros(length(dir_im),1);
    for i =1:150%length(dir_im)/10 %10
        imName = dir_im(i).name;%
        I = imread([inpath(1:end - 5) imName]);
        I = imresize(I,[size(testImg,1), size(testImg,2)],'bilinear');
        Mask = imread([inpath(1:end - 6) '_mask\' imName(1:end - 4) '_mask.png']);
        Mask = imresize(Mask,[size(testImg,1), size(testImg,2)],'bilinear');
        Mask = double(im2bw(Mask));
        if size(I,3) == 3
            I = rgb2gray(I);
        end
        I = im2double(I);
        %     Ix = conv2(I, dx, 'valid');
        %     Iy = conv2(I, dy, 'valid');
        [Ix, Iy] = gradient(I);
        Mag = sqrt(Ix.^2 + Iy.^2).*Mask;
        Mag = Mag./norm(Mag(:));
        tt1x = Ix;%.*Mask;
        tt1y = Iy;%.*Mask;
        tt1x = tt1x./norm(tt1x(:));
        tt1y = tt1y./norm(tt1y(:));
        %% equation (3) in paper
        val(i) = gradient_similarity([Imgx(:); Imgy(:)] ,[tt1x(:);tt1y(:)]); 
        i
    end
    
    [VALS, IDX] = sort(val,'descend');
    match_name = dir_im(IDX(1)).name; %% find the largest values
    eval(sprintf('save  %s VALS IDX val match_name' ,[dstq files(j).name(1:end-4) '.mat']));
   
  end
  fclose(fidm);

end