clear;clc;
close all;

addpath('./redist-source');
pathFolder = 'F:\zn1\znMCM\FaceScrub_dataset\facescrub_rqs\facescrub_rqs_data';
d = dir(pathFolder);
isub = [d(:).isdir]; % returns logical vector
nameFolds = {d(isub).name}';
nameFolds(ismember(nameFolds,{'.','..'})) = [];

%creat result file
dst = '../datasets_facescrub/statistic_rqs_3f/';
    if ~exist(dst, 'dir')
        mkdir(['../datasets_facescrub/statistic_rqs_3f/']);
    end
fr = fopen([ dst 'quality_distribution.csv'], 'w');
fprintf(fr, '%s,%s,%s,%s,%s\n', 'subject_id', 'high','middle','low','moved images');

%caculate numbers of group L,M,H
sumh=0;
suml=0;
summ=0;
for n = 1:length(nameFolds)
    fprintf('%d/%d %s\n', n, length(nameFolds), nameFolds{n});
    subject_id = nameFolds{n};

    %creat output files of H/M/L
    dstq = [ dst 'QAoutput/' subject_id '/'];
    if ~exist(dstq, 'dir')
        mkdir([dst 'QAoutput/' subject_id '/']);
        mkdir([dst 'QAoutput/' subject_id '/high/']);
        mkdir([dst 'QAoutput/' subject_id '/middle/']);
        mkdir([dst 'QAoutput/' subject_id '/low/']);
    end

    %read scores of subject_id 
    src = ['F:\zn1\znMCM\FaceScrub_dataset\facescrub_rqs\facescrub_rqs_data/' subject_id '/'];
    fid = fopen([src subject_id '_scores.csv'], 'r');
    C = textscan(fid, '%s %d');
    C1=C{1};
  
    %read features of subject_id
    format long;
    srcf = [src 'features/']; 
    F = csvread([srcf subject_id '_gaborf.csv']); %#*cols
    
    
    high=0;
    middle=0;
    low=0;
    MaxScore=0;
    MaxIname=''; 
    maxindex=0;
    MaxScore2=0;
    MaxIname2=''; 
    maxindex2=0;    
    MaxScore3=0;
    MaxIname3=''; 
    maxindex3=0;
    h_feat = [];
    m_feat = [];
    l_feat = [];
    l=1;
    m=1;
    h=1;
    fh = fopen([dstq subject_id '_high_scores.csv'], 'w');
    fm = fopen([dstq subject_id '_middle_scores.csv'], 'w');
    fl = fopen([dstq subject_id '_low_scores.csv'], 'w');
      
    %define destination files of images
    nfnH = [dstq 'high/' ];        %destination file of HighQ
    nfnM = [dstq 'middle/' ];   %destination file of MiddleQ
    nfnL = [dstq 'low/' ];   %destination file of LowQ
    d = [dst 'ML2Himage/']; 
    s = [dstq 'high/' MaxIname ];
    
    %find max score index j -1
     for j = 1:length(C1)    
        %get image name and score
        name_sc = C1(j)      
        name_sco = deblank(name_sc)
        name_scor = regexp(name_sco, ',', 'split')
        name_score=name_scor{1}
        name1=char(name_score(1,1))
        score1=str2num(char(name_score(1,2)))
        if score1 >= MaxScore
            MaxScore=score1;
            MaxIname=name1;
            maxindex=j;
        end;   
     end
    %2
    for j = 1:length(C1)    
        %get image name and score
        name_sc = C1(j)      
        name_sco = deblank(name_sc)
        name_scor = regexp(name_sco, ',', 'split')
        name_score=name_scor{1}
        name1=char(name_score(1,1))
        score1=str2num(char(name_score(1,2)))
        if score1 >= MaxScore2 && score1 <= MaxScore && j ~= maxindex
            MaxScore2=score1;
            MaxIname2=name1;
            maxindex2=j;
        end;   
    end
      %3
     for j = 1:length(C1)    
        %get image name and score
        name_sc = C1(j)      
        name_sco = deblank(name_sc)
        name_scor = regexp(name_sco, ',', 'split')
        name_score=name_scor{1}
        name1=char(name_score(1,1))
        score1=str2num(char(name_score(1,2)))
        if score1 >= MaxScore3 && score1 <= MaxScore2 && j~=maxindex2 && j~=maxindex
            MaxScore3=score1;
            MaxIname3=name1;
            maxindex3=j;
        end;   
      end
    
    names = ''; 
    for i = 1:length(C1)        
        %get image name and score
        iname_sc = C1(i)      
        iname_sco = deblank(iname_sc)
        iname_scor = regexp(iname_sco, ',', 'split')
        iname_score=iname_scor{1}
        iname=char(iname_score(1,1))
        score=str2num(char(iname_score(1,2)))        
        %get features
        feature_i = F(i,:);
        
        %define source file of images 
        ofn = ['F:\zn1\znMCM\FaceScrub_dataset\facescrub_rqs/facescrub_rqs_images/' subject_id '/' iname ]; %source file          
        if score >= 60
            high=high+1;
            %high pic to high files
            copyfile(ofn,nfnH);          % copy file   
            fprintf(fh, '%s,%d\n', iname,score);
            h_feat(h,:) = F(i,:);
            h=h+1;
        end
        if score < 60 && score >= 30
            if(i==maxindex || i==maxindex2 || i==maxindex3 )  
                 high=high+1;
                 copyfile(ofn,nfnH);          % copy file   
                 fprintf(fh, '%s,%d\n', iname,score);
                 h_feat(h,:) = F(i,:);
                 h=h+1;
                 names = [names '*' iname];
            else
                 middle=middle+1;
                 copyfile(ofn,nfnM); 
                 fprintf(fm, '%s,%d\n', iname,score);                           
                 m_feat(m,:) = F(i,:);
                 m=m+1;
            end  
        end
        if score < 30 && score >=0         
            if(i==maxindex || i==maxindex2 || i==maxindex3)
                 high=high+1;
                 copyfile(ofn,nfnH);          % copy file   
                 fprintf(fh, '%s,%d\n', iname,score);                
                 h_feat(h,:) = F(i,:);
                 h=h+1;
                 names = [names '*' iname];
            else
                low=low+1;
                copyfile(ofn,nfnL); 
                fprintf(fl, '%s,%d\n', iname,score);
                l_feat(l,:) = F(i,:);
                l=l+1;
            end           
        end
    end
    csvwrite([dstq subject_id '_high_feature.csv'], h_feat);
    csvwrite([dstq subject_id '_middle_feature.csv'], m_feat);
    csvwrite([dstq subject_id '_low_feature.csv'], l_feat);
   
    %Statistic of sum of H/M/L
    sumh = sumh + high;
    summ = summ + middle;
    suml = suml + low;
%     if(high=0)cout=cout+1;
%          %MaxScore;MaxIname
%          %remove the image with max score to high
%          if(MaxScore>=30 && MaxScore<60)
%          destinationH = [dstq 'high/' ];        %destination file of HighQ
%          sourceM = [dstq 'middle/' MaxIname ];
%          copyfile(sourceM,destinationH); 
%          delete(sourceM)
% %          high=high+1;
% %          middle=middle-1;
%          end
%          if(MaxScore>=0 && MaxScore<30)
%          destinationH = [dstq 'high/' ];        %destination file of HighQ
%          sourceM = [dstq 'low/' MaxIname ];
%          copyfile(sourceM,destinationH); 
%          delete(sourceM)
% %          high=high+1;
% %          low=low-1;
%          end
%          %copy ML2H images
%          copyfile(s,d); 
%          
%     end
%     if(middle==0)coutm=coutm+1;
%     end
%     if(low==0)coutl=coutl+1;
%     end
    
    if(high==3 && length(names) ~= 0)
        fprintf(fr, '%s,%d,%d,%d,%s\n', subject_id, high,middle,low,names);    
    else
        fprintf(fr, '%s,%d,%d,%d,%s\n', subject_id, high,middle,low,'');
    end
    
    fclose(fid);
    fclose(fh);
    fclose(fm);
    fclose(fl);
end
  fprintf(fr, '%s,%d,%d,%d,%s\n', 'summary', sumh,summ,suml,'');
  fclose(fr);
   
