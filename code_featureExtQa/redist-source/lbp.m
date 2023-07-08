% extract lbp feature specific for 100x60 cropped face
function lbpfeat = lbp(crgr) 

    filtR = zeros(3,3,8);
    filtR(:,:,1) = [0 0 0; 0 -1 1; 0 0 0];
    filtR(:,:,2) = [0 0.2500 0.3535; 0 -0.8535 0.2500; 0 0 0];
    filtR(:,:,3) = [0 1 0; 0 -1 0; 0 0 0];
    filtR(:,:,4) = [0.3535 0.2500 0; 0.2500 -0.8535 0; 0 0 0];
    filtR(:,:,5) = [0 0 0; 1 -1 0; 0 0 0];
    filtR(:,:,6) = [0 0 0; 0.2500 -0.8535 0; 0.3535 0.2500 0];
    filtR(:,:,7) = [0 0 0; 0 -1 0; 0 1 0];
    filtR(:,:,8) = [0 0 0; 0 -0.8535 0.2500; 0 0.2500 0.3535];

    crgr = imresize(crgr, 0.5, 'bilinear');
    bw = zeros(size(crgr,1), size(crgr,2), 8);
    weig = repmat(reshape(2.^(0:7), 1, 1, 8), [size(crgr,1) size(crgr,2)]);
    for i=1:8
        fc = filter2( filtR(:, :, i), crgr, 'same' );
        bw(:, :, i) = (roundn(fc, -3) >= 0);
    end 
    lbpfeat = sum(bw.*weig, 3)/255.0;
    lbpfeat = lbpfeat(:)';
    
end