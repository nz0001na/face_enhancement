clear;clc;
close all;

% destanation of feature 
pathFolder = 'F:\zn1\znMCM\MsCeleb1M_code\code_face_recognition_enhancedface_with_VGGface\VGG_feature_output\front_middle\';
d = dir(pathFolder);
isub = [d(:).isdir]; % returns logical vector
nameFolds = {d(isub).name}';
nameFolds(ismember(nameFolds,{'.','..'})) = [];

% source files of feature
namelist = importdata('namelist_front_middle.mat');
src = 'F:\zn1\znMCM\MsCeleb1M_code\code_face_recognition_enhancedface_with_VGGface\VGGdeep_features\';
data = importdata([src 'vggface_frontal_cropped_middle_faces.mat']);
features = data.features;
image = data.image_path;
subID = [];
for i=1:length(image)
    image_i = image{1,i};
    index = find(ismember(namelist, image_i));
    id = namelist{index-3583,1};
    subID = [subID; {num2str(id)}, {image_i} ];
end
count = 0;
for n=1:length(nameFolds);
    fprintf('%d/%d %s\n', n, length(nameFolds), nameFolds{n});
    subject_id = nameFolds{n};   
    
    feature = [];
    fid = fopen([pathFolder subject_id '/' subject_id '_name.csv'], 'w');
    for j=1:length(subID)
        id = subID{j,1};
        name = subID{j,2};
        if(strcmp(id,subject_id))
            feature = [feature;features(j,:)]
            fprintf(fid, '%s\n',name);
            count = count+1;
        end
    end
   
    csvwrite([pathFolder subject_id '/' subject_id '_feature.csv'],feature);
    fclose(fid);
          
end