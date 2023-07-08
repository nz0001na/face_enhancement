addpath calib

pathFolder = 'F:\zn1\znMCM\MsCeleb1M_code\code_openface\outputrgb';
d = dir(pathFolder);
isub = [d(:).isdir]; % returns logical vector
nameFolds = {d(isub).name}';
nameFolds(ismember(nameFolds,{'.','..'})) = [];

%creat result file
dst = 'F:\zn1\znMCM\MsCeleb1M_code\frontalize_output\low_landmark_highmean_rgb\';
    if ~exist(dst, 'dir')
        mkdir('F:\zn1\znMCM\MsCeleb1M_code\frontalize_output\low_landmark_highmean_rgb\');  
    end
    
poselist = 'F:\zn1\znMCM\MsCeleb1M_code\code_openface\pose_list\low_do_high_mean_rgb\';
landmarkdir = 'F:\zn1\znMCM\MsCeleb1M_code\code_openface\heuristic_rgb\low_pose\';

for n = 487:length(nameFolds)
    fprintf('%d/%d %s\n', n, length(nameFolds), nameFolds{n});
    subject_id = nameFolds{n};

    landmark = [landmarkdir subject_id '/'];
    fidm = fopen([poselist subject_id '_pose_list.csv'], 'r');
    C = textscan(fidm, '%s');
    C1=C{1}; 
%     marks = dir([landmark '*.bmp']);
    
    %destination
    dstqq = [dst subject_id '/'];
    if ~exist(dstqq, 'dir')
        mkdir([dst subject_id '/']);  
    end

    %read jpgs of subjects
    srcimage = [pathFolder '/' subject_id '/low/' ]
    files = dir([srcimage '*.jpg']);
    for i=1:length(files)
        flag = 0;
%         for j=1:length(marks)
%         if( strcmp(marks(j).name(1:end-10),files(i).name(1:end-4)))
%            flag=1; %exist in list,do
%            break;
%         end
%        end
        for j=1:length(C1)
          if (strcmp(C1{j},files(i).name))
            flag=1; %exist in list,do
            break;
          end
        end
       if(flag == 0) %non exist, undo
%           source = [srcimage files(i).name] ;
%           copyfile(source,dstqq); 
          continue;
      end
      
        srcname = files(i).name;
        % Load query image
        I_Q = imread([srcimage srcname]);
%         I_Q = repmat(I_Q, [1 1 3] );
        % I_Q=imresize(I_Q,[350,534]);
        % load some data
        load eyemask eyemask % mask to exclude eyes from symmetry
        load DataAlign2LFWa REFSZ REFTFORM % similarity transf. from rendered view to LFW-a coordinates

        % IMPORTANT: Choose facial landmark detector. 
        % detector = 'SDM'; % alternatively 'ZhuRamanan', 'dlib', 'FivePoints'
        detector = 'dlib';
       % Note that the results in the paper were produced using SDM. We have found
       % other detectors to produce inferior frontalization results. 
       fidu_XY = [];

       %68 points
       pname = [srcname(1:end-4) '_det_0.pts'];
        [FileId errmsg] = fopen([landmark pname]);  
        %read 68 points
        npoints = textscan(FileId,'%f %f ',68,'HeaderLines',3);
        fidu_XY = cell2mat(npoints);   

        % facial_feature_detection;
        if isempty(fidu_XY)
           error('Failed to detect facial features / find face in image.');
        end

          % Estimate projection matrix C_Q
         [C_Q, ~,~,~] = estimateCamera(Model3D, fidu_XY);

          % Render frontal view
         [frontal_sym, frontal_raw] = Frontalize(C_Q, I_Q, Model3D.refU, eyemask);
       frontal_sym = imtransform(frontal_sym,REFTFORM,'XData',[1 REFSZ(2)], 'YData',[1 REFSZ(1)]);
%        frontal_raw = imtransform(frontal_raw,REFTFORM,'XData',[1 REFSZ(2)], 'YData',[1 REFSZ(1)]);
       imwrite(frontal_sym, [dstqq files(i).name]);
    end
    
%     fclose(fidm);
end

