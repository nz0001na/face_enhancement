clear;clc;
close all;

pathFolder = 'F:\zn1\znMCM\MsCeleb1M_code\code_face_recognition_enhancedface_with_VGGface\enhanced images\deblur\middle_faces';
d = dir(pathFolder);
isub = [d(:).isdir]; % returns logical vector
nameFolds = {d(isub).name}';
nameFolds(ismember(nameFolds,{'.','..'})) = [];
namelist = {};

for n=1:length(nameFolds)
     fprintf('%d/%d %s\n', n, length(nameFolds), nameFolds{n});
     subject_id = nameFolds{n};   %probe subjectId 
    
     files = dir([pathFolder '/' subject_id '/*.jpg']);
     count = length(files);
     if count == 0
         continue;
     else
         for i =1:count
             namelist = [namelist; {subject_id, files(i).name}];
         end
     end   
end
save('namelist_deblur_middle.mat','namelist');

