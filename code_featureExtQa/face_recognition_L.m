clear;clc;
close all;

addpath('./redist-source');

%find source folder route of features
pathFolder = 'F:\zn1\znMCM\MsCeleb1M_code\statistic_rqs_3f\QAoutput';
d = dir(pathFolder);
isub = [d(:).isdir]; % returns logical vector
nameFolds = {d(isub).name}';
nameFolds(ismember(nameFolds,{'.','..'})) = [];
sum_sub= length(nameFolds);

%creat result folder
dst = '../facerecognitionL/';
    if ~exist(dst, 'dir')
        mkdir(['../facerecognitionL/']);
        mkdir(['../facerecognitionL/ProbeScoreL/']);
    end
  
src = ['F:\zn1\znMCM\MsCeleb1M_code\statistic_rqs_3f\QAoutput/'];  
RanktList = [];
numt=1;
%probe middle vs gallery high
% n:probe subjects??probe subjects
for n = 1:sum_sub    
    fprintf('probe:%d/%d %s\n', n, sum_sub, nameFolds{n});
    subject_id_probe = nameFolds{n};   %probe subjectId 
    fsubject_s_Probe = fopen([src subject_id_probe '/' subject_id_probe '_low_scores.csv'], 'r');
    C = textscan(fsubject_s_Probe, '%s %d');
    if(isempty(C{1}))
       continue;
    else
       C1 = C{1}
    end;
    %probe: feature of each subject
    subject_f_Probe = csvread([src subject_id_probe '/' subject_id_probe '_low_feature.csv']); 
    if(size(subject_f_Probe,1)==0)
        continue;
    end
    
    %define a list of each subject BL
    fprobeList = fopen([dst 'ProbeScoreL/' num2str(subject_id_probe) '_probe_scorelist.csv'], 'w');
    fprintf(fprobeList, '%s,%s,%s,%s\n', 'subject_id_gallery', 'scores','image_id_probe','subject_id_probe');
         
    % each probe subject, has l samples
    for l=1:size(subject_f_Probe,1)
        BLj = subject_f_Probe(l,:);       
        name_sc = C1(l)      
        name_sco = deblank(name_sc)
        name_scor = regexp(name_sco, ',', 'split')
        name_score=name_scor{1}
        name1=char(name_score(1,1))
        score1=str2num(char(name_score(1,2)))       
        imageprobe = name1;
         
        ImageScoreList = zeros(sum_sub,2);  
        % m:gallery subjects
        for m = 1:sum_sub
            fprintf('    gallery:%d/%d %s\n', m, sum_sub, nameFolds{m});
            subject_id_gallery = nameFolds{m};  
            %gallery: feature of each subject
            subject_f_Gallery = csvread([src subject_id_gallery '/' subject_id_gallery '_high_feature.csv']); 
            %fsubject_s_Gallery = fopen([src subject_id_gallery '/' subject_id_gallery '_high_scores.csv'], 'w');
            
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
        %fclose(fBLjRankList);
        ImageSortScoreList = sortrows(ImageScoreList,-2)     
        t = find(ImageSortScoreList(:,1)==str2num(subject_id_probe));        
        RanktList(numt,1)=t;
        numt = numt+1;
    end      
  fclose(fsubject_s_Probe);
  %fclose(fsubject_s_Gallery);
  fclose(fprobeList);
end
 %save t list 
 csvwrite([dst 'listk_L.csv'], RanktList);

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
 csvwrite([dst 'listcmck_L.csv'], cmclist);




