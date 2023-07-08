clear; clc;
close all;

pathFolder = 'F:\zn1\znMCM\MsCeleb1M_code\phometric_norm_output\middle_rgb_measure\';
d = dir(pathFolder);
isub = [d(:).isdir]; % returns logical vector
nameFolds = {d(isub).name}';
nameFolds(ismember(nameFolds,{'.','..'})) = [];

enhan_path = 'F:\zn1\znMCM\MsCeleb1M_code\cropped_output\phometric_norm\middle_rgb_measure\';

dst = 'F:\zn1\znMCM\MsCeleb1M_code\code_face_recognition_enhancedface_with_VGGface\photometric\middle_faces\';

for n=1:length(nameFolds)
    fprintf('%d/%d %s\n', n, length(nameFolds), nameFolds{n});
    subject_id = nameFolds{n};
    
    src_folder = [pathFolder subject_id '/'];
    enhan_folder = [enhan_path subject_id '/'];
    
    dstq = [ dst subject_id '/'];
    if ~exist(dstq, 'dir')
        mkdir(dstq);
    end
    
    src_files = dir([src_folder '*.jpg']);
    enhan_files = dir([enhan_folder '*.jpg']);
    
    for i=1:length(src_files)
        src_name = src_files(i).name;
        flag=0; %non exist
        for j=1:length(enhan_files)
            enhan_name = enhan_files(j).name;
            if (strcmp(enhan_name,src_name))
                flag = 1; %exist
                break;
            end
        end
        if(flag == 1)
            copyfile([src_folder src_name], dstq); 
        end
        
    end
end