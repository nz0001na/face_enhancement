%all images
clear; clc;
close all;

%      name='86';
      X = imread(['86.jpg']); % change it to your own face images    
      try
            X = rgb2gray(X);
        catch exception
       end
      img_out_name = '86_1.jpg'; 
      X=normalize8(imresize(X,[128,128],'bilinear'));
      %% Apply the photometric normalization techniques
      %Weberfaces
      Y = weberfaces(X); %reflectance
      figure;imshow(Y,[]);title('Y');
      out_image = normalize8(Y);
      figure;imshow(normalize8(Y),[]);title('N_Y');
      % Save results
      imwrite(out_image/256,img_out_name);
