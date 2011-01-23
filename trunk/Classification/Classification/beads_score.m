fid=fopen('multiclass_database.txt');


marble_scor=zeros([1 280]);

while 1
imagename= fgetl(fid);
if ~ischar(imagename),break,end
fresultnames(j)={imagename};
j=j+1;
end

for tel1=81:120
query_hist=all_hist(:,tel1);
f=distance1(query_hist,all_hist);
[sortedValues,index]=sort(f);

for i=1:10
%     imagename=char(fresultnames(index(i)));
%     x=imread(imagename);
    marble_scor(index(i))=marble_scor(index(i))+1;   %+120-i;
%     disp(sortedValues(i));
end
end
disp('Beads score found');
[sortval,indx]=sort(marble_scor,'descend');
for kk = 1:280       
    imagename = char(fresultnames(indx(kk)));
    
%     x = imread(imagename);
    
%     subplot(3,5,i);

%     subimage(x);
    
%     xlabel(imagename);
    disp(imagename);
    disp(sortval(kk));
    disp('  ');
  
end

for jj=1:12
for gg = 1:20        % Store top 5 matches...
    imagename = char(fresultnames(indx(gg+(jj-1)*20)));
    
    x = imread(imagename);
    
    subplot(4,5,gg);
     subimage(x);
%     imagesc(sum(x,3)/3);
    colormap gray ;
    
    xlabel(imagename);
    title(sprintf('%1.1f',sortval(gg+(jj-1)*20)));
%     disp(imagename);
%     disp(sortedValues(i));
%     disp('  ');

  
end
pause
end
