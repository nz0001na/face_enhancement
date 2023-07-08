clear;clc
close all;

pathFolder = 'F:\zn1\znMCM\MsCeleb1M_code\cropped_output\frontalization\low_xyz_rgb';
d = dir(pathFolder);
isub = [d(:).isdir]; 
nameFolds = {d(isub).name}';
nameFolds(ismember(nameFolds,{'.','..'})) = [];
srcunfront = 'F:\zn1\znMCM\MsCeleb1M_code\code_openface\QAoutput';

frontlist='F:\zn1\znMCM\MsCeleb1M_code\code_openface\blur_list\low_sharpness_new_frontal';
unfrontlist = 'F:\zn1\znMCM\MsCeleb1M_code\code_openface\blur_list\low_sharpness_new_unfrontal';

dst = ['../cropped_output/deblur/low_sharpness_new/'];
 if ~exist(dst, 'dir')
        mkdir(['../cropped_output/deblur/low_sharpness_new/']);
 end
count=0;
for n = 1:length(nameFolds)
    fprintf('%d/%d %s\n', n, length(nameFolds), nameFolds{n});
    subject_id = nameFolds{n};

    dstq = [dst subject_id '/'];
    if ~exist(dstq, 'dir')
        mkdir([dst subject_id '/']);
   end
 
    %% read front list
    filesfront = dir([pathFolder '/' subject_id '/*.jpg']);
     if(isempty(filesfront))
       continue;
     end
    ffront = fopen([frontlist '/' subject_id '_blur_list.csv'], 'r');
    C = textscan(ffront, '%s');
    if(isempty(C{1}))
       continue;
    else
       C1 = C{1};
    end;
    
     for i=1:length(C1) 
        name_sc = C1(i);  
        flag=0;
        for j=1:length(filesfront)
            if(strcmp(filesfront(j).name,name_sc ))
               srcfile = [pathFolder '/' num2str(subject_id) '/' filesfront(j).name];
               copyfile(srcfile,dstq);
               count=count+1;
               flag=1; %exist in files
              break;
            end
        end
%         if(flag==1)
%               copyfile(srcfile,dstq);
%               count=count+1;
%         end
    end
    fclose(ffront);
    
    
    %% read unfront files
    filesunfront = dir([srcunfront '/' subject_id '/low/*.jpg']);
    funfront = fopen([unfrontlist '/' subject_id '_blur_list.csv'], 'r');
    D = textscan(funfront, '%s');
    if(isempty(D{1}) || isempty(filesunfront))
       continue;
    else
       D1 = D{1};
    end;
    
     for m=1:length(D1) 
        name_sc = D1(m);  
        flag=0;
        for n=1:length(filesunfront)
            if(strcmp(filesunfront(n).name,name_sc ))
              copyfile([srcunfront '/' num2str(subject_id) '/low/' filesunfront(n).name],dstq);
              count=count+1;
              flag=1; %exist in files
              break;
            end
        end
%         if(flag==1)
%              copyfile([srcunfront '/' num2str(subject_id) '/low/' name_sc],dstq);
%              count=count+1;
%         end
    end
    fclose(funfront);
  
end