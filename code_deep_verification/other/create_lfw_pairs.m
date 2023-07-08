clear;clc;
feature_path = '../feature/LFW_Feature.mat';  % feature, list
save_path = '../feature/centerloss_lfw_pairs.mat';

load(feature_path);
image_path = list';

sub_id_list = cell(1, length(image_path));
for i = 1:length(image_path)
    [pth,name,ext] = fileparts(image_path{i});
    parts = strsplit(name, '_');
    sub_id = strjoin(parts(1:end-1), '_');
    sub_id_list{i} = sub_id;
end
% unique_sub_id_list = unique(sub_id_list); % remove duplicates

fid = fopen('pos_image_pairs.txt');
C = textscan(fid, '%s %s', 'Delimiter', ',');
pos_pair = []; k = 1;
for i = 1:length(C{1})
    im_path = C{1}{i};
    parts = strsplit(im_path, '/');
    im_name = parts{2};
    IndexC = strcmp(image_path, im_name);
    Index = find(IndexC==1);
    pos_pair(1,k) = Index;

    im_path = C{2}{i};
    parts = strsplit(im_path, '/');
    im_name = parts{2};
    IndexC = strcmp(image_path, im_name);
    Index = find(IndexC==1);
    pos_pair(2,k) = Index;
    
    k = k + 1;
end

fid = fopen('neg_image_pairs.txt');
C = textscan(fid, '%s %s', 'Delimiter', ',');
neg_pair = []; k = 1;
for i = 1:length(C{1})
    im_path = C{1}{i};
    parts = strsplit(im_path, '/');
    im_name = parts{2};
    IndexC = strcmp(image_path, im_name);
    Index = find(IndexC==1);
    neg_pair(1,k) = Index;

    im_path = C{2}{i};
    parts = strsplit(im_path, '/');
    im_name = parts{2};
    IndexC = strcmp(image_path, im_name);
    Index = find(IndexC==1);
    neg_pair(2,k) = Index;
    
    k = k + 1;
end

save(save_path, 'pos_pair', 'neg_pair');


