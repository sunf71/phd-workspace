function bk = block_vismulti(bk, varargin)
% BLOCK_VISMULTI Visualize multi-class segmentation problems
%   Visualize multi-class localization (such as Pascal-07).
%
%   BK = BLOCK_VISMULTI() Initializes the block with the default
%   options.
%
%   BK = BLOCK_VISMULTI(BK) Executes the block with options and inputs
%   BK.
%
%   Required input:
%
%   db::
%     The database.
%
%   prediction::
%     The output of the localization classifier.
%
%   Fetchable attributes:
%
%   report::
%     A structure containing a report on the results which has fields:
%     pixelscorrect:  The total percent of pixels which are correct.
%     accuracies:     The pixel accuracies for each category.
%     accuracies_int: The intersection-union for each category.
%     avgacc:         The average of the class accuracies.
%     avgacc_int:     The average of the intersection-union
%                     accuracies.
%     conf:           The full confusion matrix.
%     cat_names:      Category names used.

% AUTORIGHTS
% Copyright (c) 2009 Brian Fulkerson and Andrea Vedaldi
% Blocks is distributed under the terms of the modified BSD license.
% The full license may be found in LICENSE.

global wrd ;

if nargin == 0
  bk = bkinit('vismulti', 'db', 'prediction') ;
  bk.fetch = @fetch__ ;
  return ;
end

% --------------------------------------------------------------------
%                                                    Check/load inputs
% --------------------------------------------------------------------

[bk, dirty] = bkbegin(bk) ;
if ~ dirty, return ; end

db = bkfetch(bk.db.tag, 'db') ;
bkpred = bkfetch(bk.prediction.tag);
testsel = find([db.segs.flag] == db.TEST);


ncats = length(db.cat_names);
confcounts = zeros(ncats);
offset = 1 - min(db.class_ids); % account for 0 bg category if it exists

original_db_paths = [];

avgSegCount = 0;

for i = 1:length(testsel)
  seg_id = db.segs(testsel(i)).seg;
  seg = db.segs(testsel(i));
  [class3 confidence] = bkfetch(bkpred, 'test', seg_id);
  segs = bkfetch(bkpred.qseg.tag, 'segs', seg_id);
  avgSegCount = avgSegCount + length(segs);

  % TODO: Thresh is broken for crf case
  if isfield(bk, 'thresh') 
    bgid = 21;
    mconf = max(confidence,[],3);
    ind = find(mconf < bk.thresh);
    class3(ind) = bgid;
  end

  original_db_paths = char(original_db_paths, seg.classseg);

  gtim = double(imread(seg.classseg));
  resim = db.class_ids(class3);

  locs = gtim < 255; %exclude border / void regions
  ind = find(locs);
  sumim = offset + gtim + (resim-(1-offset))*ncats;
  confcounts(:) = vl_binsum(confcounts(:), ones(size(ind)), sumim(ind));
  fprintf('block_vismulti: %d/%d\r', i, length(testsel));

end

avgSegCount = avgSegCount / length(testsel);

% load('/home/amounir/Workspace/Superpixels-iccv2009/results/seg_size_accuracy.mat');
% load('/home/amounir/Workspace/Superpixels-iccv2009/results/how_many_segs.mat');
% % Update seg_size VS accuracy array
% for i = 1:length(testsel)
%   seg_id = db.segs(testsel(i)).seg
%   seg = db.segs(testsel(i));
%   [class3 confidence] = bkfetch(bkpred, 'test', seg_id);
% 
%   % TODO: Thresh is broken for crf case
%   if isfield(bk, 'thresh') 
%     bgid = 21;
%     mconf = max(confidence,[],3);
%     ind = find(mconf < bk.thresh);
%     class3(ind) = bgid;
%   end
% 
%   original_db_paths = char(original_db_paths, seg.classseg);
% 
%   gtim = double(imread(seg.classseg));
%   resim = db.class_ids(class3);
% 
%   segs = bkfetch(bkpred.qseg.tag, 'segs', seg_id);
%   for seg_ind = 1:length(segs)
%     gtVals = gtim(segs(seg_ind).ind);
%     resVals = resim(segs(seg_ind).ind);
%     diff = gtVals - resVals;
%     correct = sum(diff == 0);
% 
%     borders_count = sum(gtVals == 255);
%     if(length(gtVals) == borders_count)
%         continue;
%     end
%     
%     [counts, vals] = count_unique(gtVals);
%     [mx, mi] = max(vals);
%     maxVal = counts(mi);
%     
%     classInd = find(db.class_ids == maxVal);
%     
%     acc = correct / (segs(seg_ind).count - borders_count);
%     
%     if(acc == 2)
%         x = 0;
%     end
%     
%     seg_size_accuracy(classInd, segs(seg_ind).count - borders_count) = seg_size_accuracy(classInd, segs(seg_ind).count - borders_count) + acc;
%     how_many_segs(classInd, segs(seg_ind).count - borders_count) = how_many_segs(classInd, segs(seg_ind).count - borders_count) + 1;
%   end
% 
% end
% save('/home/amounir/Workspace/Superpixels-iccv2009/results/seg_size_accuracy.mat', ...
%     'seg_size_accuracy', '-MAT');
% save('/home/amounir/Workspace/Superpixels-iccv2009/results/how_many_segs.mat', ...
%     'how_many_segs', '-MAT');

conf = zeros(ncats);
rawcounts = confcounts;
overall_acc = 100*sum(diag(confcounts)) / sum(confcounts(:));

accuracies = zeros(ncats,1);
accuracies_int = zeros(ncats,1);
for j = 1:ncats
  rowsum = sum(confcounts(j,:));
  if rowsum > 0, conf(j, :) = 100*confcounts(j,:)/rowsum; end;
  accuracies(j) = conf(j,j);

  gtj=sum(confcounts(j,:));
  resj=sum(confcounts(:,j));
  gtjresj=confcounts(j,j);
  % The accuracy is: true positive / (true positive + false positive + false negative) 
  % which is equivalent to the following percentage:
  accuracies_int(j)=100*gtjresj/(gtj+resj-gtjresj);   
end

report = struct();
report.pixelscorrect = overall_acc;
report.accuracies = accuracies;
report.accuracies_int = accuracies_int;
report.avgacc = mean(accuracies);
report.avgacc_int = mean(accuracies_int);
report.conf = conf;
[sorted ind] = sort(db.class_ids); 
% reorder the class names to match the confusion
report.cat_names = db.cat_names(ind);
report.avgSegCount = avgSegCount;

fprintf('block_vismulti: *********************************\n');
fprintf('block_vismulti: %% pixels labeled correctly %4.2f%%\n', overall_acc);
fprintf('Accuracy: ');
fprintf('%.2f ', accuracies);
fprintf('\nAverage: %.2f\n', report.avgacc);
fprintf('Accuracy (Intersection/Union): ');
fprintf('%.2f ', accuracies_int);
fprintf('\nAverage (Intersection/Union): %.2f\n', report.avgacc_int);
fprintf('\nAverage segments count: %.2f\n', report.avgSegCount);
fprintf('block_vismulti: *********************************\n');
save(fullfile(wrd.prefix, bk.tag, 'report.mat'), ...
     '-STRUCT', 'report', '-MAT') ;

bk = bkend(bk) ;

% --------------------------------------------------------------------
function varargout = fetch__(bk, what, varargin)
% --------------------------------------------------------------------

global wrd ;

switch lower(what)
  case 'report'
    report = load(fullfile(bk.path, bk.tag, 'report.mat'));
    varargout{1} = report;

  otherwise
    error(sprintf('Unknown ''%s''.', what)) ;
end


