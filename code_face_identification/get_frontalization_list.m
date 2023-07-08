clear;clc;
close all;

pathFolder = 'F:\zn1\znMCM\MsCeleb1M_code\cropped_output\frontalization\middle_xyz_rgb\';

d = dir(pathFolder);
isub = [d(:).isdir]; % returns logical vector
nameFolds = {d(isub).name}';
nameFolds(ismember(nameFolds,{'.','..'})) = [];

dst = 'F:\zn1\znMCM\MsCeleb1M_code\code_face_recognition_enhancedface_with_VGGface\frontalization\';
fList = fopen([dst 'high_list.csv'], 'w');
    fprintf(fList, '%s,%s\n', 'subject_id', 'name');
    
for n = 1:length(nameFolds)
    fprintf('%d/%d %s\n', n, length(nameFolds), nameFolds{n});
    subject_id = nameFolds{n};
    
    files = dir([pathFolder subject_id '/*.jpg']);
    for i = 1:length(files)
        name = files(i).name;
        fprintf(fList, '%s,%s\n', subject_id, name); 
    end
 
end

fclose(fList);
