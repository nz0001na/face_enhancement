clear;clc;
close all;

% generate positive pairs and corresponding features
% low vs. high
probe_path = 'F:\zn1\znMCM\MsCeleb1M_code\code_deep_fr\feature_output\FaceNet\0126_V\low';
d = dir(probe_path);
isub = [d(:).isdir]; 
nameFolds = {d(isub).name}';
nameFolds(ismember(nameFolds,{'.','..'})) = [];
gallery_path = 'F:\zn1\znMCM\MsCeleb1M_code\code_deep_fr\feature_output\FaceNet\0126_V\high';

% destination
dst = '../pairs_features/FaceNet/0126_V_LvsH/';
if ~exist(dst,'dir')
    mkdir(['../pairs_features/FaceNet/0126_V_LvsH/']);
end
% create pairs
fpos_pairs = fopen([dst 'pos_pairs.csv'], 'w');
pos_probe_feature = [];
pos_gallery_feature = [];


for n=1:length(nameFolds) % low faces ---probe
    fprintf('%d/%d %s\n', n, length(nameFolds), nameFolds{n});
    subject_id_probe = nameFolds{n};   
    %% get probe names
    fnames_Probe = fopen([probe_path '/' subject_id_probe '/' subject_id_probe '_name.csv'], 'r');
    P = textscan(fnames_Probe, '%s');
    if(isempty(P{1}))
       continue;
    else
       P1 = P{1};
    end;
    %get probe features
    ffeature_Probe = csvread([probe_path '/' subject_id_probe '/' subject_id_probe '_feature.csv']); 
    if(size(ffeature_Probe,1)==0)
        continue;
    end
    
    %% get gallery names
    subject_id_gallery = subject_id_probe;
    fnames_Gallery = fopen([gallery_path '/' subject_id_gallery '/' subject_id_gallery '_name.csv'], 'r');
    G= textscan(fnames_Gallery, '%s');
    if(isempty(G{1}))
       continue;
    else
       G1 = G{1};
    end;
    
    %get gallary features
    ffeature_Gallery = csvread([gallery_path '/' subject_id_gallery '/' subject_id_gallery '_feature.csv']); 
    if(size(ffeature_Gallery,1)==0)
        continue;
    end
    
    %% create pairs
    for i=1:size(ffeature_Probe,1) % probe name and feature
        p_feat = ffeature_Probe(i,:);          
        pname = P1(i);      
        p_name = char(pname(1,1));

       for j=1:size(ffeature_Gallery,1)  % gallery name and feature
           g_feat = ffeature_Gallery(j,:);          
           gname = G1(j);      
           g_name = char(gname(1,1));
     
           fprintf(fpos_pairs, '%s,%s,%s,%s\n', p_name, subject_id_probe, g_name, subject_id_gallery); 
           pos_probe_feature = [pos_probe_feature;p_feat];
           pos_gallery_feature = [pos_gallery_feature;g_feat];

       end
    end
    
    fclose(fnames_Probe);
    fclose(fnames_Gallery);
end

 csvwrite([dst 'pos_low_feature.csv'], pos_probe_feature);
 csvwrite([dst 'pos_high_feature.csv'], pos_gallery_feature);
fclose(fpos_pairs);

