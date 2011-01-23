function detector_points=Do_LoG_MS(im, detector_name, image_dir)

points    = [];
thresh    = 20;
numscales = 11;
scalestep = 1.4;

imname=im;
im = double(imread(im));

for k = 1:size(im,3)
    im(:,:,k) = gDer(im(:,:,k), 1, 0, 0);
end

Gaussian_pyramid  = cell(numscales,1);
Laplacian_pyramid = cell(numscales,1);

Gaussian_pyramid{1}  = im;
Laplacian_pyramid{1} = nsLoG2D(im, scalestep);

for counter = 2:numscales
	scale = scalestep^(counter-1);
    Gaussian_pyramid{counter}  = imresize(im, 1/scale);
    Laplacian_pyramid{counter} = nsLoG2D(Gaussian_pyramid{counter}, scalestep);
end

for counter = 1:numscales
    scale = scalestep^counter;
    nLoG  = Laplacian_pyramid{counter};
    immax = mexnms(nLoG, round(scalestep), thresh);
    [xi, xj] = find(immax==1);
    [dj, di] = subpixel(nLoG, xj, xi);
    i = xi+di; j = xj+dj;
    if ~isempty(xi)
        border = round(2*scale);
        npoint = [(scale/scalestep).*i, (scale/scalestep).*j, scale*ones(length(xi),1) counter*ones(length(xi),1) nLoG(sub2ind(size(nLoG),xi,xj))];
        npoint = npoint(npoint(:,1)>border & npoint(:,2)>border & npoint(:,1)<size(im,1)-border & npoint(:,2)<size(im,2)-border,:);  
        points = [points; npoint];
    end
end

% if size(points,1)>1500
%     %ordering point using their strength 
%     [b,idx] = sort(points(:,5),'descend');
%     nummax = 1500;
%     if size(points,1)>nummax
%         points = points(idx(1:nummax),:);
%     else
%     	points = points(idx,:);
%     end
% end 

%fprintf(['Blob detector found ' num2str(size(points,1)) ' points.\n']);

%figure,show_all_circles(uint8(im), points(:,2), points(:,1),3*points(:,3),'y',1)

if size(points,1)>0
    if size(points,1)>1500
        %ordering point using their strength 
        [b,idx] = sort(points(:,5),'descend');
        nummax = 1500;
        if size(points,1)>nummax
            points = points(idx(1:nummax),:);
        else
            points = points(idx,:);
        end
    end    
    fprintf([imname ': Blob detector found ' num2str(size(points,1)) ' points.\n']);
    
%     figure,show_all_circles(uint8(im), points(:,2), points(:,1),3*points(:,3),'y',1)
%     pause;
%     close;
    
    detector_points=[points(:,2) points(:,1) points(:,3)];
    save ([image_dir,'/',detector_name], 'detector_points');
else
    load HarLap_MS.mat
    HarLapMS = HarLapMS+1;
    save('HarLap_MS','HarLapMS')
    clear HarLapMS;
end
    

