function detector_points=Do_HarrLapv1_MS(im, detector_name, image_dir)

points    = [];
hthres    = 8000;
numscales = 11;
scalestep = 1.4;

imname=im;
im = double(imread(im));

for k=1:size(im,3)
    im(:,:,k) = gDer(im(:,:,k), 1, 0, 0);
end

for counter = 1:numscales
	scale = scalestep^(counter);
    cornerness = HarrisCorner(imresize(im, scalestep/scale), scalestep);
    immax = mexnms(cornerness, ceil(scalestep), hthres);
    [xi, xj] = find(immax==1);
    [dj, di] = subpixel(cornerness, xj, xi);
    i = xi+di; j = xj+dj;
    if ~isempty(xi)
        border = round(2*scale);
        npoint = [(scale/scalestep).*i, (scale/scalestep).*j, scale*ones(length(xi),1) counter*ones(length(xi),1) cornerness(sub2ind(size(cornerness),xi,xj))];
        npoint = npoint(npoint(:,1)>border & npoint(:,2)>border & npoint(:,1)<size(im,1)-border & npoint(:,2)<size(im,2)-border,:);  
        points = [points; npoint];
    end
end


%figure,show_all_circles(uint8(im), points(:,2), points(:,1),3*points(:,3),'y',1)

if size(points,1)>0
    if size(points,1)>500
        %ordering point using their strength 
        [b,idx] = sort(points(:,5),'descend');
        nummax = 500;
        if size(points,1)>nummax
            points = points(idx(1:nummax),:);
        else
            points = points(idx,:);
        end
    end    
    %fprintf([imname ': Corner detector found ' num2str(size(points,1)) ' points.\n']);
    detector_points=[points(:,2) points(:,1) points(:,3)];
else
    detector_points=[];
end
    

