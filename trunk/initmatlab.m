%% Open Matlab Pool
%%%%%%%%%%%%%%%%%%%
matlabpool open;

%% Addpaths for Berkeley DS
%%%%%%%%%%%%%%%%%%%%%%%%%%%
pctRunOnAll addpath('/home/amounir/Codebase/phd-workspace/BerkeleySEG/segbench');
pctRunOnAll addpath('/home/amounir/Codebase/phd-workspace/BerkeleySEG/segbench/lib/matlab');

%% Setenv for LibSVM
%%%%%%%%%%%%%%%%%%%%
setenv OMP_NUM_THREADS 16

%% VLFeat configurations
%%%%%%%%%%%%%%%%%%%%%%%%
p=pwd;
cd '/home/amounir/Codebase/phd-workspace/ClassSegmentation/vlfeat-0.9.9';
cd toolbox;
vl_setup;
cd(p);
clear p

%% Heap configurations
%%%%%%%%%%%%%%%%%%%%%%
pctRunOnAll addpath('/home/amounir/Codebase/phd-workspace/ClassSegmentation/Heap');

%% Edison wrapper configurations
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
pctRunOnAll addpath('/home/amounir/Codebase/phd-workspace/ClassSegmentation/edison_matlab_interface');

%% Unimodal configurations
%%%%%%%%%%%%%%%%%%%%%%%%%%
pctRunOnAll addpath('/home/amounir/Codebase/phd-workspace/ClassSegmentation/unimodal');

%% RAD configurations
%%%%%%%%%%%%%%%%%%%%%
pctRunOnAll addpath('/home/amounir/Codebase/phd-workspace/ClassSegmentation/RAD');

%% Graph based seg configurations
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
pctRunOnAll addpath(genpath('/home/amounir/Codebase/phd-workspace/ClassSegmentation/GraphSeg'));

%% NCut seg configurations
%%%%%%%%%%%%%%%%%%%%%%%%%%
pctRunOnAll addpath(genpath('/home/amounir/Codebase/phd-workspace/ClassSegmentation/ncut_multiscale_1_6'));

%% GCMex configurations
%%%%%%%%%%%%%%%%%%%%%%%
pctRunOnAll addpath('/home/amounir/Codebase/phd-workspace/ClassSegmentation/GCMex');

%% LibSVM configurations
%%%%%%%%%%%%%%%%%%%%%%%%
pctRunOnAll addpath('/home/amounir/Codebase/phd-workspace/ClassSegmentation/libsvm-mat-2.91-1');

%% VLBlocks configurations
%%%%%%%%%%%%%%%%%%%%%%%%%%
p=pwd;
cd '/home/amounir/Codebase/phd-workspace/ClassSegmentation/blocks';
blocks_setup;
cd(p);
clear p

%% MinMax configurations
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
pctRunOnAll addpath('/home/amounir/Codebase/phd-workspace/ClassSegmentation/MinMaxSelection');

%% Adaptive pyramids configurations
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% pctRunOnAll addpath(genpath('/home/amounir/Codebase/phd-workspace/AdaptivePyramids'));

%% Greet Ahmed Mounir
%%%%%%%%%%%%%%%%%%%%%
fprintf ('If you are Ahmed Mounir -> Enjoy your stay (^-^)\n')
fprintf ('If you are NOT Ahmed Mounir:\n  (a) Close Matlab - (b) Lock the screen - (c) Call Ahmed Mounir\n')

%% Open research folder
%%%%%%%%%%%%%%%%%%%%%%%
cd '/home/amounir/Codebase/phd-workspace'
