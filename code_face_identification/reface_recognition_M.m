clear;clc;
close all;

%find source folder route of features
pathFolder = 'D:\NaZhang\vgg_face_recognition\VGG_feature_output\deblur_low';
d = dir(pathFolder);
isub = [d(:).isdir]; % returns logical vector
nameFolds = {d(isub).name}';
nameFolds(ismember(nameFolds,{'.','..'})) = [];
sum_sub= length(nameFolds);

%creat result folder
dst = 'D:\NaZhang\vgg_face_recognition\deep_facerecognition\deblur_low\';
    if ~exist(dst, 'dir')
        mkdir(dst);
        mkdir([dst 'ProbeScore/']);
    end
  
srch = 'D:\NaZhang\vgg_face_recognition\VGG_feature_output\high\';
dh = dir(srch);
isubh = [dh(:).isdir]; % returns logical vector
nameFoldsh = {dh(isubh).name}';
nameFoldsh(ismember(nameFoldsh,{'.','..'})) = [];
sum_subh= length(nameFoldsh);

RanktList = [];
%probe low vs gallery high
% n:probe subjects??probe subjects
for n = 1:sum_sub    
    fprintf('probe:%d/%d %s\n', n, sum_sub, nameFolds{n});
    subject_id_probe = nameFolds{n};   %probe subjectId 
    
    srcm = [pathFolder '\'];
    fsubject_s_Probe = fopen([srcm subject_id_probe '/' subject_id_probe '_name.csv'], 'r');
    C = textscan(fsubject_s_Probe, '%s');
    if(isempty(C{1}))
       continue;
    else
       C1 = C{1};
    end;
    %probe: feature of each subject
    subject_f_Probe = csvread([srcm subject_id_probe '/' subject_id_probe '_feature.csv']); 
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
        imageprobe=char(name_sc(1,1))    
        ImageScoreList = zeros(sum_subh,2);  
        % m:gallery subjects
        for m = 1:sum_subh
            fprintf('    gallery:%d/%d %s\n', m, sum_subh, nameFoldsh{m});
            subject_id_gallery = nameFoldsh{m};  %gallery subjectId  ??gallery subjects
            %gallery: feature of each subject
            subject_f_Gallery = csvread([srch subject_id_gallery '/' subject_id_gallery '_feature.csv']); 
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
        end
        ImageSortScoreList = sortrows(ImageScoreList,-2)     
        t = find(ImageSortScoreList(:,1)==str2num(subject_id_probe));        
        RanktList = [RanktList; t];
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
     cmclist(k,1)=k;
     cmclist(k,2)=cmck;
     a=a+1;
 end
 %save cmck list 
 csvwrite([dst 'listcmck.csv'], cmclist);
