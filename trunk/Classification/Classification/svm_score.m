% TO CALCULATE THE SVM_SCORE (Classification rate) OF IMAGES (1.00-0.00)

fid=fopen('multiclass10_database.txt');
class_number=7;
total_image=400;

%to get the image names from the text file
while 1
    imagename= fgetl(fid);
    if ~ischar(imagename),break,end
    fresultnames(j)={imagename};
    j=j+1;
end

%frequency of test images (all_hist,class_list coming from exmulticlass2.m)
freq_test=hist(all_list,(1:total_image) );
freq_class=hist(class_list{class_number},(1:total_image));
clas_score=freq_class./(freq_test+eps);

%to get  classification score
[sortval,indx]=sort(clas_score,'descend');

for jj=1:14
  for gg = 1:20        
    imagename = char(fresultnames(indx(gg+(jj-1)*20)));
    x = imread(imagename);
    subplot(4,5,gg);
    subimage(x);
    %     imagesc(sum(x,3)/3);
    colormap gray ;
    xlabel(imagename);
%     title(sprintf('%1.2f',-sortval(gg+(jj-1)*20)));
    title(sprintf('%1.2f',sortval(gg+(jj-1)*20)));  
  end
  pause
end
