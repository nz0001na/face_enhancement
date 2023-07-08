pathFolder='F:\zn1\znMCM\MsCeleb1M_code\deep_features\';
%high features
data_H = importdata([pathFolder 'ijba_quality_high_clm_aligned_features_eltwise_fc1.mat']);
feature_H = data_H.features;
path_H = data_H.image_path;
subID_H = [];
for i=1:length(path_H)
    path1 = path_H{1,i};
    S1 = regexp(path1, '/', 'split');
    subID_H = [subID_H;S1(9)];
end