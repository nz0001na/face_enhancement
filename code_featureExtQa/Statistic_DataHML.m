clear;clc;
close all;
% count images of dataset
pathFolder = 'F:\zn1\znMCM\MsCeleb1M_code\datasets_facescrub\statistic_rqs_3f\QAoutput\';
d = dir(pathFolder);
isub = [d(:).isdir]; % returns logical vector
nameFolds = {d(isub).name}';
nameFolds(ismember(nameFolds,{'.','..'})) = [];

count_list = {};
count = 0;
for n = 1:length(nameFolds)
    fprintf('%d/%d %s\n', n, length(nameFolds), nameFolds{n});
    subject_id = nameFolds{n};
    
    high = [pathFolder subject_id '/high/'];
    middle = [pathFolder subject_id '/middle/'];
    low = [pathFolder subject_id '/low/'];
    
    file_h = dir([high '*.jpg']);
    file_m = dir([middle '*.jpg']);
    file_l = dir([low '*.jpg']);
    
    count_list{n,1} = subject_id;
    count_list{n,2} = length(file_h);
    count_list{n,3} = length(file_m);
    count_list{n,4} = length(file_l);
    
end
count_h = cell2mat(count_list(:,2));
num_h = sum(count_h);

count_m = cell2mat(count_list(:,3));
num_m = sum(count_m);

count_l = cell2mat(count_list(:,4));
num_l = sum(count_l);

count_list{length(nameFolds)+1,2}=num_h;
count_list{length(nameFolds)+1,3}=num_m;
count_list{length(nameFolds)+1,4}=num_l;

aa = tabulate(count_l(:));

% save data
[nrows,ncols]= size(count_list);
filename = [pathFolder 'counts.csv'];
fid = fopen(filename, 'w');
for row=1:nrows
    fprintf(fid, '%s,%d,%d,%d\n', count_list{row,:});
end
fclose(fid);




