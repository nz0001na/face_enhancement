% DEMO script for frontalizing faces, based on the method described in [1]
% This demo produces a frontalized face for the image test.jpg
%
% If you find this code useful and use it in your own work, please add
% reference to [1] and, if appropriate, any of the other papers mentioned below.
%
% Dependencies: 
%   The demo uses the following dependencies. You MUST have these installed and
%   available on the MATLAB path:
%   1. calib function available from [2,3], required for estimating the query
%       camera projection matrix, C_Q. Calib functions are assumed to be
%       under folder <frontalization>/calib

%  2. Facial feature detection functions. The demo provides examples
%      of frontalization using different facial landmark detection methods. Currently supported are:
%	  - SDM [4] (default, used in paper; IMPORTANT: We cannot provide code for this method, if you do 
%		not have it available, please use other alternatives listed below), 
%	  - The facial feature detector of Zhu and Ramanan [5]
%	  - DLIB detector (implementing the method of Kazemi and Sullivan) [6]. 
%	  - Any sparse (five-point) facial landmark detector. Landmarks are the two centers of the eyes, the tip 
%		of the nose and the two corners of the mouth. See [7] for one such detector and references therein.
%       Note: this option is currently interactive, allowing the user to
%       select the five landmarks manually.
%	  Please see the script facial_feature_detection.m on how to use these (as well as 
%     edit paths to the detector used in practice, in case these differ from 
%     the ones in the script). See the function makeNew3DModel.m in case
%     a different facial feature detector is used.

%   3. OpenCV required by calib for calibration routines and some of the
%       detectors for cascase classifiers (e.g., SDM)
%
%  References:
%   [1] Tal Hassner, Shai Harel, Eran Paz, Roee Enbar, "Effective Face
%   Frontalization in Unconstrained Images," forthcoming. 
%   See project page for more details: 
%   http://www.openu.ac.il/home/hassner/projects/frontalize
%
%   [2] T. Hassner, L. Assif, and L. Wolf, "When Standard RANSAC is Not Enough: Cross-Media 
%   Visual Matching with Hypothesis Relevancy," Machine Vision and Applications (MVAP), 
%   Volume 25, Issue 4, Page 971-983, 2014 
%   Available: http://www.openu.ac.il/home/hassner/projects/poses/
%
%   [3] T. Hassner, "Viewing Real-World Faces in 3D," International Conference on Computer Vision (ICCV), 
%   Sydney, Austraila, Dec. 2013
%   Available: http://www.openu.ac.il/home/hassner/projects/poses/
%
%   [4] X. Xiong and F. De la Torre, "Supervised Descent Method and its Application to Face
%   Alignment," IEEE Conference on Computer Vision and Pattern Recognition (CVPR), 2013
%   Available: http://www.humansensing.cs.cmu.edu/intraface
%
%   [5] X. Zhu, D. Ramanan. "Face detection, pose estimation and landmark localization in the wild," 
%   Computer Vision and Pattern Recognition (CVPR) Providence, Rhode Island, June 2012. 
%   Available: http://www.ics.uci.edu/~xzhu/face/
%
%   [6] V. Kazemi, J. Sullivan. "One Millisecond Face Alignment with an
%   Ensemble of Regression Trees," Computer Vision and Pattern Recognition
%   (CVPR), Columbus, Ohio, June, 2014
%   Available through the dlib library: http://blog.dlib.net/2014/08/real-time-face-pose-estimation.html
%
%  [7] Yue Wu and Tal Hassner, "Facial Landmark Detection with Tweaked Convolutional Neural Networks," 
%  arXiv preprint arXiv:1511.04031, 12 Nov. 2015
%
%
%   Copyright 2014, Tal Hassner
%   http://www.openu.ac.il/home/hassner/projects/frontalize
%
%
%   The SOFTWARE ("frontalization" and all included files) is provided "as is", without any
%   guarantee made as to its suitability or fitness for any particular use.
%   It may contain bugs, so use of this tool is at your own risk.
%   We take no responsibility for any damage that may unintentionally be caused
%   through its use.
%
%   ver 1.3, 8-Dec-2015
%
% clear;
% close all;
addpath calib

% Load query image
I_Q = imread('test.jpg');
%  I_Q = repmat(I_Q,[1 1 3]);
% I_Q=imresize(I_Q,[256,256],'bilinear');

dst = 'F:\zn1\znMCM\MsCeleb1M_code\code_frontalize\output\';

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
figure; imshow(I_Q); title('Query photo');
figure; imshow(I_Q); hold on; plot(fidu_XY(:,1),fidu_XY(:,2),'.'); hold off; title('Query photo with detections overlaid');


figure; imshow(frontal_raw); title('Frontalilzed no symmetry');

% imwrite(frontal_raw, [dst 'test.jpg']);

%figure; imshow(frontal_sym); title('Frontalilzed with soft symmetry');



