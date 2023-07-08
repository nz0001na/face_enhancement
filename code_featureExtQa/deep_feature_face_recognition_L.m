pathFolder='F:\zn1\znMCM\MsCeleb1M_code\deep_features\';

data_H = importdata([pathFolder '0120_V/ijba_quality_high_clm_aligned_features_eltwise_fc1.mat']);
feature_H = data_H.features;
path_H = data_H.image_path;
subID_H = [];
for i=1:length(path_H)
    path1 = path_H{1,i};
    S1 = regexp(path1, '/', 'split');
    subID_H = [subID_H;S1(9)];
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

dst = '../facerecognitionL/deep/';
    if ~exist(dst, 'dir')
        mkdir(['../facerecognitionL/deep/']);
    end
    
%face recognition
RanktList = [];
%numt=1;
for n = 1:length(subID_L)    
    fprintf('probe:%d/%d %s\n', n, length(subID_L) , subID_L {n,1});
    subject_id_probe = subID_L {n,1};   %probe subjectId 
    feature_id_probe = feature_L(n,:);
    
        % m:gallery subjects
        ImageScoreList = zeros(length(subID_H) ,2);  
        for m = 1:length(subID_H)    
            fprintf('    gallery:%d/%d %s\n', m, length(subID_H), subID_H{m,1});
            subject_id_gallery = subID_H{m,1};  
            feature_id_gallery = feature_H(n,:);
            
            %compute sililarity score 
            simi_score = dot(feature_id_gallery,feature_id_probe)/(norm(feature_id_gallery)*norm(feature_id_probe));     
            ImageScoreList(m,1)= str2num(subject_id_gallery);
            ImageScoreList(m,2)= simi_score;  
        end
        ImageSortScoreList = sortrows(ImageScoreList,-2)     
        t = find(ImageSortScoreList(:,1)==str2num(subject_id_probe));        
        RanktList = [RanktList;t];
        %numt = numt+1;
 end
 %save t list 
 csvwrite([dst 'listk.csv'], RanktList);

 %RanktList:compute cmc(t)
 cmclist = [];
 a=1;
 [val, indx] = max(RanktList); 
 for k=1:val
     cmck = length(find(RanktList>0&RanktList<=k)) / size(RanktList, 1);
     cmclist(k,1)=k;
     cmclist(k,2)=cmck;
     a=a+1;
 end
 %save cmck list 
 csvwrite([dst 'listcmck.csv'], cmclist);


