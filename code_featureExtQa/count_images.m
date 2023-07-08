clear;clc;
close all;
% count images of dataset
pathFolder = 'F:\zn1\znMCM\FaceScrub_dataset\facescrub_rqs\facescrub_rqs_images\';

d = dir(pathFolder);
isub = [d(:).isdir]; % returns logical vector
nameFolds = {d(isub).name}';
nameFolds(ismember(nameFolds,{'.','..'})) = [];

count_list = {};
count = 0;
for n = 1:length(nameFolds)
    fprintf('%d/%d %s\n', n, length(nameFolds), nameFolds{n});
    subject_id = nameFolds{n};
    
    files = dir([pathFolder subject_id '/*.jpg']);
    count_list{n,1} = subject_id;
    count_list{n,2} = length(files);
%     count = count +length(files);   
end
count_num = cell2mat(count_list(:,2));
num_images = sum(count_num);
count_list{length(nameFolds)+1,2}=num_images;

% save data
[nrows,ncols]= size(count_list);
filename = [pathFolder 'statistic_images.csv'];
fid = fopen(filename, 'w');
for row=1:nrows
    fprintf(fid, '%s,%d\n', count_list{row,:});
end
fclose(fid);




