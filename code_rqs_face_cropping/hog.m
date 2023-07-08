function f = hog(crgr)

    f = extractHOGFeatures(histeq(crgr), 'CellSize', [10 10], 'BlockSize', ...
        [2 2], 'BlockOverlap', [1 1], 'NumBins', 8, 'UseSignedOrientation', true); 

end