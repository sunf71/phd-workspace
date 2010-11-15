function [Img] = visualize_segregion(reqInd, orgIm)

close all;

[x, y, z] = size(orgIm);
Img = orgIm;
h = [];
for i = 1:z
    h = [h;hist(Img(reqInd + (i - 1) * x * y), [0:255])];
    Img(reqInd + (i - 1) * x * y) = 0;
end

% h(1,:) = imfilter(h(1,:),fspecial('gau',10,5));
% h(2,:) = imfilter(h(2,:),fspecial('gau',10,5));
% h(3,:) = imfilter(h(3,:),fspecial('gau',10,5));

vecImg=double(reshape(orgIm,[],3));
vecImg=vecImg(reqInd,:);
chrImg=vecImg./repmat(sum(vecImg,2),1,3);
h2D = histnd(chrImg(:,1:2),[0:0.01:1;0:0.01:1]');

figure, imshow(orgIm);

Img(find(Img ~= 0)) = 1;
Img(find(Img == 0)) = orgIm(find(Img == 0));
Img(find(Img == 1)) = 0;

figure, imshow(Img);

figure, plot(h(1,:), '-r')

hold on

% subplot(212);
plot(h(2,:), '-b')

% subplot(212);
plot(h(3,:), '-g')


  xlabel 'Colour value'
  ylabel 'Occurence'
% surf(h2D,'edgecolor','none')
hold off

end