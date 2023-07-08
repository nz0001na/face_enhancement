clc;
clear all;
close all;
addpath(genpath('boundary_proc_code'));
addpath(genpath('fina_deconvolution_code'));
addpath(genpath('boundary_proc'));
%output folder
dirname = 'data_sets_part_5_results';
k_size = [19, 17, 15, 27, 13, 21, 23, 23];
% for i=[16:20]
%    for j=[1:8]
%       input_name = sprintf('./find_structures_code/data_sets_part_5/im%02d_ker%02d_blur.png',i,j);
     name='28998_00630'; 
     y_color = imread(['./find_structures_code/' name '.jpg']);
%       y_color = repmat(y_color1,[1 1 3]);
      if size(y_color,3) == 3
          blurred = rgb2gray(y_color);
      end
      blurred = im2double(blurred);
     
      %mat_outname=sprintf('%s/im%02d_ker%02d_our.mat',dirname,i,j);
%       mat_outname = [dirname '/70_our.mat'];
%       img_out_name=sprintf('%s/im%d_ker%02d_our.png',dirname,i,j);
      img_out_name= [dirname '/' name '.jpg'];
%       k_out_name = sprintf('%s/im%02d_ker%02d_our_kernel.png',dirname,i,j);
%       k_out_name = [dirname '/70_our_kernel.jpg'];
%       d=dir(mat_outname);
      
      %%
%       eval(sprintf('load ./find_structures_code/data_sets_part_5/im%02d_ker%02d_match',i,j))
      eval(sprintf(['load ./find_structures_code/data_sets_part_5/' name]))
      
      Matched = imread(['./find_structures_code/Training/' match_name]);
      Matched = imresize(Matched,[size(blurred,1), size(blurred,2)],'bilinear');
      maskname = match_name(1:end-4);
      maskname = [maskname '_mask.png'];
      Mask = imread(['./find_structures_code/Training_mask/' maskname]);
      Mask = imresize(Mask,[size(blurred,1), size(blurred,2)],'bilinear');
      opts.kernel_size  = 19;%k_size = [19, 17, 15, 27, 13, 21, 23, 23];
      opts.xk_iter = 50;
      opts.gamma_correct = 1.0;
      %% Blind Deblur
      [interim_latent, kernel] = blind_deconv(blurred, Matched, Mask, opts);
      %% With Coarse-to-fine 
      %[interim_latent, kernel] = blind_deconv_coarse_to_fine(blurred, Matched, Mask, opts);
      %% Final deblur
      y_color = double(y_color)/255;
      deblur = [];
      for cc = 1:size(y_color,3)
          deblur(:,:,cc)=deconvSps(y_color(:,:,cc),kernel,0.001,100);
      end
      %% Save results
%       eval(sprintf('save  %s kernel deblur' ,mat_outname))
      imwrite(deblur,img_out_name);
%       kw = kernel-min(kernel(:));
%       kw = kw./max(kw(:));
%       imwrite(kw,k_out_name);
%    end
% end