function bk = block_hist_qseg_hybrid(bk, varargin)
% BLOCK_HIST_QSEG Construct histograms for quick shift superpixels
%   This block extracts histograms for quick shift superpixels.
%
%   BK = BLOCK_HIST_QSEG() Initializes the block with the default options.
%
%   BK = BLOCK_HIST_QSEG(BK) Executes the block with options and inputs BK.
%
%   Required Inputs:
%
%   db::
%     The database of images.
%
%   feat::
%     Features extracted from the database.
%
%   dict::
%     A dictionary to use on the features.
%
%   qseg::
%     The superpixels found by quick shift.
%
%   Options:
%
%   bk.min_sigma::
%     Discard features with scale less than min_sigma. Default 0.
%
%   bk.max_num::
%     Keep at most max_num features, selected randomly. Default +inf.
%
%   bk.ref_size::
%     ref_size used in feature extraction. Required to accurately
%     measure min_sigma. Default [] does not modify the scale of the
%     features.
%   
%   bk.rand_seed::
%     Set the random seeds before proceeding. Default [] does not
%     modify the random seeds.
%
%   Fetchable attributes:
%   
%   db::
%     The database used.
%
%   dictionary::
%     The dictionary used.
%
%   histogram::
%     The histogram of a particular image. Required argument: seg_id.
%
%   words::
%     The quantized words which form the histogram. Required argument:
%     seg_id.
%
%   seghistograms::
%     The superpixel histograms. Required arguments: seg_id,
%     neighbors. The number of neighbors cannot be greater than 4.

% AUTORIGHTS
% Copyright (c) 2009 Brian Fulkerson and Andrea Vedaldi
% Blocks is distributed under the terms of the modified BSD license.
% The full license may be found in LICENSE.

global wrd ;

if nargin == 0
  bk           = bkinit('hist_qseg', 'db', 'feat', 'dict', 'qseg') ;
  bk.fetch     = @fetch__ ;
  bk.min_sigma = 0 ;
  bk.max_num   = +inf ;
  bk.ref_size  = [] ;
  bk.rand_seed = [] ;
  return ;
end

% --------------------------------------------------------------------
%                                                    Check/load inputs
% --------------------------------------------------------------------

[bk, dirty] = bkbegin(bk) ;
if ~ dirty, return ; end

bkdb   = bkfetch(bk.db.tag) ;
bkfeat = bkfetch(bk.feat.tag) ;
bkdict = bkfetch(bk.dict.tag) ;

db     = bkfetch(bkdb, 'db') ;
dict   = bkfetch(bkdict, 'dictionary') ;
bg_ind = find(db.class_ids == 0);

% --------------------------------------------------------------------
%                                                       Do computation
% --------------------------------------------------------------------

fprintf('block_hist_qseg: ref_size:  %s\n', tostr(bk.ref_size)) ;
fprintf('block_hist_qseg: min_sigma: %s\n', tostr(bk.min_sigma)) ;
fprintf('block_hist_qseg: max_num:   %s\n', tostr(bk.max_num)) ;

keys = 1:length(db.segs) ;
[reduce, mapkeys] = bksplit(bk, keys, varargin{:}) ;
ensuredir(fullfile(wrd.prefix, bk.tag, 'data')) ;

% These are the paths that the results from the segmentation are saved in
seg_res_paths = char('/home/amounir/Workspace/Superpixels-iccv2009/results/Original_Method_Parallelized', ...
                     '/home/amounir/Workspace/Superpixels-iccv2009/results/MS_Parallelized_1', ...
                     '/home/amounir/Workspace/Superpixels-iccv2009/results/MS_Parallelized_2');
seg_res_paths = cellstr(seg_res_paths);

path = wrd.prefix;

for t=1:length(mapkeys)
    
  finalH = [];
  finalW = [];
  
  for neighInd = 1:5
    finalHists{neighInd} = [];
    finalHLabels{neighInd} = [];
  end
  
  if ~ isempty(bk.rand_seed)
    setrandseeds(bk.rand_seed + mapkeys(t)-1) ;
  end
    
  seg_id = db.segs(mapkeys(t)).seg ;
  
  d = bkfetch(bkfeat, 'descriptors', seg_id) ;
  f = bkfetch(bkfeat, 'frames', seg_id) ;
  
  sel = 1:size(d,2) ;
  f = f(:,sel) ; 
  d = d(:,sel) ;

  %
  % Project features
  %
  
  [w, h, dsel] = bkdict.push(dict, d) ;
  sel = sel(dsel);
 
  for pathInd = 1:length(seg_res_paths)

  % Go to the folder for segmentation result
  cd(seg_res_paths{pathInd});

  % Fetch the segments
  bkqseg = bkfetch(bk.qseg.tag) ; 

  % For each segment, get the words corresponding to features located here
  segs = bkfetch(bkqseg, 'segs', seg_id);
  segmap = bkfetch(bkqseg, 'segmap', seg_id);

  % Get back to the current results folder
  cd(path);

  hists = zeros(length(segs), length(h));
  ind = sub2ind(size(segmap), round(f(2,dsel)), round(f(1,dsel)));
  d_labels = segmap( ind );
  histsidx = sub2ind( size(hists), uint32(d_labels), w );
  hists = vl_binsum( hists, 1, double(histsidx) );

  if ~exist(db.segs(mapkeys(t)).classseg)
    % a test image we don't have ground truth for (eg. p09 challenge)
    histlabels = zeros(length(segs),1);
  else
    % Label each segment by the majority labels
    s = db.segs(mapkeys(t));
    histlabels = zeros(length(segs),1);
    seg = imread(s.classseg);
    counts = zeros(length(segs), length(db.class_ids));
    for i = 1:length(db.class_ids)
      sid = db.class_ids(i);
      cid = db.cat_ids(i);
      if length(find(s.obj_ids == cid)) == 0, continue; end;

      obj = find(seg == sid);
      counts(:,i) = vl_binsum(counts(:, i), ones(size(obj)), double(segmap(obj)));
    end
    % enable this to label all segments which contain at least one fg pixel to fg
    %counts(:,bg_ind) = 0; 
    [v histlabels] = max(counts, [], 2);
    histlabels = db.cat_ids(histlabels);
    if length(bg_ind) > 0 % if we have a bg_ind
      histlabels(v==0) = bg_ind; % border regions in pascal will be background
    else
      histlabels(v==0) = 0;
    end
    histlabels = histlabels(:);
  end
  
  finalHists{1} = [finalHists{1}; hists];
  finalHLabels{1} = [finalHLabels{1}; histlabels];
  
  A = sparse(length(segs), length(segs));  
  for col = 1:length(segs)
    A(segs(col).adj, col) = 1;
  end
  B = A;
  H = hists;
  for neighbors = 1:4
    hists = H;
    for col = 1:length(segs)
      segs(col).adj = setdiff(find(B(:,col)), col);
      hists(col,:) = hists(col,:) + sum(H(segs(col).adj, :), 1);
    end

    finalHists{neighbors + 1} = [finalHists{neighbors + 1}; hists];
    finalHLabels{neighbors + 1} = [finalHLabels{neighbors + 1}; histlabels];

    B = B*A;
  end
  
  finalW = [finalW; w];
  finalH = [finalH; h];

  end

  %
  % Save back
  %
  
  n = fullfile('data', sprintf('%05d', seg_id)) ;
  
  w = finalW;
  h = finalH;

  file = fullfile(path, bk.tag, [n '.w']);
  saveWSel(file, w, sel) ;
  file = fullfile(path, bk.tag, [n '.h']);
  saveH(file, h) ;

  for neighbors = 0:4
    ext = sprintf('.hseg%d', neighbors);
    file = fullfile(path, bk.tag, [n ext]);

    hists = finalHists{neighbors + 1};
    histlabels = finalHLabels{neighbors + 1};

    saveHistsHistsLabels(file, hists, histlabels);
  end
  
  fprintf('block_hist_qseg: %3.0f%% completed\n', ...
          t / length(mapkeys) * 100) ;    
end

if reduce
  bk = bkend(bk) ;
end

end
  
function saveWSel(file, w, sel)
  save(file, 'w', 'sel', '-MAT');
end

function saveH(file, h)
  save(file, 'h', '-MAT');
end

function saveHistsHistsLabels(file, hists, histlabels)
  save(file, 'hists', 'histlabels', '-MAT');
end

% --------------------------------------------------------------------
function varargout = fetch__(bk, what, varargin)
% --------------------------------------------------------------------
global wrd ;

switch lower(what)
  
  case 'db'
    varargout{1} = bkfetch(bk.db.tag, 'db') ;
    
  case 'dictionary'
    varargout{1} = bkfetch(bk.dict.tag, 'dict') ;
    
  case 'histogram'
    i = varargin{1} ;
    path = fullfile(bk.path, bk.tag, 'data', sprintf('%05d.h', i)) ;    
    data = load(path, '-MAT') ;
    varargout{1} = data.h ;
    
  case 'words'
    i = varargin{1} ;
    path = fullfile(bk.path, bk.tag, 'data', sprintf('%05d.w', i)) ;    
    data = load(path, '-MAT') ;
    varargout{1} = data.w ;
    if nargout > 1
      varargout{2} = data.sel ;
    end

  case 'seghistograms'
    i = varargin{1} ;
    n = 0;
    if length(varargin) > 1
      n = varargin{2};
    end
    path = fullfile(bk.path, bk.tag, 'data', sprintf('%05d.hseg%d', i, n)) ;
    data = load(path, '-MAT') ;
    hists = data.hists;
    varargout{1} = hists ;
    varargout{2} = data.histlabels ;
  otherwise
    error(sprintf('Unknown ''%s''.', what)) ;
end

end