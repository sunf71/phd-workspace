function [CRETMP,Ridges,disSmooth]=ERidgeNDv2(distribution,differentiation,integration,thr)



border_size=3;
sigma_diff=differentiation;%2.5;
sigma_inte=integration;%0.5;
creaseness_threshold=thr;%5;
minum_creaseness_value=0.3;

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


% if 0
% 
%         
% a=zeros(30,25,10);
% veins=NeighbourhoodIndexes(size(a), Neigbourhood(ndims(a),2));
% 
% a(22,15,7)=1;
% ind=find(a>0);
% a(22,15,7)=0;
% 
% 
% a(23,16,8)=1;
% a(23,15,8)=2;
% a(23,14,8)=3;
% a(22,16,8)=4;
% 
% a(23,16,7)=5;
% a(23,15,7)=6;
% a(23,14,7)=7;
% a(22,16,7)=8;
% 
% a(23,16,6)=9;
% a(23,15,6)=10;
% a(23,14,6)=11;
% a(22,16,6)=12;
% 
% a(22,15,8)=13;
% 
% a(ind+veins);
% 
% 
% end
% creas=creasened3(2:85,2:85,2:85);
% [imRes,w]=zonesInf(creas,Ridges,im,distribucio);
