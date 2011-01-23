mida=length(creasened);

%Preparem la distribucio a clusteritzar:
% %     %Amb creasenes capat o sense
%     creasened=disSmooth;       %%%%%% ES LA MILLOR OPCIO DISSMOOTH??????, que me aspen si no.....
%     creasened=creasened-30;
% %     %o amb creasened
    creasened=creasened-0.3;


creasened(creasened<0)=0;
edu=-creasened;
edu=edu(3:mida-2,3:mida-2);
    % O (XOR) VORONOI
% edu=zeros(mida-4,mida-4); % EL PUTU VORONOI NEN!!!

%Marquem i inundem
edu(aprimada>0)=-Inf;
w=watershed(edu);


%aquesta linia fa que peti l'arxiu, pero es util per proves (elimina zones sense representant
% kk=bwlabel(aprimada);kkCosa=max(kk(:));w(w>kkCosa)=0; 
%les seguents 3 fan el Voronoi a partir de les ZIs amb representant
% w2=w;
% w2(w2~=0)=-Inf;
% w3=watershed(w2);


% TANCAMENT INDEXS I PARANOIES MIL
se = strel('disk',2);
w=imclose(w,se);

% figure, imshow(w,[])
% wTmpPerMostrar=w;
% wTmpPerMostrar(aprimada>0)=20;
% figure, imshow(wTmpPerMostrar,[]);

% ind=reshape(floor(double(im)/(255.5/(mida-4)))+1,[],2);
ind=reshape(ceil(double(im)/(255.5/(mida-4))),[],2);
ind(ind==0)=1;

s = regionprops(w, 'PixelIdxList'); 



m=zeros(max(w(:)),2);
for i=1:max(w(:))
	[r,g]=ind2sub(size(w),s(i).PixelIdxList);
    rm=mean(r);
    gm=mean(g);
	m(i,:)=[rm gm];
end
reg=w(sub2ind(size(w),ind(:,1),ind(:,2)));
imRes=reshape(m(reg,:),size(im,1),[],2)*(255/(mida-4));
% toc
seg=reshape(reg,size(im,1),[]);
% pla3=(imRes(:,:,1)+imRes(:,:,2))/2;
imRes2=cat(3,imRes(:,:,1),imRes(:,:,2),imRes(:,:,1));
figure, imshow(uint8(imRes2))





% figure
% iptsetpref('ImshowBorder','tight') 
% hold on
% subplot(2,2,1); imshow(uint8(imRes2),[])
% subplot(2,2,2); imshow(uint8(imRes2(:,:,1)))
% subplot(2,2,3); imshow(uint8(imRes2(:,:,2)),[])
% subplot(2,2,4); imshow(uint8(imRes2(:,:,3)),[])
% hold off

