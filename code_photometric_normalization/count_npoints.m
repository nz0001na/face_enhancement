clear;clc;
close all;

pathFolder = 'F:\zn1\znMCM\MsCeleb1M_code\code_openface\photometric_npoint68\';

%count low
path_H = [pathFolder 'low_pose\'];
d = dir(path_H);
isub = [d(:).isdir]; % returns logical vector
nameFolds = {d(isub).name}';
nameFolds(ismember(nameFolds,{'.','..'})) = [];
countH = [];
for n = 1:length(nameFolds)
    fprintf('low: %d/%d %s\n', n, length(nameFolds), nameFolds{n});
    subject_id = nameFolds{n};
    
    files = dir([path_H subject_id '\*.bmp']);
    countH(n,:)=[str2double(subject_id),length(files)];
       
end
num_images = sum(countH(:,2));
countH(length(nameFolds)+1,2)=num_images;
csvwrite(['F:\zn1\znMCM\MsCeleb1M_code\code_openface\photometric_npoint68\low_npoints.csv'], countH);   