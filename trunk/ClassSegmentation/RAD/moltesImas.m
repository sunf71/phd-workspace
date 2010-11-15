differentiation =[0.5 0.5 1 1 0.8 0.5 0.5 1 1 0.8];
integration = [0.8 1.5 1 1.5 0.5 0.8 1.5 1 1.5 0.5];
superPixel =  [1 1 1 1 1 0 0 0 0 0];


pathImages = ('G:\CVC\pictures\BSDS300\images\testANDtrain\');
thisPath = cd;

for numberOfSegmentations = 6:length(differentiation)

    %Let's create a folder with the name of MS plus spatial and range
    %values. It will contain segmented images
    currentSegmentationFolder = strcat('RAD_',num2str(differentiation(numberOfSegmentations)),'_',...
        num2str(integration(numberOfSegmentations)),'_Super_',num2str(superPixel(numberOfSegmentations)));
    mkdir(currentSegmentationFolder)

    %dir of the folder containing images to be segmented
    cd(pathImages);
    d=dir('*.jpg');
    cd(thisPath)
    

    for i=1:length(d),
        %reads next image to be segmented
        im = imread(strcat(pathImages,d(i).name));
      
        
        [imRes]=superPixelRADsegmentation(differentiation(numberOfSegmentations),...
            integration(numberOfSegmentations),0.5,80,im,1,superPixel(numberOfSegmentations));
        
        cd(currentSegmentationFolder)
        imwrite(uint8(imRes),strrep(d(i).name,'.jpg','.png'));
        cd ..
    end
end

cd('FullMatlabCode')
thisPath = cd;
differentiation =[0.5 0.5 1.0 1 1.0];
integration =    [1.0 0.5 0.5 1 1.5];
superPixel =     [0 0 0 0 0];

pathImages = ('G:\CVC\pictures\BSDS300\images\testANDtrain\');
thisPath = cd;

for numberOfSegmentations = 1:length(differentiation)

    %Let's create a folder with the name of MS plus spatial and range
    %values. It will contain segmented images
    currentSegmentationFolder = strcat('RAD_',num2str(differentiation(numberOfSegmentations)),'_',...
        num2str(integration(numberOfSegmentations)),'_Super_',num2str(superPixel(numberOfSegmentations)));
    mkdir(currentSegmentationFolder)

    %dir of the folder containing images to be segmented
    cd(pathImages);
    d=dir('*.jpg');
    cd(thisPath)
    
    for i=1:length(d),
        %reads next image to be segmented
        im = imread(strcat(pathImages,d(i).name));
      
        [imRes]=RADsegmentation(differentiation(numberOfSegmentations),...
            integration(numberOfSegmentations),64,im,1,superPixel(numberOfSegmentations),0);
        
        cd(currentSegmentationFolder)
        imwrite(uint8(imRes),strrep(d(i).name,'.jpg','.png'));
        cd ..
    end
end








% addpath(cd)
% pathMethod=cd;
% 
% 
% cd(pathMethod)
% % 0_2
% weightActual = '1_1stats1_1weight0.2';
% weightActualNetes = strcat(weightActual,'Netes');
% pathname='/home/eduard/Pictures/PhD/train/'; 
% cd(pathname);
% mkdir(weightActual)
% d=dir('*.jpg');
% weight = 0.2;
% normalVal = 10000;
% sigma_1=1;
% sigma_2=1;
% scriptLecturaDirs2
% 
% cd(pathMethod)
% pathnameRes=strcat('/home/eduard/Pictures/PhD/train/',weightActual,'/');
% pathname='/home/eduard/Pictures/PhD/train/';
% cd(pathnameRes);
% d=dir('*.bmp');
% cd(pathname)
% mkdir(weightActualNetes)
% netejaImasPer_GCE2
% 
