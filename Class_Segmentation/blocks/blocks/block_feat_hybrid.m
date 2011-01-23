function bk = block_feat_hybrid(bk, varargin)
% BLOCK_FEAT  Extract features from images in a database.
%   This block extracts features from images in a database.
%
%   BK = BLOCK_DICTIONARY() Initializes the block with the default
%   options.
%
%   BK = BLOCK_DICTIONARY(BK) Executes the block with options and
%   inputs BK.
%
%   Required Inputs:
%
%   db::
%     The database to extract features from. All segments will be
%     processed.
%
%   Options:
%
%   bk.rand_seed::
%     Set the random seed. Default is [], which does not change the
%     random seed.
%
%   bk.detector::
%     The type of feature detector to use. Default 'sift'. Valid types
%     are:
%     sift:         Standard SIFT detector (DoG) from VLFeat.
%     ipld:         Harris multiscale + DoG (IPLD implementation).
%     iplddog:      The DoG from the IPLD implementation.
%     dsift:        Dense/home/amounir/Workspace SIFT. Only compatible with dsift descriptor.
%     dsift-color:  Same as dsift. Only compatible with dsift-color
%                   descriptor.
%
%   bk.descriptor::
%     The type of feature descriptor to use. Default 'sift'. Valid
%     types are:
%     sift:         Standard SIFT descriptor from VLFeat.
%     siftnosmooth: Standard SIFT descriptor which ommits smoothing.
%     ipld:         Standard SIFT descriptor (IPLD implementation).
%     dsift:        Dense SIFT descriptor.
%     dsift-color:  Dense color SIFT descriptor
%
%   bk.ref_size::
%     Resize images to have their longest side equal to this number
%     before processing. Default of [] means leave the images
%     unmodified.
%
%   bk.min_sigma::
%     Throw away detected features whose frame size is less than
%     min_sigma. Frame size is relative to the ref_size of the image.
%   
%   bk.max_num:: 
%     A limit on how many features are extracted. Default +inf.
%
%   bk.rescale::
%     Descriptors are computed on regions whose radius is rescale times
%     the scale sigma of the frame. For the standard sift descriptor,
%     for instance, rescale is two times the magnification paramter of
%     the descriptor. Default 6.
%
%   DSIFT and DSIFT-COLOR Options:
%
%   bk.dsift_size:
%     The size of a spatial bin in dsift. For example, 3 will create a
%     descriptor which is 12x12 pixels. This option is required when
%     using this descriptor.
%
%   bk.dsift_step:
%     The step size in pixels between descriptors. 1 produces a
%     descriptor for every pixel of the image. This option is required
%     when using this descriptor.
%
%   DSIFT-COLOR Options:
%
%   bk.dsift_minnorm:
%     Discard descriptors whose norm is less than dsift_minnorm in
%     both the red and green channels.

% AUTORIGHTS
% Copyright (c) 2009 Brian Fulkerson and Andrea Vedaldi
% Blocks is distributed under the terms of the modified BSD license.
% The full license may be found in LICENSE.

global wrd ;

if nargin == 0
  bk             = bkinit('feat', 'db') ;
  bk.fetch       = @fetch__ ;
  bk.rand_seed   = [] ;
  bk.detector    = 'sift' ;
  bk.descriptor  = 'siftnosmooth' ;
  bk.ref_size    = [] ;
  bk.min_sigma   = 0 ;
  bk.max_num     = +inf ; 
  bk.rescale     = 6 ;
  return ;
end

% --------------------------------------------------------------------
%                                                    Check/load inputs
% --------------------------------------------------------------------

% [bk, dirty] = bkbegin(bk) ;
% if ~ dirty, return ; end

db = bkfetch(bk.db.tag, 'db') ;

% --------------------------------------------------------------------
%                                                       Do computation
% --------------------------------------------------------------------

fprintf('block_feat: detector  : %s\n', bk.detector) ;
fprintf('block_feat: descriptor: %s\n', bk.descriptor) ;
fprintf('block_feat: ref_size  : %s\n', num2str(bk.ref_size)) ;
fprintf('block_feat: min_sigma : %f\n', bk.min_sigma) ;
fprintf('block_feat: max_num   : %d\n', bk.max_num) ;
fprintf('block_feat: rescale   : %f\n', bk.rescale) ;

if strcmp(bk.detector, 'dsift') && ~strcmp(bk.detector, bk.descriptor)
    error('Detector and descriptor should be the same for dsift');
end
% --------------------------------------------------------------------
%                                                       Do computation
% --------------------------------------------------------------------

keys = 1:length(db.segs) ;
[reduce, mapkeys] = bksplit(bk, keys, varargin{:}) ;
ensuredir(fullfile(wrd.prefix, bk.tag, 'data')) ;
path = wrd.prefix;

% These are the paths that the results from the segmentation are saved in
% '/home/amounir/Workspace/Superpixels-iccv2009/results/Original_Method_Parallelized',
seg_res_paths = char('/home/amounir/Workspace/Superpixels-iccv2009/results/FEX_MS_MS_1', ...
                     '/home/amounir/Workspace/Superpixels-iccv2009/results/FEX_MS_MS_2');
seg_res_paths = cellstr(seg_res_paths);
    
% Iterate on the images in the dataset
for t=1:length(mapkeys)

  % Initialize values of f and d
  d = [];
  f = [];

  for current_path_ind = 1:length(seg_res_paths)

      % Go to the results dir to fetch the different segmentations
      cd(seg_res_paths{current_path_ind});

      % ------------------------------------------------------------------
      %                                                         Preprocess
      % ------------------------------------------------------------------

      seg_id = db.segs(mapkeys(t)).seg ;
      % read segmented image
      segImage = bkfetch(bk.qseg.tag, 'segimage', seg_id);

      % ------------------------------------------------------------------
      %                                              Detector & Descriptor
      % ------------------------------------------------------------------

      % Need to combine, possibly with norms
      segImageSingle = im2single(segImage);
      [featR,desR] = vl_dsift(segImageSingle(:,:,1), 'size', bk.dsift_size, 'step', ...
        bk.dsift_step, 'fast', 'norm');
      [featG,desG] = vl_dsift(segImageSingle(:,:,2), 'size', bk.dsift_size, 'step', ...
        bk.dsift_step, 'fast', 'norm');
      [featB,desB] = vl_dsift(segImageSingle(:,:,3), 'size', bk.dsift_size, 'step', ...
        bk.dsift_step, 'fast', 'norm');

      % without norms
      td = [desR; desG; desB];
      tf = featR(1:2,:);

      sigma = bk.dsift_size * 4 / 6;
      tf = [tf; sigma * ones(1, size(tf,2)); pi / 2 * ones(1, size(tf,2))];

      % remove frames if too close to the boundary
      [M,N,k] = size(segImage) ;
      R = tf(3,:) * bk.rescale ;

      keep = tf(1,:) - R >= 1 & ...
             tf(1,:) + R <= N & ...
             tf(2,:) - R >= 1 & ...
             tf(2,:) + R <= M ;

      tf = tf(:, keep);
      td = td(:, keep);

      % ------------------------------------------------------------------
      %                                                       Post process
      % ------------------------------------------------------------------
      
      % Add them to the original f and d
      d = [d td];
      f = [f tf];
  end

  % ------------------------------------------------------------------
  %                                                               Save
  % ------------------------------------------------------------------
  n = fullfile('data', sprintf('%05d', seg_id)) ;
  ffile = fullfile(path, bk.tag, [n '.f']);
  dfile = fullfile(path, bk.tag, [n '.d']);
  saveF(ffile, f) ;
  saveD(dfile, d) ;  
  fprintf('block_feat: %3.0f%% completed\n', ...
          t / length(mapkeys) * 100) ;  
end

if reduce
  bk = bkend(bk) ;
end

end

function saveF(file, f)
    save(file, 'f', '-MAT');
end

function saveD(file, d)
    save(file, 'd', '-MAT');
end

% --------------------------------------------------------------------
function varargout = fetch__(bk, what, varargin)
% --------------------------------------------------------------------

global wrd ;

switch lower(what)
  
  case 'descriptors'
    i = varargin{1} ;
    path = fullfile(bk.path, bk.tag, 'data', sprintf('%05d.d', i)) ;    
    data = load(path, '-MAT') ;
    varargout{1} = data.d ;
    
  case 'frames'
    i = varargin{1} ;
    path = fullfile(bk.path, bk.tag, 'data', sprintf('%05d.f', i)) ;    
    data = load(path, '-MAT') ;
    varargout{1} = data.f ;
    
  otherwise
    error(sprintf('Unknown ''%s''.', what)) ;
end

end