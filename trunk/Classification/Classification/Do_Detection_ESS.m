%  ******************************************
%  *                                        *
%  *     AUTHOR         : Davide Modolo     *
%  *     LAST CHANGES   : 30/07/2008        *
%  *                                        *
%  ******************************************

function Do_Detection_ESS(opts, classification_opts,settings,weights)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Display Message %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
display('Starting the ESS based Detection:');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Some Baseline Settings %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
VOCINIT2007
 load(opts.trainset)
 temp.annotationpath1=opts.annotationpath;
 temp.minoverlap=opts.minoverlap;
 load(opts.data_locations);
 opts.annotationpath=temp.annotationpath1;
 opts.minoverlap=temp.minoverlap;
 load(opts.testset)
 load(opts.image_names)
 nimages=opts.nimages;
 labels=getfield(load(opts.labels),'labels');
 nclasses=opts.nclasses;
 clst_name='ikmeansSIFT_DorkoGrid_Dorko12000_aib300';
 opts.resultfolder='/home/fahad/Datasets/Pascal_2007_original/VOCdevkit/VOC2007/Results_ESS/';
 opts.clstfolder='/home/fahad/Datasets/Pascal_2007_original/VOCdevkit/VOC2007/Data/';
 opts.detrespath='/home/fahad/Datasets/Pascal_2007_original/VOCdevkit/VOC2007//%s_det_val2_%s.txt';
 opts.dettemprespath='/home/fahad/Datasets/Pascal_2007_original/VOCdevkit/VOC2007/Results_ESS/';               
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% image_sizes=getfield(load(sprintf('%s/image_sizes.mat',opts.bbpath)),'image_sizes');      % load image_size
image_size=getfield(load('/home/fahad/Datasets/Pascal_2007_original/VOCdevkit/VOC2007/Labels/image_size'),'image_size');
fid=fopen(sprintf(opts.detrespath, 'comp3',classification_opts.cls_name),'w');

for ii=1:length(labels)  %%% when using val as test set for VOC 2007, there are 5011 images
    if(testset(ii)==1)
        ii
            imt=sprintf('%s/%s',opts.imgpath,image_names{ii});
            imi=imread(imt);
            [h w nchan]=size(imi);
            img_width=w-1;
            img_height=h-1;
            img_name1=image_names{ii};
            img_name=img_name1(1:end-4);
            index=imt(1:end-4);
%             img_size=image_size{ii};
%             img_width=img_size(2)-1;
%             img_height=img_size(1)-1;
           
            %%%%%%%%%%%%%% Main Line for running ESS %%%%%%%%%%%%%%%%%%
            system(sprintf('numlevels=%d maxresults=%d /home/fahad/Matlab_code/ESS-1_2/ess %d %d %s%s %s/%s//%s%s >> %sresults%s',settings.levels, settings.number_det_test, img_width, img_height, opts.data_globalpath, 'w.weight', opts.clstfolder,img_name, clst_name, '.clst',opts.resultfolder,img_name));
%             system(sprintf('numlevels=%d maxresults=%d /home/fahad/Matlab_code/ESS-1_2/ess %d %d %s%s %s//%s%s >> %sresults%d',settings.levels, settings.number_det_test, image_sizes(index,2)-1, image_sizes(index,1)-1, opts.resultfolder, 'w.weight', opts.clstfolder, ids{ii}, '.clst',opts.resultfolder,index));

            % read the results file from the './ess' execution and store the informations
            clear score; clear x1; clear y1; clear x2; clear y2;
            [score, x1, y1, x2, y2]=textread(sprintf('%s%s%s',opts.dettemprespath, 'results',img_name), '%f %d %d %d %d');

            for jj=1:settings.number_det_test              
                x1(jj)=round((x1(jj)+1));       % do we need to round the values  ?
                y1(jj)=round((y1(jj)+1));
                x2(jj)=round((x2(jj)+1));
                y2(jj)=round((y2(jj)+1));

                % store the informations in the general results file
                fprintf(fid,'%s %f %d %d %d %d\n', img_name, score(jj), x1(jj), y1(jj), x2(jj), y2(jj));
                fprintf(' IMAGE NUMBER: %s      SCORE: %f       X1: %f   Y1: %f   X2: %f   y2: %f \n', img_name, score(jj), x1(jj), y1(jj), x2(jj), y2(jj));        
            end


             system(sprintf('rm %sresults%s', opts.resultfolder,img_name));
     end
end
fclose(fid);
display('Detection is completed:');
pause
