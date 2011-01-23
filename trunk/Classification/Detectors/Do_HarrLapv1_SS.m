function detector_points=Do_HarrLapv1_SS(im, detector_name, image_dir)

points    = [];
hthres    = 10000;
numscales = 11;
scalestep = 1.4;

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
        border = round(3*scale);
        npoint = [(scale/scalestep).*i, (scale/scalestep).*j, scale*ones(length(xi),1) counter*ones(length(xi),1)];
        npoint = npoint(npoint(:,1)>border & npoint(:,2)>border & npoint(:,1)<size(im,1)-border & npoint(:,2)<size(im,2)-border,:);  
        points = [points; npoint];
    end
end

Gaussian_pyramid  = cell(numscales,1);
Laplacian_pyramid = cell(numscales,1);

Gaussian_pyramid{1}  = im;
Laplacian_pyramid{1} = nsLoG2D(im, scalestep);

for counter = 1:numscales
	scale = scalestep^(counter);
    Gaussian_pyramid{counter}  = imresize(im, scalestep/scale);
    Laplacian_pyramid{counter} = nsLoG2D(Gaussian_pyramid{counter}, scalestep);
end

for ind = 1:size(points,1)
    i = points(ind,1);
    j = points(ind,2);
    s = points(ind,3);
    c = points(ind,4);

    i = round((scalestep/s)*i);
    j = round((scalestep/s)*j);
    im1 = round(scalestep*i);
    jm1 = round(scalestep*j);
    ip1 = round(i/scalestep);
    jp1 = round(j/scalestep);
    
    n   = 1;
    nm1 = 1;
    np1 = 1;
    
    if (c==numscales)
        neighbours1 = Laplacian_pyramid{c-1}(im1-nm1:im1+nm1,jm1-nm1:jm1+nm1);
        neighbours2 = Laplacian_pyramid{c}(i-n:i+n,j-n:j+n);
        neighbours  = [neighbours1(:);neighbours2(:)];
    elseif (c==1)
        neighbours1 = Laplacian_pyramid{c}(i-n:i+1,j-n:j+n);
        neighbours2 = Laplacian_pyramid{c+1}(ip1-np1:ip1+np1,jp1-np1:jp1+np1);
        neighbours  = [neighbours1(:);neighbours2(:)];
    else
        neighbours1 = Laplacian_pyramid{c-1}(im1-nm1:im1+nm1,jm1-nm1:jm1+nm1);
        neighbours2 = Laplacian_pyramid{c}(i-n:i+n,j-n:j+n);
        neighbours3 = Laplacian_pyramid{c+1}(ip1-np1:ip1+np1,jp1-np1:jp1+np1);
        neighbours  = [neighbours1(:);neighbours2(:);neighbours3(:)];
    end
    if max(neighbours(:))>max(max(Laplacian_pyramid{c}(i-n:i+n,j-n:j+n))) 
       points(ind,4)=0;
    end
end    
points = points(points(:,4)>0,:);

fprintf(['Corner detector found: ' num2str(size(points,1)) ' points.\n']);

%if size(points,1)<100
   figure,show_all_circles(uint8(im), points(:,2), points(:,1),3*points(:,3),'y',1)
   pause;
   close;
%end

detector_points=points(:,1:3);

save ([image_dir,'/',detector_name], 'detector_points');
