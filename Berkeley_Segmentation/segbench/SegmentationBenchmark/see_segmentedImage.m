function see_segmentedImage()

files = dir('./ORG');

close all
figure;
for fInd = 3:length(files)

    ind = str2double(files(fInd).name(1:end-4));

    org_filename = sprintf('./ORG/%d.jpg', ind);
    img = imread(org_filename);
    subplot(151), imshow(img);
    title('Original')
    drawnow;

    filename = sprintf('./GB/%d.mat', ind);
    load(filename);
    [Iseg L] = construct_Iseg(img, sampleLabels);
    subplot(152), imshow(Iseg);
    title(sprintf('Graph Based, segs = %d', max(L(:))))
    drawnow;

    filename = sprintf('./MS/%d.mat', ind);
    load(filename);
    [Iseg L] = construct_Iseg(img, sampleLabels);
    subplot(153), imshow(Iseg);
    title(sprintf('Mean shift, segs = %d', max(L(:))))
    drawnow;

    filename = sprintf('./NC/%d.mat', ind);
    load(filename);
    [Iseg L] = construct_Iseg(img, sampleLabels);
    subplot(154), imshow(Iseg);
    title(sprintf('Normalized cut, segs = %d', max(L(:))))
    drawnow;

    filename = sprintf('./RAD/%d.mat', ind);
    load(filename);
    [Iseg L] = construct_Iseg(img, sampleLabels);
    subplot(155), imshow(Iseg);
    title(sprintf('RAD, segs = %d', max(L(:))))
    drawnow;
    
    pause;
end

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
