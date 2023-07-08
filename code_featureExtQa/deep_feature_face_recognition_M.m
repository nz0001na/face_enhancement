pathFolder='F:\zn1\znMCM\MsCeleb1M_code\deep_features\';
%high features
data_H = importdata([pathFolder '0120_V/ijba_quality_high_clm_aligned_features_eltwise_fc1.mat']);
feature_H = data_H.features;
path_H = data_H.image_path;
subID_H = [];
imageID_H = [];
for i=1:length(path_H)
    path1 = path_H{1,i};
    S1 = regexp(path1, '/', 'split');
    subID_H = [subID_H;S1(9)];
    imageID_H = [imageID_H;S1(9),S1(10)];
end
subID_H = unique (subID_H);         

%middle features
data_M = importdata([pathFolder '0120_V/ijba_quality_mid_clm_aligned_features_eltwise_fc1.mat']);
feature_M = data_M.features;
path_M = data_M.image_path;
subID_M = [];
imageID_M = [];
for i=1:length(path_M)
    path2 = path_M{1,i};
    S2 = regexp(path2, '/', 'split');
    subID_M = [subID_M;S2(9)];
    imageID_M = [imageID_M;S2(9),S2(10)];
end
subID_M = unique (subID_M);  

dst = '../facerecognitionM/deep/V2/';
    if ~exist(dst, 'dir')
        mkdir(['../facerecognitionM/deep/V2/']);
    end
    
%face recognition
RanktList = [];
numt=1;
%probe middle vs gallery high
for n = 1:length(subID_M)        
    fprintf('probe:%d/%d %s\n', n, length(subID_M) , subID_M{n,1});
    subject_id_probe = subID_M {n,1};   %probe subjectId 
    
    rows_probe = find(imageID_M(:,1)==subject_id_probe);
    %subject_f_Probe= imageID_M(find(imageID_M(:,1)==subject_id_probe),:) 
    

    
    
    srcm = [pathFolder '\'];
    fsubject_s_Probe = fopen([srcm subject_id_probe '/' subject_id_probe '_scores.csv'], 'r');
    C = textscan(fsubject_s_Probe, '%s');

    %probe: feature of each subject
    subject_f_Probe = csvread([srcm subject_id_probe '/' subject_id_probe '_gaborf.csv']); 
    if(size(subject_f_Probe,1)==0)
        continue;
    end
 
    %define a list of each subject BL
    fprobeList = fopen([dst 'ProbeScore/' num2str(subject_id_probe) '_probe_scorelist.csv'], 'w');
    fprintf(fprobeList, '%s,%s,%s,%s\n', 'subject_id_gallery', 'scores','image_id_probe','subject_id_probe');
         
    % each probe subject, has l samples
    for l=1:size(subject_f_Probe,1)
        BLj = subject_f_Probe(l,:);       
        name_sc = C1(l);      
        name_sco = deblank(name_sc);
        name_scor = regexp(name_sco, ',', 'split');
        name_score=name_scor{1}
        name1=char(name_score(1,1))
%         score1=str2num(char(name_score(1,2)))       
        imageprobe = name1;
         
        ImageScoreList = zeros(sum_subh,2);  
        % m:gallery subjects
        for m = 1:sum_subh
            fprintf('    gallery:%d/%d %s\n', m, sum_subh, nameFoldsh{m});
            subject_id_gallery = nameFoldsh{m};  %gallery subjectId  ??gallery subjects
            %gallery: feature of each subject
%             fsubject_s_Gallery = fopen([srch subject_id_gallery '/' subject_id_gallery '_scores.csv'], 'r');
%             B = textscan(fsubject_s_Gallery, '%s');
%             if(isempty(B{1}))
%                   continue;
%             end;
            subject_f_Gallery = csvread([srch subject_id_gallery '/' subject_id_gallery '_high_feature.csv']); 
            if(size(subject_f_Gallery,1)==0)
                continue;
            end
    
            %compute sililarity score for BLj,BIp(each image of probe)
            simList = zeros(size(subject_f_Gallery,1),1);  
            for i=1:size(subject_f_Gallery,1)               
               BIp = subject_f_Gallery(i,:);
               %simi_score = dot(BIp,BLj)/(norm(BIp,2)*norm(BLj,2)); 
               simi_score = dot(BIp,BLj)/(norm(BIp)*norm(BLj)); 
               simList(i) = simi_score;    
            end
            avg = mean(simList);  
            
            ImageScoreList(m,1)= str2num(subject_id_gallery);
            ImageScoreList(m,2)= avg;
            
            %add list  
            fprintf(fprobeList, '%s,%f,%s,%s\n', subject_id_gallery, avg,imageprobe,subject_id_probe);  
%             fclose(fsubject_s_Gallery);
        end
        %fclose(fBLjRankList);
        ImageSortScoreList = sortrows(ImageScoreList,-2)     
        t = find(ImageSortScoreList(:,1)==str2num(subject_id_probe));        
        RanktList(numt,1)=t;
        numt = numt+1;
    end      
  fclose(fsubject_s_Probe);
  fclose(fprobeList);
end
 %save t list 
 csvwrite([dst 'listk.csv'], RanktList);

 %RanktList:compute cmc(t)
 cmclist = [];
 a=1;
 [val, indx] = max(RanktList); 
 for k=1:val
     cmck = length(find(RanktList>0&RanktList<=k)) / size(RanktList, 1);
     %cmck = numel(RanktList(RanktList<k+1)) / size(RanktList, 1);  
     cmclist(k,1)=k;
     cmclist(k,2)=cmck;
     a=a+1;
 end
 %save cmck list 
 csvwrite([dst 'listcmck.csv'], cmclist);














