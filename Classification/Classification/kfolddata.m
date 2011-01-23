function [TestSamples, TestLabels, TrainSamples, TrainLabels] = kfolddata(Samples, Labels, K, i)
% This function prepares data for standard K-fold cross validation (not stratified).
% This function is often called from within a loop like for i = 1:K,.....end unless it is used for 
% partitioning (K=2).   No shuffling is done here.  It can be used for Multivariate output regression too.
% For regression, use this function (not kfoldBaldata which is stratified so, better for classification)
% INPUT: 
%    Samples (of the whole dataset): every column is an example (rows are attribs)
%    Labels (of the whole dataset),  For classification Labels = (1xM).
%              In regression, Labels are the target values; so Labels(i, j): the ith output for the jth example.
%    K (K-fold CV)
%    i (the ith fold i.e. the ith iteration in the loop)
% OUTPUT: TestSamples, TestLabels (Test data of size=
% floor(length(Labels)/K)) and ALL the REST= training data


M = size(Samples, 2);    testsize = floor(M/K);           % Test data size;   training size = M - testsize; 

startpos = (i-1)*testsize +1;   endpos = i*testsize;    % beginning and end of test examples
TestSamples = Samples(:, (startpos:endpos));           % test data (1/K of M points) is separated
TestLabels = Labels(:, startpos:endpos);
                                                       % Training data (the rest of data):
if i==1, 
   TrainSamples = Samples(:, (endpos+1:end)); 
   TrainLabels = Labels(:, endpos+1:end); 
elseif (i < K | testsize ~= (M/K)),                    % ie some point(s) left at the end of arrays
   TrainSamples = Samples(:, [1:startpos-1, endpos+1:end]);
   TrainLabels = Labels(:, [1:startpos-1, endpos+1:end]); 
else                                                   % ie i=K and no point left at the end of arrays
   TrainSamples = Samples(:, (1:startpos-1)); 
   TrainLabels = Labels(:, 1:startpos-1); 
end