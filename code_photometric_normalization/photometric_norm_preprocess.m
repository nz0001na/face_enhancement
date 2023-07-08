addpath('F:\zn1\znMCM\MsCeleb1M_code\code_photometric_normalization\INFace_zip_no_mex\INface_tool\photometric\');

%%
src = 'F:\zn1\znMCM\MsCeleb1M_code\enhancement_process\QAoutput\1\middle\';
dst = '../enhancement_process/face_photometric/middle/';


files = dir([src '*.jpg']);
%% Apply the photometric normalization techniques


siz = [3 5 11 15];
sigma = [0.9 0.9 0.9 0.9];

for i = 1:length(files)
    fprintf('%d/%d\n', i, length(files));
    X = imread([src files(i).name]);
%     Y=single_scale_retinex(X); %SSR single scale retinex technique
%     Y=multi_scale_retinex(X); %MSR mutli scale retinex technique
%     Y=adaptive_single_scale_retinex(X); % ASR adaptive single scale retinex technique
%     imwrite(Y/255, [dst files(i).name]);
    
%      Y=homomorphic(X); % HOMO homomorphic filtering
%      imwrite(Y, [dst files(i).name]);    
     
%     Y=single_scale_self_quotient_image(X); % SSQ single scale self quotient image technique.
%     imwrite(Y/255, [dst files(i).name]);

%     Y=multi_scale_self_quotient_image(X); % MSQ multi scale self quotient image technique.
%     imwrite(Y/255, [dst files(i).name]);
    
%      Y=DCT_normalization(X); %DCT DCT-based normalization technique.
%      imwrite(Y/255, [dst files(i).name]);

%     Y=wavelet_normalization(X);%WA wavelet-based normalization technique.
%     imwrite(Y/255, [dst files(i).name]);

%     Y=wavelet_denoising(X,'coif1',3); %WD wavelet-denoising-based normalization technique.
%     Y=wavelet_denoising(X,'coif1',2); %WD wavelet-denoising-based normalization technique.
%     imwrite(Y/255, [dst files(i).name]);

    % **requires square image.
%     Y=isotropic_smoothing(X); %IS isotropic diffusion-based normalization technique.
    % **requires square image.
%     Y=anisotropic_smoothing(X); %AS anisotropic diffusion-based normalization technique.
% 
%     Y=nl_means_normalization(X); %NLM non-local-means-based normalization technique.
%     imwrite(Y/255, [dst files(i).name]);
    
%     Y=adaptive_nl_means_normalization(X); %ANL adaptive non-local-means-based normalization technique.
%     imwrite(Y/255, [dst files(i).name]);

%     Y = steerable_gaussians(X); %SF steerable filter based normalization technique.
%     imwrite(Y/255, [dst files(i).name]);

    % **requires square image.
%     Y = anisotropic_smoothing_stable(X); %MAS modified anisotropc smoothing normalization technique.
%     imwrite(Y/255, [dst files(i).name]);

%     Y = gradientfaces(X); %GRF Gradientfaces Gradientfaces normalization technique.
%     imwrite(Y/255, [dst files(i).name]);
    
%     Y = dog(log(normalize8(X)+1)); %DOG DoG filtering-based normalization technique.
%     imwrite(Y/255, [dst files(i).name]);

%     Y = tantriggs(X); %TT: Tan and Triggs normalization technique.
%     imwrite(Y/255, [dst files(i).name]);
    
%     Y = weberfaces(X); %WEB Weberfaces single scale Weberfaces normalization technique. 
%     imwrite(Y/255, [dst files(i).name]);
    
%     Y = multi_scale_weberfaces(X); %MWEB multi scale Weberfaces: multi scale Weberfaces normalization technique.
%     imwrite(Y/255, [dst files(i).name]);

    Y = lssf_norm(X); %lssf technique llsf normalization technique.
    imwrite(Y/255, [dst files(i).name]);
end

