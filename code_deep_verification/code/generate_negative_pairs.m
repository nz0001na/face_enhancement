clear;clc;
close all;

% generate nagative pairs and corresponding features
% low vs. high
probe_path = 'F:\zn1\znMCM\MsCeleb1M_code\code_deep_fr\feature_output\FaceNet\0126_V\low';
d = dir(probe_path);
isub = [d(:).isdir]; 
nameFolds = {d(isub).name}';
nameFolds(ismember(nameFolds,{'.','..'})) = [];
sum_prob = length(nameFolds);

gallery_path = 'F:\zn1\znMCM\MsCeleb1M_code\code_deep_fr\feature_output\FaceNet\0126_V\high';
dg = dir(gallery_path);
isubg = [dg(:).isdir]; 
nameFoldsg = {dg(isubg).name}';
nameFoldsg(ismember(nameFoldsg,{'.','..'})) = [];
sum_gallery = length(nameFoldsg);

% destination
dst = '../pairs_features/FaceNet/0126_V_LvsH/';
if ~exist(dst,'dir')
    mkdir(['../pairs_features/FaceNet/0126_V_LvsH/']);
end
% create pairs
fneg_pairs = fopen([dst 'neg_pairs.csv'], 'w');
neg_probe_feature = [];
neg_gallery_feature = [];

for n=1:sum_prob % low faces ---probe
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
    
    for m=1:sum_gallery       
        fprintf('  gallery: %d/%d %s\n', m, length(nameFoldsg), nameFoldsg{m});
        subject_id_gallery = nameFoldsg{m};   
        if(str2num(subject_id_probe)==str2num(subject_id_gallery))
            continue;
        end;
        
        %% get gallery names
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
     
              fprintf(fneg_pairs, '%s,%s,%s,%s\n', p_name, subject_id_probe, g_name, subject_id_gallery); 
              neg_probe_feature = [neg_probe_feature;p_feat];
              neg_gallery_feature = [neg_gallery_feature;g_feat];
           end
       end
       fclose(fnames_Gallery);
    end
    
    fclose(fnames_Probe);
end

 csvwrite([dst 'neg_low_feature.csv'], neg_probe_feature);
 csvwrite([dst 'neg_high_feature.csv'], neg_gallery_feature);
fclose(fneg_pairs);
