clear;clc;
close all;

pathFolder = 'C:\Users\Na Zhang\Desktop\deblur\middle_faces\';

d = dir(pathFolder);
isub = [d(:).isdir]; % returns logical vector
nameFolds = {d(isub).name}';
nameFolds(ismember(nameFolds,{'.','..'})) = [];

countH = [];
count = 0;
for n = 1:length(nameFolds)
    fprintf('%d/%d %s\n', n, length(nameFolds), nameFolds{n});
    subject_id = nameFolds{n};
    
    files = dir([pathFolder subject_id '/*.jpg']);
    countH(n,:)=[str2double(subject_id),length(files)];
%     count = count +length(files);   
end
num_images = sum(countH(:,2));
countH(length(nameFolds)+1,2)=num_images;

% csvwrite([pathFolder 'images.csv'], countH);   



