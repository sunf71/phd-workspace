function bk = block_test_segloc(bk, varargin)
% BLOCK_TEST_SEGLOC Classify with superpixel neighborhoods
%   Superpixel neighborhoods, as proposed in Fulkerson et. al 2009.
%
%   BK = BLOCK_TEST_SEGLOC() Initializes the block with the default
%   options.
%
%   BK = BLOCK_TEST_SEGLOC(BK) Executes the block with options and
%   inputs BK.
%
%   Required inputs:
%
%   db::
%     The database.
%
%   hist::
%     The segment histograms.
%
%   classifier::
%     The trained segment classifier.
%
%   Options:
%
%   bk.rand_seed::
%     Set the random seeds before proceeding. Default of [] does not
%     change the seeds.
%
%   bk.seg_neighbors::
%     The number of neighbors to use. Default 0.
%
%   bk.testall::
%     Test on all segments instead of only training segments. Default
%     0.
%
%   Fetchable attributes:
%
%   test::
%     Classification result (images). Returns [class confidence] for
%     required input: seg_id.
%
%   segtest::
%     Classification result (superpixels). Returns [class confidence]
%     for required input: seg_id. class is a vector Nx1 where N is the
%     number of superpixels. confidence is a matrix Nx1 cell array,
%     where each cell is a Cx1 vector expressing the confidence in
%     each of C classes.

% AUTORIGHTS
% Copyright (c) 2009 Brian Fulkerson and Andrea Vedaldi
% Blocks is distributed under the terms of the modified BSD license.
% The full license may be found in LICENSE.

global wrd ;

if nargin == 0
  bk           = bkinit('test_segloc', 'db', 'hist', 'classifier') ;
  bk.fetch     = @fetch__ ;
  bk.rand_seed = [] ;
  bk.seg_neighbors = 0;
  bk.testall = 0;
  return ;
end

% --------------------------------------------------------------------
%                                                    Check/load inputs
% --------------------------------------------------------------------

[bk, dirty] = bkbegin(bk) ;
if ~ dirty, return ; end

db     = bkfetch(bk.db.tag, 'db') ;
classifier = bkfetch(bk.classifier.tag, 'type');
bkclassifier = bkfetch(bk.classifier.tag);

% --------------------------------------------------------------------
%                                                       Do computation
% --------------------------------------------------------------------

if bk.testall
  keys = 1:length(db.segs) ;
else
  keys = find([db.segs.flag]==db.TEST) ;
end
[reduce, mapkeys] = bksplit(bk, keys, varargin{:}) ;
ensuredir(fullfile(wrd.prefix, bk.tag, 'data')) ;

cl = bkfetch(bk.classifier.tag, 'cl');
fprintf('block_test_segloc: Classifier loaded\n');

path = wrd.prefix;

parfor t=1:length(mapkeys)

  if ~ isempty(bk.rand_seed)
    setrandseeds(bk.rand_seed + mapkeys(t)-1) ;
  end
    
  seg_id = db.segs(mapkeys(t)).seg ;
  fprintf('block_test_segloc: seg_id: %d\n', seg_id); 
  % fetch segment histograms
  hists = bkfetch(bk.hist.tag, 'seghistograms', seg_id, bk.seg_neighbors);
  segs = bkfetch(bk.qseg.tag, 'segs', seg_id); 
  I    = bkfetch(bk.qseg.tag, 'segimage', seg_id);
  t0 = cputime;

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
  segtime = cputime - t0;

  class = ones(size(I,1), size(I,2))*cl.bg_cat;
  confidence = zeros(size(I,1), size(I,2),length(dec{1}));
  for j = 1:size(confidence, 3)
    c2 = zeros(size(class));
    for i = 1:nsegs
      if j == 1, class(segs(i).ind) = pred(i); end
      c2(segs(i).ind) = dec{i}(j);
    end
    confidence(:,:,j) = c2;
  end
  confidence = abs(confidence);

  classifytime = cputime - t0;

  % save results
  n = fullfile('data', sprintf('%05d', seg_id)) ;
  
  file = fullfile(path, bk.tag, [n '.test']);
  saveClassConfidence(file, class, confidence);
  
%   file = fullfile(path, bk.tag, 'class_confidence_mat', [n '.mat']);
%   saveClassConfidence(file, class, confidence);
  
  file = fullfile(path, bk.tag, [n '.segtest']);
  savePredDec(file, pred, dec);
  
  file = fullfile(path, bk.tag, [n '.time']);
  saveClassifyTimeSegTime(file, classifytime, segtime);
  
%   save(fullfile(wrd.prefix, bk.tag, [n '.test']), 'class', 'confidence', '-MAT');
%   save(fullfile(wrd.prefix, bk.tag, [n '.segtest']), 'pred', 'dec', '-MAT');
%   save(fullfile(wrd.prefix, bk.tag, [n '.time']), 'classifytime', 'segtime', '-MAT');

  fprintf('block_test_segloc: %3.0f%% completed\n', ...
          t / length(mapkeys) * 100) ;    
end

if reduce
  bk = bkend(bk) ;
end

end

function saveClassConfidence(file, class, confidence)
  if (exist(file) == 2)
      return;
  end
  save(file, 'class', 'confidence', '-MAT');
end

function savePredDec(file, pred, dec)
  if (exist(file) == 2)
      return;
  end
  save(file, 'pred', 'dec', '-MAT');
end

function saveClassifyTimeSegTime(file, classifytime, segtime)
  if (exist(file) == 2)
      return;
  end
  save(file, 'classifytime', 'segtime', '-MAT');
end

% --------------------------------------------------------------------
function varargout = fetch__(bk, what, varargin)
% --------------------------------------------------------------------
global wrd ;

switch lower(what)
  
  case 'test'
    i = varargin{1} ;
    path = fullfile(bk.path, bk.tag, 'data', sprintf('%05d.test', i)) ;
    data = load(path, '-MAT') ;
    varargout{1} = data.class ;
    varargout{2} = data.confidence ;

  case 'segtest'
    i = varargin{1} ;
    path = fullfile(bk.path, bk.tag, 'data', sprintf('%05d.segtest', i)) ;
    data = load(path, '-MAT') ;
    varargout{1} = data.pred ;
    varargout{2} = data.dec ;

  otherwise
    error(sprintf('Unknown ''%s''.', what)) ;
end

end
