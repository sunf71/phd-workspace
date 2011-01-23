%% Pascal VOC 2007 Dataset Master File
function Bow_pascal2007(classesRange)

global globalParams;
globalParams.workerName = 'noha';
globalParams.resultPath = '/share/CIC/amounir/Data/AdaptivePyramids';

% Initialize all directory paths
VOCINIT2007

%% Step 0: Initialize the parameters

detect_opts = [];
descriptor_opts = [];
vocabulary_opts = [];
assignment_opts = [];


%% Step 1: Compute the detector

% Select one of the detector names
% Detector type is an array. You can select as much detectors as you want.
% You should also select a name for each of the detectors.
% Example:
%   detect_opts.type{1} = '...';
%   detect_opts.type{2} = '...';
%   .
%   .
%   .
%   detect_opts.type{N} = '...';
detect_opts.type{1} = 'Grid_Dorko';
detect_opts.name{1} = detect_opts.type{1};

% Only useful For Dog_Color
% 0 -> color detection, 1 -> Intensity based detection
detect_opts.grey_flag = 0;

% Used for Simple grid Detection (single scale)
detect_opts.grid_step = 10;
detect_opts.scale = 4;

% Apply the detection process
% Do_Detect(VOCopts,detect_opts);

%% Step 2: Compute the descriptor

% Select one of the descriptor names
% Descriptor type is an array. You can select as much descriptors as you
% want.
% For each descriptor, you should specify the size of that descriptor.
% Example:
%   descriptor_opts.type{1} = '...';
%   descriptor_opts.type{2} = '...';
%   .
%   .
%   .
%   descriptor_opts.type{N} = '...';
descriptor_opts.type{1} = 'SIFT_Dorko';
descriptor_opts.desc_size{1} = 128;

% Only used for SIFT
descriptor_opts.scale_magnif = 6;

% Not used in Grid detection case
descriptor_opts.color_scale = 11;

% for HarLap, DOG, LOG with color descriptors
descriptor_opts.normalize_patch_size = 21;

% only used in case of Opponent descriptor
descriptor_opts.mirror_flag = 1;

% Different detectors names.
% For each descriptor, choose the detectors that you want to assign its
% values to this descriptor.
% Example:
%   descriptor_opts.detector_name{1}{1} = '...';
%   descriptor_opts.detector_name{1}{2} = '...';
%   .
%   .
%   .
%   descriptor_opts.detector_name{N}{M} = '...';
descriptor_opts.detector_name{1}{1} = detect_opts.name{1};

% Also append detectors names to each descriptor
for type = 1:length(descriptor_opts.type)
    for detType = 1:length(descriptor_opts.detector_name{type})
        descriptor_opts.name{type}{detType} = [descriptor_opts.type{type} ...
            descriptor_opts.detector_name{type}{detType}];
    end
end

% Apply the descriptor
% Do_Descriptor(VOCopts, descriptor_opts)

%% Step 3: Compute the vocabulary

% Select one of the vocabulary construction methods for each descriptor.
% It is REQUIRED for the program to continue working to select 1 vocabulary
% for each descriptor.
% Also set the size and the sample rate of each type.
vocabulary_opts.type{1} = 'ikmeans';
vocabulary_opts.size{1} = 12000;
vocabulary_opts.sample_rate{1} = 5;

% Different descriptors names
for type = 1:length(descriptor_opts.type)
    vocabulary_opts.name{type} = [vocabulary_opts.type{type} ...
        num2str(vocabulary_opts.size{type})];
    vocabulary_opts.preprocessings_name{type} = '';
    vocabulary_opts.desc_size{type} = descriptor_opts.desc_size{type};

    for detType = 1:length(descriptor_opts.detector_name{type})
        vocabulary_opts.descriptor_name{type}{detType} = ...
            descriptor_opts.name{type}{detType};
        vocabulary_opts.name{type} = [vocabulary_opts.name{type} ...
            descriptor_opts.name{type}{detType}];
        vocabulary_opts.preprocessings_name{type} = [ ...
            vocabulary_opts.preprocessings_name{type} ...
            descriptor_opts.name{type}{detType}];
    end
end

% Apply the vocabulary construction
Do_Vocabulary(VOCopts,vocabulary_opts)   

%% Step 4: Assignment process
% Assignment types supported are :
% "hard", "pyramid"

assignment_opts.type{1} = 'hard';

% Different detectors names
for detType = 1:length(detect_opts.type)
    assignment_opts.detector_name{type} = ...
        detect_opts.name{type};
end

% Different descriptors names
for type = 1:length(descriptor_opts.type)
    for detType = 1:length(descriptor_opts.detector_name{type})
        assignment_opts.descriptor_name{type}{detType} = ...
            descriptor_opts.name{type}{detType};
    end
end

% Vocabulary's name
assignment_opts.vocabulary_name{1} = vocabulary_opts.name{1};

% Vocabulary's size
assignment_opts.vocabulary_size{1} = vocabulary_opts.size{1};

% Assignment name
assignment_opts.name{1} = [assignment_opts.type{1} vocabulary_opts.name{1}];
        
if(strcmp(assignment_opts.type,'pyramid'))
    % Possible parameters: 'Marcin', 'Lazebnik', 'Noha'
    assignment_opts.pyramid_type='Noha';

    % Lazebnik pyramids' code start at level 1 (Whole image).
    % Marcin pyramids' code start at level 0 (Whole image).
    % This parameter indicates the maximum level required from the pyramid.
    assignment_opts.level=3;
    
    % Name of the generated assignment
    assignment_opts.name= ...
        strcat(vocabulary_opts.name, ...
               assignment_opts.pyramid_type, ...
               num2str(assignment_opts.level));

    % Index name
    assignment_opts.index_name= ...
        strcat('ikmeansSIFT_DorkoGrid_Dorko12000', ...
        '_aib4000', ...
        '_hybrid_index');
    
    % Run the assignment using pyramids
    Do_assignment_pyramids_main_par(VOCopts,assignment_opts);

elseif(strcmp(assignment_opts.type,'hard'))
    % Adjust the parameters
    assignment_opts.soft_assign = 0.1;
    assignment_opts.nn_neighbours_file = 4;
    Do_assignment_par(VOCopts,assignment_opts);
end

%% Optional Step: Vocabulary Compression
voccompression_opts.set_flag=0;

if(voccompression_opts.set_flag)
    % Compression type
    voccompression_opts.type='aib';
    
    % New vocabulary size
    voccompression_opts.vocsize=200;
    
    % AIB Compression parameters
    voccompression_opts.assignmentname=assignment_opts.name;
    voccompression_opts.get_index= ...
        strcat(assignment_opts.name,'_hybrid_index');
    voccompression_opts.clusterindex= ...
        strcat(assignment_opts.name, ...
        '_',voccompression_opts.type, ...
        num2str(voccompression_opts.vocsize),'_hybrid_index');

    % Compression parameters
    voccompression_opts.name=strcat(assignment_opts.name,'_', ...
        voccompression_opts.type,num2str(voccompression_opts.vocsize));

    % Apply the compression
    Do_Voccompression(VOCopts,voccompression_opts)                   
end

%% Step 5: Classification using SVM

if(voccompression_opts.set_flag)
    classification_opts.assignment_name= voccompression_opts.name;
else
    classification_opts.num_histogram=1;
    classification_opts.assignment_name= assignment_opts.name;
end

% Range of PASCAL VOC classes to apply our method:
% Aeroplane     1
% Bicycle       2
% Bird          3
% Boat          4
% Bottle        5
% Bus           6
% Car           7
% Cat           8
% Chair         9
% Cow           10
% Diningtable   11
% Dog           12
% Horse         13
% Motorbike     14
% Person        15
% Pottedplant   16
% Sheep         17
% Sofa          18
% Train         19
% TVMonitor     20
if nargin == 0 % Work on all classes
    classesRange = 1:20;
end

% Run the classifier
[svm_score,best_CV]=Do_Classifiy_libSVM_pascal2007( ...
    VOCopts,classification_opts,classesRange);

end
  
