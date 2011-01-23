function [imRes,w]=postClassDominants(creOrig,etiqueta,im,distribucio,PostProcFlag)

%segmentacio final assignant els pixels no classificats de manera
%IMAGE-BASED


mida=(length(etiqueta));
crea=-creOrig(3:mida+2,3:mida+2,3:mida+2);
et=etiqueta;
crea(et~=0)=-Inf;
w=watershed(crea);
%arribats a aquest punt, fariem un imclose, pero passem
        se=[0 1 0; 1 1 1; 0 1 0];
        w=imclose(w,se);

ind=reshape(ceil(double(im)/(255/mida)),[],3); %de 255 a 'mida'
ind(ind==0)=1;
etBool=etiqueta>0;
for coun=1:max(w(:))
    zonax=w==coun;
    andRes=etBool & zonax;
%     figure, pinEt(double(edu))
%     sumIni=sum(zonax(:));
%     zonax(etInds)=0;
    if sum(andRes(:))==0 %no te representant
        w(w==coun)=0; %si no te representant, ho posem a zero
    end
end

s = regionprops(w, 'PixelIdxList'); %agafem els indexs per a cada valor diferent
m=[0 0 0];
for i=1:max(w(:))
    wTmp=w;
    wTmp(wTmp~=i)=0;
    wTmp=wTmp.*distribucio;
    occurs=wTmp(s(i).PixelIdxList);
  	[r,g,b]=ind2sub(size(w),s(i).PixelIdxList);
    r=r.*occurs;
    g=g.*occurs;
    b=b.*occurs;
    total=sum(occurs);
	m=[m;[sum(r)/total sum(g)/total sum(b)/total]];
end
reg=w(sub2ind(size(w),ind(:,1),ind(:,2),ind(:,3)));
imRes=reshape(m(reg+1,:),size(im,1),[],3)*(255/mida); 

if PostProcFlag
  imLab=labelIsolatedSegments(floor(imRes(:,:,1)));
    for i=1:max(imLab(:))
      if sum(sum(imLab==i))<6
      imLab(imLab==i)=0;
      end
    end
  imLabBin=imLab>0;
  imRes=imRes.*(cat(3,imLabBin,imLabBin,imLabBin));
end


%ara reassignem els pixels no assignats
imResIni=imRes;
im=uint8(im);
imRes=uint8(imRes);
midaIm=size(im);
%afegim marge
imAux=zeros(midaIm(1)+4,midaIm(2)+4,3);
imAux(3:midaIm(1)+2,3:midaIm(2)+2,:)=im;
imResAux=zeros(midaIm(1)+4,midaIm(2)+4,3);
imResAux(3:midaIm(1)+2,3:midaIm(2)+2,:)=imRes;
noi=[0 0];
while length(noi)>0
    [noi noj]=ind2sub([midaIm(1) midaIm(2)],find(imRes(:,:,1)==0));  %QUE PASARA AMB EL NEGRE SI RELAMENT EXISTEIIIIX!!!!
    noi=noi+2;
    noj=noj+2;    
for i=1:size(noi)
    pIm=imAux(noi(i),noj(i),:); %valor del pixel en imatge original
    winIm=imAux(noi(i)-1:noi(i)+1,noj(i)-1:noj(i)+1,:);
    winRes=imResAux(noi(i)-1:noi(i)+1,noj(i)-1:noj(i)+1,:);
    if max(winRes(:))>0
    mask=winRes(:,:,1)==0; %per a no tindre en compte distancies a enlloc
    %ara calcularem la distancia euclidea entre el pixel de la im original
    %i els RGBs dels colors dominants dels quals es vei el no classificat
    resR=(winIm(:,:,1)-pIm(:,:,1)).^2;
    resG=(winIm(:,:,2)-pIm(:,:,2)).^2;
    resB=(winIm(:,:,3)-pIm(:,:,3)).^2;
    resul=sqrt(resR+resG+resB);
    resul(mask(:,:,1))=Inf;
    %agafem la distancia menor
    [menori menorj]=ind2sub([3 3],find(resul==min(resul(:))));
    %li assignem el pixel
    imResAux(noi(i),noj(i),:)=winRes(menori(1),menorj(1),:);
    end
end

imRes=imResAux(3:midaIm(1)+2,3:midaIm(2)+2,:);

end