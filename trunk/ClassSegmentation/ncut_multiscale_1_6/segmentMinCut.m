function [Iseg map] = segmentMinCut(Im, segCount)
    ImG = rgb2gray(Im);
    [classes,X,lambda,Xr,W,C,timing] = ncut_multiscale(ImG, segCount);
    [Iseg map] = construct_Iseg(Im, classes);
end

function [Iseg L] = construct_Iseg(img, L)
    
    [x, y, k] = size(img);
    Iseg = img;

    values = unique(L);

    for iter = 1:length(values);
        label = values(iter);
        indices = find(L == label);
        avg = sum(img(indices)) / length(indices);
        Iseg(indices) = avg;
        
        if (k == 3)
            avg = sum(img(indices + x * y)) / length(indices);
            Iseg(indices + x * y) = avg;
            
            avg = sum(img(indices + 2 * x * y)) / length(indices);
            Iseg(indices + 2 * x * y) = avg;
        end
        
        L(indices) = iter;
    end
    
    Iseg = reshape(Iseg, size(img));
end
