function [imRes,creasened,aprimada,w,distribucio]=RAD(differentiation,integration,thr,sizeDis,im,segmentBool)

% [creasened,aprimada,imRes,im,w,distribucio]=segmenta(1.5,1,5,50,im,1);
% INPUT: segmenta(integration,differentiation,thr,sizeDist,imatge)
% 
%   -> differentiation: size of the objects whose orientation has to be determined.
%   -> integration: size of the neighbourhood in which orientation is dominant.
%   -> thr: confidence measure. Reduce creaseness in the structures we are
%           not interested in.
%   -> sizeDist: size of histogram.
%   -> im: image to be segmented
% 
% 
% OUTPUT: [hres,creasened,etiqueta,dstVals]
% 
%  -> creasened: creaseness values of original distribution in an
%                sizeDis x sizeDis x sizeDis  cube.
%  -> aprimada: ridges found
%  ->  imRes: segmented image.
 
%im2=srgb2rgb(im);
%im=uint8(im2.*255);
if ischar(im)
    fprintf(1,im);
    im=imread(im);
end

distribucio=histnd(reshape(double(im),[],3),repmat([0:256./sizeDis:256-1]',1,3));
[creasened3,ridgesFound,disSmooth3]=ERidgeNDv2(distribucio,differentiation,integration,thr);
creasened=creasened3(2:(length(creasened3)-1),2:(length(creasened3)-1),2:(length(creasened3)-1));
disSmooth=disSmooth3(2:(length(creasened3)-1),2:(length(creasened3)-1),2:(length(creasened3)-1));

[aprimada]=sortChulu(ridgesFound,creasened,disSmooth);


if segmentBool
    if max(max(max(bwlabeln(aprimada))))<2
        [imRes,w]=zonesInf(creasened,aprimada,im,distribucio);
    else
        [imRes,w]=postClassDominants(creasened,aprimada,im,distribucio);
    end
else
    imRes=0;
    w=0;
end

function [CRETMP,Ridges,disSmooth]=ERidgeNDv2(distribution,differentiation,integration,thr)



border_size=3;
sigma_diff=differentiation;%2.5;
sigma_inte=integration;%0.5;
creaseness_threshold=thr;%5;
minum_creaseness_value=0.5;

mida=size(distribution);
% 
% creasened=-double(crestesLast(padarray(distribution,ones(1,ndims(distribution))*border_size), ...
%                           sigma_diff, sigma_inte, creaseness_threshold)); 
%                       
  %%%% WINDOWS
[creasened,disSmooth]=crestes(padarray(distribution,ones(1,ndims(distribution))*border_size), ...
                          sigma_diff, sigma_inte, creaseness_threshold);                       
                      
  %%%% LINUX
% [creasened,disSmooth]=crestes(padarray(distribution,ones(1,ndims(distribution))*border_size), ...
%                           sigma_diff, sigma_inte, creaseness_threshold);                                             
                      
creasened=-double(creasened);
CRETMP=creasened;

idx=arrayfun(@(x)(border_size+(1:x)),mida,'UniformOutput', false);
creasened=creasened(idx{:});

imPositiveBin=creasened;
imPositiveBin(imPositiveBin<minum_creaseness_value)=0; 

im3=padarray(imPositiveBin,ones(1,ndims(imPositiveBin))*border_size);
Ridges=zeros(mida+border_size*2);

indexTable=HalfNeigbourhood(ndims(distribution));
indexTable=NeighbourhoodIndexes(size(im3), indexTable);

indexNeigb2=Neigbourhood(ndims(distribution),2);
indexNeigb2=NeighbourhoodIndexes(size(im3), indexNeigb2);


indexNeigb1=Neigbourhood(ndims(distribution),1,1);
indexNeigb1=NeighbourhoodIndexes(size(im3), indexNeigb1);
% indexNeigb1=indexNeigb1(indexNeigb1~=0);

i=find(im3>0); %ja considerem nomes els punts <0!!!!!!!!!
%inicialitzem el vector en el que hi guardem els punts que anem afegint a
%la cresta i/o que cal visitar   -->    visitar=[];
visitar=[];  
imTmp=zeros(mida+border_size*2);
im3cp=im3;
Marcador=false(size(im3));
Marcador(i)=true;
ii=zeros(size(i));
for x=indexNeigb1(:)'
    ii=ii+(im3cp(i+x)>im3cp(i));
end
i=i(ii==0);
for coun=1:length(i)
        %la seguent condicio s'haura de adaptar per a que no repetim la
        %feina feta. MOLT IMPORTANT, DIRIA QUE HEM DE MIRAR QUE EN IM3 NO
        %VALGUI ZERO, JA QUE AIXO DE MIRAR-HO A IM3CP ES COSA DE UNA
        %PRIMERA IDEA QUE ARA AL AJUNTAR JA NO ES COMPLEIX.
%         im3=im3cp;
        %veins=im3cp(i(coun)+indexNeigb1); %FIXEM-NOS QUE ES IM3CP no IM3, ja que busquem maxims en imatge original!!
        %if sum(im3cp(i(coun)+indexNeigb1)>im3cp(i(coun)))==0   %M�xim Local AND ara no valgui zero(aixo es possible ja que anem eliminant valors de im3 en temps d'execuci�)
            Ridges(i(coun))=1;          %el posem 
            visitar=[visitar; i(coun)]; %recordem que hem de visitar-lo per les d=2 AUESTA LINIA DIRIA QUE NO PUTU CAL.
%            im3cp(i(coun)) = -im3(i(coun));
            Marcador(i(coun)) = false;
            %%%%%%%%%%%%%%%%
            %el while aquest anira seguint tota la cresta a partir de un
            %maxim local, tot afegint a 'visitar' els nous punts de cresta
            %%%%%%%%%%%%%%%%
            %disp('************')
            while ~isempty(visitar) %anem seguiint la cresta fins al final.
                iAct=visitar(1);  %cordenada i en la que anem ara 
                im3(iAct+indexNeigb1)=0;
                ind=iAct+indexNeigb2;
                ind=ind(im3(ind)>0);
                ind=ind(Marcador(ind));
                imTmp(ind)= im3(ind);
                Marcador(ind) = false;
                for i2=ind(:)'
                    if sum(imTmp(i2+indexNeigb1)>imTmp(i2))==0
                        if any((im3cp(i2+indexTable)<im3cp(i2)) & (im3cp(i2-indexTable)<im3cp(i2))) %si es un creaument per zero
                            Tmp=intersect(iAct+indexNeigb1,i2+indexNeigb1);
                            [mx, mxI]=max(im3cp(Tmp));
                            Ridges(i2)=2;
                            if mx>0
                                visitar=[visitar;i2];
%                                 Ridges(i2)=2;
                                Ridges(Tmp(mxI))=3;
                            end
                            %max(imTmp(:))
                        end
                    end
                end
                imTmp(ind)= 0;
                visitar=visitar(2:end); %la nova llista sera la cua de la llista
            end
end

Ridges=Ridges(idx{:});


function HN=HalfNeigbourhood(n)

if n==1 
    HN=1;
else
    HN=HalfNeigbourhood(n-1);
    HN=[[HN ones(size(HN,1),1)]; [HN zeros(size(HN,1),1)]; [HN -ones(size(HN,1),1)]];
    HN=[HN; [zeros(1,size(HN,2)-1) 1]];
end

function N=Neigbourhood(dimension,distance,value)
if nargin==2
    value=0;
end

N=padarray(zeros(ones(1,dimension)*(distance*2+1-2))+value,ones(1,dimension),1);
b=struct('i',cell(1,ndims(N)));
[b.i]=ind2sub(size(N),find(N));
b=[b.i];
N=b-repmat(ceil(max(b)/2),size(b,1),1);

function neig=NeighbourhoodIndexes(distrib_size, positions)
    sz=cumprod(distrib_size);sz=[1 sz(1:end-1)];
    neig=sum(repmat(sz,size(positions,1),1).*positions,2);


function [aprimada]=sortChulu(ima,creasened,disSmooth)

% % % % % % % % % % % % % % % % % % % % % % % % % % %
% % %
% % %   AGAFA UNA IMATGE, LA PASSA A C26 APRIMANT-LA
% % %   MARCA ELS ENDPOINTS A 10000
% % %   MARCA LES INTERSECCIONS A 10001
% % %   MARCA ELS MAXIMS A 10002
% % %   MARCA ELS MINIMS A 10003
% % % 
% % % % % % % % % % % % % % % % % % % % % % % % % % % 

mida=length(ima);
aprimada=zeros(mida+4,mida+4,mida+4);
aprimada(3:mida+2,3:mida+2,3:mida+2)=ima;
[ci cj ck]=ind2sub(size(aprimada),find((aprimada>0)));

for i=1:numel(ci)
    v1=aprimada(ci(i)-1:ci(i)+1,cj(i)-1:cj(i)+1,ck(i)-1:ck(i)+1);
    if sum(v1(:)>0)>1%si no es un maxim aillat
    v1(2,2,2)=0;
    v1Lab=bwlabeln(v1,26);
    v2=aprimada(ci(i)-2:ci(i)+2,cj(i)-2:cj(i)+2,ck(i)-2:ck(i)+2);
    v2Lab=bwlabeln(v2,26);
    if max(v1Lab(:))==1                             %	No ha tencat connectivitat. Eliminem a no ser que sigui EP.
        v2Lab(v2Lab~=v2Lab(3,3,3))=0;               %   Eliminaem crestes alienes.
        v2Lab(2:4,2:4,2:4)=0;                       %   V1=0
        v2Lab2=bwlabeln(v2Lab,26);
        if (max(v2Lab2(:))==1) && (max(v1(:))<10000)%	EP
            aprimada(ci(i),cj(i),ck(i))=10000; 
        elseif aprimada(ci(i),cj(i),ck(i))~=10002         %	eliminable a no ser que sigui un maxim
            aprimada(ci(i),cj(i),ck(i))=0;
        end
    end  
    end
end

creSave=creasened;
% creSave=-disSmooth; o disSmooth?????????

[ci cj ck]=ind2sub(size(aprimada),find((aprimada>0)));
creasened=creasened.*(aprimada>0);
for i=1:numel(ci)
    v1=aprimada(ci(i)-1:ci(i)+1,cj(i)-1:cj(i)+1,ck(i)-1:ck(i)+1);
    v1Crea=creasened(ci(i)-1:ci(i)+1,cj(i)-1:cj(i)+1,ck(i)-1:ck(i)+1);
    v1(2,2,2)=0;
    if (sum(v1(:)>0)>2) && sum(sum(sum(v1==10001)))<2
        aprimada(ci(i),cj(i),ck(i))=10001; %X
    elseif sum(v1Crea(v1Crea>0)<v1Crea(2,2,2))==2
        aprimada(ci(i),cj(i),ck(i))=10002; %Max
    elseif sum(v1Crea(v1Crea>0)>v1Crea(2,2,2))==2
        aprimada(ci(i),cj(i),ck(i))=10003; %Min
    end
    
    %detectem zones planes per si volem eliminar mes
    if (sum(sum(sum(creSave(ci(i)-1:ci(i)+1,cj(i)-1:cj(i)+1,ck(i)-1:ck(i)+1)>creSave(ci(i),cj(i),ck(i)))))>4) 
        aprimada(ci(i),cj(i),ck(i))=10004;
    end
        
    
end
aprimada=aprimada(3:mida+2,3:mida+2,3:mida+2);


function [imRes,w]=postClassDominants(creOrig,etiqueta,im,distribucio)

%segmentacio final assignant els pixels no classificats de manera
%IMAGE-BASED


mida=(length(etiqueta));
crea=-creOrig(3:mida+2,3:mida+2,3:mida+2);
et=etiqueta;
crea(et~=0)=-Inf;
w=watershed(crea);
%arribats a aquest punt, fariem un imclose, pero passem
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
imResIni=imRes;
% figure, imshow(uint8(imRes));

%ara reassignem els pixels no assignats
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

function [imRes,w]=zonesInf(creasened,etiqueta,im,distribucio)

%exemples crida:
% [imRes]=zonesInf(imSmooth,aprimada,im,distribucio);
% [imRes]=zonesInf(creasened,aprimada,im,distribucio);

mida=(length(etiqueta));
labels=bwlabeln(etiqueta,26);
numRidges=max(labels(:));

% crea=zeros(mida,mida,mida); %%VORONOI
crea=creasened(3:mida+2,3:mida+2,3:mida+2);
crea=crea-0.3;
crea(crea<0)=0;
crea=-crea;


et=etiqueta;
crea(et~=0)=-Inf;

w=watershed(crea);

w(w>numRidges)=0; %Aquest tros de mala puta es folla les que no tenen representant



%les seguents linies tornen a fer un watershed per a evitar que apareixin
% punts sense classificar
w(w~=0)=-Inf;
w=watershed(w);


w=imclose(w,ones(3,3,3));


ind=reshape(floor(double(im)/(255.5/mida))+1,[],3);

s = regionprops(w, 'PixelIdxList'); 
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
