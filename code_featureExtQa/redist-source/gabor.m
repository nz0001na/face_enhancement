% extract gabor feature specific for 100x60 cropped face
function gfeat = gabor(crgr, fb_real, fb_imag)

    gR = cell(3,8);
    for i = 1:3
        for j = 1:8
            filt = complex(fb_real((i-1)*8+j, :, :), fb_imag((i-1)*8+j, :, :));
            filt = reshape(filt, 29, 29, 1);
            gR{i,j} = conv2(crgr,filt,'same');
        end
    end

    [n,m] = size(crgr); s = (n*m)/100; gfeat = zeros(s*24,1); c = 0;
    for i = 1:3
        for j = 1:8
            c = c+1;
            gabs = abs(gR{i,j});
            gabs = downsample(gabs,10);
            gabs = downsample(gabs.',10);
            gabs = reshape(gabs.',[],1);
            gabs = (gabs-mean(gabs))/std(gabs,1);
            gfeat(((c-1)*s+1):(c*s)) = gabs;
        end
    end
    
    gfeat = gfeat';

end