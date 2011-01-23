%% VOC 2007 Initialize File

global globalParams;

clear VOCopts

% get devkit directory
pascalroot='/home/amounir/Workspace/Datasets/Pascal/VOC2007';

% change this path to point to your copy of the Pascal data
VOCopts.datadir=pascalroot;

% change this path to a writable directory for your results
VOCopts.resdir = globalParams.resultPath;

% initialize main challenge paths
VOCopts.annopath=[VOCopts.datadir  '/Labels'];
VOCopts.imgpath=[VOCopts.datadir  '/JPEGImages'];

VOCopts.datapath=[VOCopts.resdir  '/Data'];
VOCopts.data_globalpath=[VOCopts.datapath  '/Global'];
VOCopts.data_vocabularypath=[VOCopts.data_globalpath  '/Vocabulary'];
VOCopts.data_assignmentpath=[VOCopts.data_globalpath  '/Assignment'];
VOCopts.resize_imgpath=[VOCopts.resdir  '/ResizedImages'];
VOCopts.data_locations=sprintf('%s/data_locations.mat', ...
    VOCopts.data_globalpath);

% To add the bounding box knowledge 
VOCopts.annotationpath=[VOCopts.datadir  '/Annotations/%s.xml'];

% additional 2 things for creating labels from imagesets
VOCopts.imgsetpath=[VOCopts.datadir '/ImageSets/Main/%s.txt'];
VOCopts.clsimgsetpath=[VOCopts.datadir  '/ImageSets/Main/%s_%s.txt'];
VOCopts.clsrespath=[VOCopts.resdir '/VOC2007/%s.txt' ];

% initialize the training set
% use train for development
% use train+val for final challenge
VOCopts.trainset=sprintf('%s/trainset.mat',VOCopts.annopath);

% initialize the test set
% use validation data for development test set
VOCopts.testset=sprintf('%s/testset.mat',VOCopts.annopath);

% initialize the annotations
VOCopts.labels=sprintf('%s/labels.mat',VOCopts.annopath); 

% initialize the image names
VOCopts.image_names=sprintf('%s/image_names.mat',VOCopts.annopath);



% initialize the VOC challenge options

% VOC2008 classes

VOCopts.classes={...
    'aeroplane'
    'bicycle'
    'bird'
    'boat'
    'bottle'
    'bus'
    'car'
    'cat'
    'chair'
    'cow'
    'diningtable'
    'dog'
    'horse'
    'motorbike'
    'person'
    'pottedplant'
    'sheep'
    'sofa'
    'train'
    'tvmonitor'};

VOCopts.nclasses=length(VOCopts.classes);	

% Create the labels structure
DoLabels
try
    load(sprintf('%s',VOCopts.labels));
    VOCopts.nimages=size(labels,1);
catch
    display('number of images is not initialized');
end

MakeDirectories(VOCopts);

% options for example implementations

% VOCopts.exfdpath=[VOCopts.localdir '%s_fd.mat'];
VOCopts.minoverlap=0.5;