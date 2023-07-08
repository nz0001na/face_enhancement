addpath calib

pathFolder = 'F:\zn1\znMCM\MsCeleb1M_code\code_openface\QAoutput';
d = dir(pathFolder);
isub = [d(:).isdir]; 
nameFolds = {d(isub).name}';
nameFolds(ismember(nameFolds,{'.','..'})) = [];

%creat result file
dst = 'F:\zn1\znMCM\MsCeleb1M_code\frontalize_output\middle_QA\';
    if ~exist(dst, 'dir')
        mkdir('F:\zn1\znMCM\MsCeleb1M_code\frontalize_output\middle_QA\');  
    end
    
poselist = 'F:\zn1\znMCM\MsCeleb1M_code\code_openface\pose\middle\';

for n = 1:30%length(nameFolds)
    fprintf('%d/%d %s\n', n, length(nameFolds), nameFolds{n});
    subject_id = nameFolds{n};
    
    %images
    src = [pathFolder '/' subject_id '/middle/'];
    files = dir([src '*.jpg']);
    %list
    fidm = fopen([poselist subject_id '_pose_list.csv'], 'r');
    C = textscan(fidm, '%s');
    C1=C{1}; 
    %destination
    dstq = [dst subject_id '/'];
    if ~exist(dstq, 'dir')
        mkdir([dst subject_id '/']);
    end

    for j = 1:length(files)    
      flag = 0;
      for i=1:length(C1)
        if( strcmp(C1{i},files(j).name))
           flag=1; %exist in list,undo
           break;
        end
      end
      if(flag == 1) %exist, undo
          source = [src files(j).name] ;
          copyfile(source,dstq); 
          continue;
      end
      % Load query image
      I_Q = imread([src files(j).name]); % chang
      I_Q = repmat(I_Q,[1 1 3]);
%       I_Q = imresize(I_Q, [256 256]);
      I_Q=imresize(I_Q,3,'bilinear');

        if max(size(I_Q))>1200 % avoid too large image
            I_Q = imresize(I_Q, 1200/max(size(I_Q)), 'bilinear');
        end
        
      % load some data
      load eyemask eyemask % mask to exclude eyes from symmetry
      load DataAlign2LFWa REFSZ REFTFORM % similarity transf. from rendered view to LFW-a coordinates

      % IMPORTANT: Choose facial landmark detector. 
      % detector = 'SDM'; % alternatively 'ZhuRamanan', 'dlib', 'FivePoints'
      detector = 'dlib';

      % Note that the results in the paper were produced using SDM. We have found
      % other detectors to produce inferior frontalization results. 
      fidu_XY = [];
      facial_feature_detection;
      if isempty(fidu_XY)   
          error('Failed to detect facial features / find face in image.');
      end     
      
      % Estimate projection matrix C_Q
      [C_Q, ~,~,~] = estimateCamera(Model3D, fidu_XY);

      % Render frontal view
      [frontal_sym, frontal_raw] = Frontalize(C_Q, I_Q, Model3D.refU, eyemask);

      % Apply similarity transform to LFW-a coordinate system, for compatability
      % with existing methods and results
      frontal_sym = imtransform(frontal_sym,REFTFORM,'XData',[1 REFSZ(2)], 'YData',[1 REFSZ(1)]);
      frontal_raw = imtransform(frontal_raw,REFTFORM,'XData',[1 REFSZ(2)], 'YData',[1 REFSZ(1)]);
    
      % Display results
%       figure; imshow(I_Q1); title('Query photo');
      %figure; imshow(I_Q); hold on; plot(fidu_XY(:,1),fidu_XY(:,2),'.'); 
%       hold off; title('Query photo with detections overlaid');
      
       %frontal_raw = imcrop(frontal_raw,[0 0 50 50]);  
       imwrite(frontal_raw, [dstq files(j).name]);
    end
    
    fclose(fidm);

end

