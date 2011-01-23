function MakeDirectories(opts)

% Ensure the Labels directory exists
if exist(opts.datapath, 'dir')
    return;
end

% For pascal data sets
mkdir(sprintf('%s',opts.datapath));
img_names=load(opts.image_names);
img_names=getfield(load(opts.image_names),'image_names');
for ii=1: length(img_names)
    a1=img_names{ii};
          a2=a1(1:6);   %%%% for pascal 2007
    mkdir(sprintf('%s',opts.datapath),a2 );
    data_locations{ii}=sprintf('%s/%s',opts.datapath,a2);
end
mkdir(sprintf('%s',opts.data_globalpath));
mkdir(sprintf('%s',opts.data_vocabularypath));
mkdir(sprintf('%s',opts.data_assignmentpath));
mkdir(sprintf('%s',opts.resize_imgpath));
save(sprintf('%s/data_locations',opts.data_globalpath));

global globalParams;
system(sprintf('chmod -R a+rwx %s', globalParams.resultPath));