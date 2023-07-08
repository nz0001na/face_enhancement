clear;clc;
close all;

dst_path = 'F:\zn1\znMCM\MsCeleb1M_code\code_face_recognition_enhancedface_with_VGGface\VGG_feature_output\';
dst = [dst_path 'deblur_middle/'];
if(~exist(dst))
    mkdir([dst_path 'deblur_middle/']);
end

%VGG face
namelist = importdata('namelist_deblur_middle.mat');

src = 'F:\zn1\znMCM\MsCeleb1M_code\code_face_recognition_enhancedface_with_VGGface\VGGdeep_features\';
data = importdata([src 'vggface_deblur_middle_faces.mat']);
features = data.features;
image = data.image_path;
len = length(image);
for n=1:len
    image_n = image{1,n};
    index = find(ismember(namelist, image_n));
%     IndexC = strfind(namelist, image_n); % ?? {[1], [], []}  
%     index = find(~(cellfun('isempty', IndexC))); 
    subID = namelist{index-13491,1};
    
    dstq = [dst subID '/'];
    if(~exist(dstq))
      mkdir([dst subID '/']);
    end
end



