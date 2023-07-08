% http://jschenthu.weebly.com/projects.html
clear;clc;  
close all;

addpath('./redist-source');

param.imageSize = [100 60];
param.orientationsPerScale = [8 8 8 8];
param.numberBlocks = 6;
param.fc_prefilt = 4;
param.G = gistb;
[fb_real, fb_imag] = getGaborBank; 

pathFolder = 'F:\zn1\znMCM\data_for_rqs';
d = dir(pathFolder);
isub = [d(:).isdir]; % returns logical vector
nameFolds = {d(isub).name}';
nameFolds(ismember(nameFolds,{'.','..'})) = [];

bbox = [26,26,210,210];

for n = 1:length(nameFolds)
    fprintf('%d/%d %s\n', n, length(nameFolds), nameFolds{n});
    subject_id = nameFolds{n};

    %src = ['F:\zn1\znMCM\subject_wise_cropped/' subject_id '/'];
    src = ['F:\zn1\znMCM\data_for_rqs/' subject_id '/'];
    
    dst = ['../output/' subject_id '/'];

    if ~exist(dst, 'dir')
        mkdir(['../output/' subject_id '/']);
        mkdir(['../output/' subject_id '/images/']);
        mkdir(['../output/' subject_id '/features/']);
    end

    files = dir([src '*.jpg']);

    gabor_feat = []; lbp_feat = []; cnn_feat = [];
    scores = {}; 
    k = 1;

    fid = fopen(['../output/' subject_id '/' subject_id '_scores.csv'], 'w');
    for j = 1:length(files)    

        %% image reading and face detection
        I = imread([src files(j).name]); % change it to your own face images
        I = imresize(I, [256 256]);

        if max(size(I))>1200 % avoid too large image
            I = imresize(I, 1200/max(size(I)), 'bilinear');
        end

        Igr = im2double(I);
        try
            Igr = rgb2gray(Igr);
        catch exception
        end

%         if j == 1
%             fDect = vision.CascadeObjectDetector();
%             fDect.ScaleFactor = 1.02; fDect.MergeThreshold = 2; fDect.MinSize = [50 50]; % [75 75];
%             bbox = step(fDect, Igr);
%     
%             if isempty(bbox)
%                 fDect = vision.CascadeObjectDetector('ProfileFace');
%                 fDect.ScaleFactor = 1.02; fDect.MergeThreshold = 2; fDect.MinSize = [50 50]; % [75 75];
%                 bbox = step(fDect, Igr);
%             end
%     
%             if isempty(bbox)
%                 fprintf('face not detected in %s\n', files(j).name);
%                 continue;
%             end
%         end

    %     %% two round landmark detection
        [whog, wgst, wgab, wlbp, wnn, wk] = weight;
        score = zeros(size(bbox,1), 1);
        landmark = zeros(14, size(bbox,1));
        for i = 1:size(bbox,1)
            [L, crgr] = faceLandMarkNormSimple(Igr, bbox(i,:));
            landmark(:,i) = L;

            hogf = hog(crgr);
            gistf = getGist(crgr, [], param);
            gaborf = gabor(crgr, fb_real, fb_imag);
            lbpf = lbp(crgr);
            cnnf = cnn(crgr);
            score = (polyKernelMapping([hogf*whog gistf*wgst gaborf*wgab ...
                lbpf*wlbp cnnf*wnn])*wk - 3.75)*100/3;
            score = min(max(score,0), 100);

            gabor_feat(k,:) = gaborf;
%             lbp_feat(k,:) = lbpf;
%             cnn_feat(k,:) = cnnf;

            fprintf(fid, '%s,%d\n', files(j).name, round(score));
            imwrite(crgr, [dst '/images/' files(j).name]);
            k = k + 1;
        end
    end
    fclose(fid);

    csvwrite(['../output/' subject_id '/features/' subject_id '_gaborf.csv'], gabor_feat);
    csvwrite(['../output/' subject_id '/features/' subject_id '_lbpf.csv'], lbp_feat);
    csvwrite(['../output/' subject_id '/features/' subject_id '_cnnf.csv'], cnn_feat);

end




