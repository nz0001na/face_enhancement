pathFolder='F:\zn1\znMCM\MsCeleb1M_code\deep_features\';
%high features
data_H = importdata([pathFolder '0120_V/ijba_quality_high_clm_aligned_features_eltwise_fc1.mat']);
feature_H = data_H.features;
path_H = data_H.image_path;
subID_H = [];
for i=1:length(path_H)
    path1 = path_H{1,i};
    S1 = regexp(path1, '/', 'split');
    subID_H = [subID_H;S1(9),S1(10)];
end
%middle features
data_M = importdata([pathFolder '0120_V/ijba_quality_mid_clm_aligned_features_eltwise_fc1.mat']);
feature_M = data_M.features;
path_M = data_M.image_path;
subID_M = [];
for i=1:length(path_M)
    path2 = path_M{1,i};
    S2 = regexp(path2, '/', 'split');
    subID_M = [subID_M;S2(9),S2(10)];
end

data_L = importdata([pathFolder '0120_V/ijba_quality_low_clm_aligned_features_eltwise_fc1.mat']);
feature_L = data_L.features;
path_L = data_L.image_path;
subID_L = [];
for i=1:length(path_L)
    path3 = path_L{1,i};
    S3 = regexp(path3, '/', 'split');
    subID_L = [subID_L;S3(9),S3(10)];
end
