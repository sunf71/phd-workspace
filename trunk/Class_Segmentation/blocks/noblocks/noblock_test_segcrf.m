function noblock_test_segcrf(bk)

% In this file we peform the same sequence of commands similar to what we
% do in the original quickrec sequence. In this time we don't work using
% the blocks framework. Instead, we can only perform the sequence on only 1
% image so that we become more able to test and visualize our results.
% Afterwards when we generalize we'll use the blocks framework.


%% Read the image

Im = imread('/home/amounir/Desktop/VOCdevkit/VOC2007/JPEGImages/000068.jpg');

%% Segment the image

[Iseg map] = msseg(Im);
map = map + 1;

labels = unique(map);

% build adjacency matrix and counts
segs = struct('ind', [], 'count', [], 'color', [], 'adj', []);
map1 = circshift(map, [1 0]);
map1(1,:) = map(1,:);
map2 = circshift(map, [-1 0]);
map2(end,:) = map(end,:);
map3 = circshift(map, [0 1]);
map3(:,1) = map(:,1);
map4 = circshift(map, [0 -1]);
map4(:,end) = map(:,end);

for i=1:length(labels)
  ind = find(map(:) == labels(i));
  segs(i).ind = ind;
  segs(i).count = length(ind);
  [row col] = ind2sub(size(map), ind(1));
  segs(i).color = squeeze(Iseg(row, col, :));
  adj = [map1(ind) map2(ind) map3(ind) map4(ind)];
  adj = unique(adj(:));
  adj = setdiff(adj, labels(i));
  segs(i).adj = adj;
end

%% Extract the features and descriptors

% read image and make it grayscale
Igs = im2single(Im);
if size(Igs, 3) > 1
  Igs = rgb2gray(Igs) ; 
end

[M,N,k] = size(Igs) ;
rho = 1 ;

I_ = imresize(Igs, round(rho * [M, N])) ;
Icolor = imresize(Im, round(rho * [M, N])) ;
Icolor = im2single(Icolor);
f = zeros(4,1); % dsift calculates descriptors and features at the same time

min_sigma = 0;
sel = find(f(3,:) > min_sigma) ;
f = f(:,sel) ;
[M,N] = size(I_) ;

rescale = 6;
R = f(3,:) * rescale ;
  
keep = f(1,:) - R >= 1 & ...
       f(1,:) + R <= N & ...
       f(2,:) - R >= 1 & ...
       f(2,:) + R <= M ;
  
f = f(:,keep) ;

dsift_size = 12;
dsift_step = 1;
[f,d] = vl_dsift(I_, 'size', dsift_size, 'step', dsift_step, 'fast');
sigma = dsift_size*4/6;
f = [f; sigma*ones(1, size(f,2)); pi/2*ones(1,size(f,2))];
 
% remove frames if too close to the boundary
[M,N] = size(I_) ;
R = f(3,:) * 6 / 2 ; % 6 * sigma is the domain of the descriptor

keep = f(1,:) - R >= 1 & ...
       f(1,:) + R <= N & ...
       f(2,:) - R >= 1 & ...
       f(2,:) + R <= M ;
      
f = f(:,keep) ;
d = d(:,keep) ; 
f(1:2,:) = (f(1:2,:) - 1) / rho + 1 ;
f(3,:)   = f(3,:) / rho ;

%% Now build the histograms

sel = 1:size(d,2) ;
f = f(:,sel) ; 
d = d(:,sel) ;

bkdict = bkfetch(bk.dict.tag) ;
dict   = bkfetch(bkdict, 'dictionary') ;

[w, h, dsel] = bkdict.push(dict, d) ;
sel = sel(dsel);
 
% For each segment, get the words corresponding to features located here
segmap = map;
hists = zeros(length(segs), length(h));
ind = sub2ind(size(segmap), round(f(2,dsel)), round(f(1,dsel)));
d_labels = segmap( ind );
histsidx = sub2ind( size(hists), uint32(d_labels), w );
hists = vl_binsum( hists, 1, double(histsidx) );

%% Load the classifier and db

cl           = bkfetch(bk.classifier.tag, 'cl');
classifier   = bkfetch(bk.classifier.tag, 'type');
bkclassifier = bkfetch(bk.classifier.tag);
db           = bkfetch(bk.db.tag, 'db') ;

%% Build predictions and decisions for segments

nsegs = length(segs);
pred  = zeros(nsegs,1);
dec   = {};

for i = 1:nsegs
  % Normalize histogram
  h = hists(i,:)';
  switch classifier
    case 'svm'
      [pred(i), dec{i}] = bkclassifier.classify(cl, h);
    case 'nn'
      [pred(i), dec{i}] = bkclassifier.classify(cl, h);

    otherwise
      error(sprintf('Unknown classifier %s', bk.classifier));
  end
end


params   = struct('luv', 1, 'l_edge', 2.7977);

%% Combine segments using conditional random fields

boundary = boundarylen(double(map), length(segs));
seglabel = pred;
segdec = dec;
segprob = cat(1, segdec{:})';


icat_map = zeros(max(db.cat_ids),1);

for i=1:length(db.cat_ids)
  icat_map(db.cat_ids(i)) = i;
end

seglabel = icat_map(seglabel) - 1;
unary = -log(segprob);
[labels E Ebefore] = crfprocess(segs, seglabel, unary, params, boundary);
labels = labels + 1;
newlabels = db.cat_ids(labels);

nsegs = length(segs);
pred  = zeros(nsegs,1);
dec   = {};

class = ones(size(Iseg,1), size(Iseg,2)) * bk.bg_cat;
confidence = zeros(size(Iseg,1), size(Iseg,2), length(segdec{1}));
for j = 1:size(confidence, 3)
  c2 = zeros(size(class));
  for i = 1:nsegs
    if j == 1, class(segs(i).ind) = newlabels(i); end
    c2(segs(i).ind) = segdec{i}(j);
  end
  confidence(:,:,j) = c2;
end

confidence = abs(confidence);

close;
close;

figure, imshow(Im);
figure, imshow(label2rgb(class));

[x,y] = ginput;

while size(x, 1) ~= 0
    db.cat_names(class(floor(y(1)), floor(x(1))))
    [x,y] = ginput;
end

end
