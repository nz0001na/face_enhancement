addpath calib
dst = 'F:\zn1\znMCM\MsCeleb1M_code\code_frontalize\output\';
        % Load query image
       name = '6133.jpg';
        I_Q = imread(name);
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
        [FileId errmsg] = fopen([name(1:end-4) '_det_0.pts']);  
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
       frontal_raw = imtransform(frontal_raw,REFTFORM,'XData',[1 REFSZ(2)], 'YData',[1 REFSZ(1)]);
       imwrite(frontal_raw, [dst name]);
       
figure; imshow(I_Q); title('Query photo');
figure; imshow(I_Q); hold on; plot(fidu_XY(:,1),fidu_XY(:,2),'.'); hold off; title('Query photo with detections overlaid');
figure; imshow(frontal_raw); title('Frontalilzed no symmetry');
figure; imshow(frontal_sym); title('Frontalilzed with soft symmetry');
