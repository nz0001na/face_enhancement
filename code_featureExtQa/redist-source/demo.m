% http://jschenthu.weebly.com/projects.html

clear;
close all;

disp('Data loading ...');
tic;
param.imageSize = [100 60];
param.orientationsPerScale = [8 8 8 8];
param.numberBlocks = 6;
param.fc_prefilt = 4;
param.G = gistb;
[fb_real, fb_imag] = getGaborBank; 
toc;

%% image reading and face detection
I = imread('.\imgs\w.jpg'); % change it to your own face images

if max(size(I))>1200 % avoid too large image
    I = imresize(I, 1200/max(size(I)), 'bilinear');
end
Igr = im2double(I);
try
    Igr = rgb2gray(Igr);
catch exception
end
disp('Face detection ...');
tic;
fDect = vision.CascadeObjectDetector();
fDect.ScaleFactor = 1.02; fDect.MergeThreshold = 2; fDect.MinSize = [50 50]; % [75 75];
bbox = step(fDect, Igr);
toc;

%% two round landmark detection
disp('RQS calculation ...');
[whog, wgst, wgab, wlbp, wnn, wk] = weight;
score = zeros(size(bbox,1), 1);
landmark = zeros(14, size(bbox,1));
for i = 1:size(bbox,1)
    [L, crgr] = faceLandMarkNormSimple(Igr, bbox(i,:));
    landmark(:,i) = L;
    tic;
    score(i) = (polyKernelMapping([hog(crgr)*whog getGist(crgr, [], param)*wgst gabor(crgr, fb_real, fb_imag)*wgab ...
        lbp(crgr)*wlbp cnn(crgr)*wnn])*wk - 3.75)*100/3;
    score(i) = min(max(score(i),0), 100);
    toc;
end

%% display results
figure; imshow(I); hold on;
score = round(score);
[c, idx] = max(score);
for bi = size(bbox,1):-1:1

    box = bbox(bi,:);
    fsize = max(round((box(3)/60)^(0.5)*10),8);

    if bi == idx(1)
        if box(3)<30
            text(box(1)+box(3)*0.02, box(2)+box(3)*0.99, num2str(round(score(bi))), 'Color', [0 0 0], 'VerticalAlignment', 'top', ...
                'BackgroundColor', [1 0 1], 'HorizontalAlignment', 'left', 'FontSize', fsize, 'FontWeight', 'bold');
        else
            text(box(1)+box(3)*0.02, box(2)+box(3)*0.99, num2str(round(score(bi))), 'Color', [0 0 0], 'VerticalAlignment', 'bottom', ...
                'BackgroundColor', [1 0 1], 'HorizontalAlignment', 'left', 'FontSize', fsize, 'FontWeight', 'bold');
        end
        rectangle('Position', box, 'EdgeColor', 'm', 'LineWidth', 2.5);
    else
        if box(3)<30
            text(box(1)+box(3)*0.02, box(2)+box(3)*0.98, num2str(round(score(bi))), 'Color', [0 0 0], 'VerticalAlignment', 'top', ...
                'BackgroundColor', [0 1 1], 'HorizontalAlignment', 'left', 'FontSize', fsize, 'FontWeight', 'bold');
        else
            text(box(1)+box(3)*0.02, box(2)+box(3)*0.98, num2str(round(score(bi))), 'Color', [0 0 0], 'VerticalAlignment', 'bottom', ...
                'BackgroundColor', [0 1 1], 'HorizontalAlignment', 'left', 'FontSize', fsize, 'FontWeight', 'bold');
        end
        rectangle('Position', box, 'EdgeColor', 'c', 'LineWidth', 2, 'LineStyle', '--');
    end
    

end    
drawnow;

return;
