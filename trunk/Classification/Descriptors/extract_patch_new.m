function patch_im = extract_patch_new(im,grid_points)
test2=reshape(im,size(im,1)*size(im,2),size(im,3));
index2=sub2ind([size(im,1),size(im,2)],grid_points(:,2),grid_points(:,1));
patch_im=test2(index2,:);




%%%%%%%% Another method 
% test2=reshape(im,size(im,1)*size(im,2),3);
% index=(grid_points(:,1)-1)*size(im,1)+grid_points(:,2);
% patch_im=test2(index,:);


%%%%%%%%%% another method
% pos1=[pos(:,1),pos(:,2),ones(size(pos,1),1),ones(size(pos,1),1)*2,ones(size(pos,1),1)*3];
% redis=sub2ind(size(test),pos1(:,1),pos1(:,2),pos1(:,3));
% greenis=sub2ind(size(test),pos1(:,1),pos1(:,2),pos1(:,4));
% bluis=sub2ind(size(test),pos1(:,1),pos1(:,2),pos1(:,5));
% tot=[test(redis),test(greenis),test(bluis)];


%%%%%%%%%%Another method
% for i=1:size(pos)
% redis=sub2ind(size(test),pos(i,1),pos(i,2),1);
% greenis=sub2ind(size(test),pos(i,1),pos(i,2),2);
% bluis=sub2ind(size(test),pos(i,1),pos(i,2),3);
% im_pat=[test(redis),test(greenis),test(bluis)];
% tot=[tot;im_pat];
% end