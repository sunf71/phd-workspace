function WriteImage(im, filename)
%% Write an image into a file
m = min(im(:));
M = max(im(:));
im = uint8((im - m) / (M - m) * 255);
imwrite(im, [filename '.tif']);
end