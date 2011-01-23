function [svm_score,best_CV]=Do_Classifiy_libSVM_car(opts,classification_opts)

if nargin<2
    classification_opts=[];
end
display('Computing Classification');
if ~isfield(classification_opts,'assignment_name');       classification_opts.assignment_name='Unknown';       end
if ~isfield(classification_opts,'assignment_name2');       classification_opts.assignment_name2='Unknown';     end
if ~isfield(classification_opts,'assignment_name3');       classification_opts.assignment_name3='Unknown';     end
if ~isfield(classification_opts,'num_histogram');         classification_opts.num_histogram='Unknown';         end
% if ~isfield(classification_opts,'kernel_option');         classification_opts.kernel_option='Unknown';       end  
% if ~isfield(classification_opts,'kernel');                classification_opts.kernel='Unknown';              end
if ~isfield(classification_opts,'perclass_images');       classification_opts.perclass_images='Unknown';       end
if ~isfield(classification_opts,'num_train_images');      classification_opts.num_train_images='Unknown';      end


 %%%%%%%%% Load the Dataset Settings %%%%%%%%%%%
 load(opts.trainset)
 load(opts.labels)
 load(opts.testset)
 load(opts.image_names)
%  load(opts.data_locations)
 nclasses=opts.nclasses;
 nimages=opts.nimages;
 
 %%%%%%%%%%%% Load the Histograms %%%%%%%%%%%%%
 histogram=getfield(load([opts.data_assignmentpath,'/',classification_opts.assignment_name]),'All_hist');
 
 histogram_train=histogram(:,trainset>0);
 histogram_test=histogram(:,testset>0);
 
%    [max1,labels_index]=max(labels,[],2);
%   train_truth=labels_index(trainset>0);
%   test_truth=labels_index(testset>0);

train_truth=zeros(1050,1);
train_truth(501:end,:)=1;
test_truth=ones(108,1);

  


 %%%%%%%%%%%%% Do Classification %%%%%%%%%%%%%
   switch (classification_opts.num_histogram)
       case 1
            %%%%%%% Cross Validation %%%%%%%%
                
%              [best_C,best_CV]=Do_CV_libSVM(histogram_train',train_truth);
            best_C=1000;
            %%% uncomment next line for intersection kernel %%%
             [svm_weights,model]=Do_libSVM(histogram_train',histogram_test',train_truth,test_truth,best_C);
             
             display('classification done');
             pause
             
            %% Assigning Weights and using them with detected points
%             [weight_im]=Do_getWeight_image_new(opts,classification_opts,svm_weights);
%              for testing the images
              counter_res=1;
              for iii=1051:nimages
                  histogram_patch_test=getfield(load([data_locations{iii},'/',classification_opts.assignment_name,'_again']),'All_hist');
                  patch_test=getfield(load([data_locations{iii},'/',classification_opts.assignment_name,'_patch1']),'patch');
                  final_test_hist1=histogram_patch_test;
%                   final_test_hist1=final_test_hist{end};
                  labels_T=zeros(size(final_test_hist1,2),1);
                  [exact_values, pwconst_values, pwlinear_values] = fastpredict(labels_T,final_test_hist1', model,'-b 1');
                  max_pred=max(exact_values(:,2));

                  im=imread(sprintf('%s/%s',opts.imgpath,image_names{iii}));imshow(im);hold on
                    max_pred=max(exact_values(:,2));
                   pred_patc_ind=find(exact_values(:,2)==max_pred);
                   
                   %%%% store the results
                   for ijk=1:length(pred_patc_ind)
                   pred_patch_ind1=pred_patc_ind(ijk)
                   get_patch=patch_test{pred_patch_ind1};
                   pt=get_patch(:,:);
                   end
                   pt_format=[round(pt(2)) round(pt(1)) round(pt(3)-pt(1))];
                   store_results{counter_res}=pt_format;
                   counter_res=counter_res+1;
                  
                   
                   
%                   pred_patc_ind=find(exact_values(:,1)>0.9999);
%                   get_patch=patch_test{pred_patc_ind};

%                   for ijk=1:length(pred_patc_ind)
%                       pred_patch_ind1=pred_patc_ind(ijk)
%                       get_patch=patch_test{pred_patch_ind1}
%                       pt=get_patch(:,:)
%                       pt=round(pt);
%                       plot(pt([1 3 3 1 1]),pt([2 2 4 4 2 ]),'Color',[rand(1),rand(1),rand(1)],'linewidth',2);
%                  
%                   end
%                   pause
              end
               %%% write the results %%%%
                    start_val=0;
                    fid=fopen(sprintf('/home/Matlab_code/car_results.txt'),'w');
%                     imgset='val';
%                     [ids,gt]=textread(sprintf(opts.clsimgsetpath,cls,imgset),'%s %d');
                     for jk=1:108
                         start_str=strcat(num2str(start_val),':');
                         read_format=store_results{jk};
                        
                         str_2=strcat('(',num2str(read_format(1)), ',', num2str(read_format(2)),',',num2str(read_format(3)),')');
                          
%                          fprintf(fid,'%s %f\n',ids{jk},prob_class(jk));
%                          fprintf(fid,'%s %f\n',start_str,prob_class(jk));
                           fprintf(fid,'%s %s \n',start_str,str_2);
                           start_val=start_val+1;
                     end
                     fclose(fid);
       case 2   
          
       case 3
              
   end
end