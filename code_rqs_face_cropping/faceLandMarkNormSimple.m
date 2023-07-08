% input: image and face bounding box
% function [L, crgr] = faceLandMarkNormSimple(I, bb)
function [ L, crgr] = faceLandMarkNormSimple(I, bb)
    
    %% to avoid too large faces
    if bb(3) > 128
        scale = 128/bb(3);
        I = imresize(I, scale, 'bilinear');
        bb = round(bb*scale);
    else
        scale = 1.0;
    end

    %% first round landmark locating W.R.T the original image
    landmark = cnnexpand(imresize(imcrop(I, bb), [68 68], 'bilinear'))*bb(3);
    landmark(1:7) = landmark(1:7)+bb(1);
    landmark(8:14) = landmark(8:14)+bb(2);

%     dx = 0.1; dy = 0.1;
%     a = [1:length(landmark(1:7))]'; b = num2str(a); c = cellstr(b);
%     imshow(I); hold on; scatter(landmark(1:7)',landmark(8:14)', 'filled'); text(landmark(1:7)+dx, landmark(8:14)+dy, c);

%     imshow(I,[]); hold on; scatter(landmark(1:7)',landmark(8:14)', 'g.');

    %% locate the facial center and rotate + crop the normed facial area
    [crgr, ~, ~] = cropNorm(I, landmark);
    m0 = 150; std0 = 50;
    crgr = crgr*255;
    crgr = (crgr-mean(crgr(:)))*std0/std(crgr(:))+m0;
    crgr(crgr<0)=0; crgr(crgr>255)=255;        
    crgr = imresize(crgr/255.0, [100 60], 'bilinear');    
    L = landmark/scale;
    
end

%% given landmark, rotate and crop the norm face
function [cnface, P, C] = cropNorm(I, landmark)

    [C,r] = MinCirc([landmark(1:7)'; landmark(8:14)']);
    newRect = round([C(1)-2.6*r C(2)-2.6*r 5.2*r 5.2*r]);
    landmark(1:7) = landmark(1:7)-newRect(1)+1;
    landmark(8:end) = landmark(8:end)-newRect(2)+1;
    P = polyfit(landmark(1:4), landmark(8:11), 1);
    cnface = imrotate(imcropSafe(I, newRect), 180*atan(P(1))/pi, 'bilinear', 'loose');
    cnface = imcrop(cnface, round([size(cnface,2)/2-1.2*r, size(cnface,1)/2-2*r, 2.4*r, 4*r]));    

end

% E. Welzl "Smallest enclosing disks (balls and ellipsoids)"
% find the smallest circle that covers all points
function [C, r] = MinCirc(P)
    D = b_mincircle(P,[]);
    [C, r] = getCircle(D);
end

function D = b_mincircle(P,R)
    if size(P,2)==0 || size(R,2)==3
        D = R;
    else
        p = P(:,1);        
        P = P(:,2:end); % P-{p}
        D = b_mincircle(P,R);
        if ~isContain(D,p)
            D = b_mincircle(P,[R p]);
        end
    end
end

function flag = isContain(D, p)
    flag = 0;
    switch size(D, 2)
        case 1
            if norm(D-p)<eps
                flag = 1;
            end
        case 2
            if norm((D(:,1)+D(:,2))/2-p)<=0.5*norm(D(:,1)-D(:,2))+eps
                flag = 1;
            end
        case 3
            x1 = D(1,1); y1 = D(2,1);
            x2 = D(1,2); y2 = D(2,2);
            x3 = D(1,3); y3 = D(2,3);
            if abs((x3-x1)*(y2-y1)-(x2-x1)*(y3-y1))<=eps  % colinear
                flag = isContain(D(:,1:2), p) || isContain(D(:,2:3), p) || isContain(D(:,[1 3]), p);
            else
                x=((y2-y1)*(y3*y3-y1*y1+x3*x3-x1*x1)-(y3-y1)*(y2*y2-y1*y1+x2*x2-x1*x1))/(2*(x3-x1)*(y2-y1)-2*((x2-x1)*(y3-y1)));  
                y=((x2-x1)*(x3*x3-x1*x1+y3*y3-y1*y1)-(x3-x1)*(x2*x2-x1*x1+y2*y2-y1*y1))/(2*(y3-y1)*(x2-x1)-2*((y2-y1)*(x3-x1)));
                r = norm([x;y]-D(:,1));
                if norm([x;y]-p) <= r+eps
                    flag = 1;
                end
            end
    end        
end

function [C, r] = getCircle(D)
    if size(D,2) == 1
        C = D; r = 0;
    elseif size(D,2) == 2
        C = (D(:,1)+D(:,2))/2;
        r = 0.5*norm(D(:,1)-D(:,2));
    elseif size(D,2) == 3
        x1 = D(1,1); y1 = D(2,1);
        x2 = D(1,2); y2 = D(2,2);
        x3 = D(1,3); y3 = D(2,3);        
        x=((y2-y1)*(y3*y3-y1*y1+x3*x3-x1*x1)-(y3-y1)*(y2*y2-y1*y1+x2*x2-x1*x1))/(2*(x3-x1)*(y2-y1)-2*((x2-x1)*(y3-y1)));  
        y=((x2-x1)*(x3*x3-x1*x1+y3*y3-y1*y1)-(x3-x1)*(x2*x2-x1*x1+y2*y2-y1*y1))/(2*(y3-y1)*(x2-x1)-2*((y2-y1)*(x3-x1)));
        r = norm([x;y]-D(:,1));
        C = [x;y];
    else
        C = [];
        r = 0;
    end
end

% safely crop image to avoid out of boundary error
function R = imcropSafe(I, rect)
    rect = round(rect);
    margin = max(abs(rect))+1;
    Iexpand = ones(size(I,1)+2*margin, size(I,2)+2*margin, size(I,3));
    Iexpand(margin+1:margin+size(I,1), margin+1:margin+size(I,2), :) = I; 
    R = imcrop(Iexpand, rect+[margin margin 0 0]);
end
