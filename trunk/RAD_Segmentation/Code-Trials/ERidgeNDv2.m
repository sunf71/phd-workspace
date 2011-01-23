function [creasenedSaved,Ridges,disSmooth]=ERidgeNDv2(distribution,sigma_diff,sigma_inte,c_value)

border_size = 3;
minum_creaseness_value = 0.3;

mida = size(distribution);

%creaseness operator for 2D, e.g., RG/BY or nRGB, and 3D RGB space)
%   [creasened,disSmooth] = crestesLast(padarray(distribution,ones(1,ndims(distribution))*border_size), ...
%                           sigma_diff, sigma_inte, c_value);                       

%LINUX
  [creasened,disSmooth] = crestesLast(padarray(distribution,ones(1,ndims(distribution))*border_size), ...
                          sigma_diff, sigma_inte, c_value);
                      
  creasened = -double(creasened);
  creasenedSaved = creasened;

  idx = arrayfun(@(x)(border_size+(1:x)),mida,'UniformOutput', false);
  creasened = creasened(idx{:});

  imPositiveBin = creasened;
  imPositiveBin(imPositiveBin<minum_creaseness_value) = 0; 

  im3 = padarray(imPositiveBin,ones(1,ndims(imPositiveBin))*border_size);
  Ridges = zeros(mida+border_size*2);

  indexTable = HalfNeigbourhood(ndims(distribution));
  indexTable = NeighbourhoodIndexes(size(im3), indexTable);

  indexNeigb2 = Neigbourhood(ndims(distribution),2);
  indexNeigb2 = NeighbourhoodIndexes(size(im3), indexNeigb2);

  indexNeigb1 = Neigbourhood(ndims(distribution),1,1);
  indexNeigb1 = NeighbourhoodIndexes(size(im3), indexNeigb1);

%do not look for creaness values = 0
  i=find(im3>0); 

%inicialization of the vector where we will add all ridges points as well
%as those points whoch will be visited.
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
    Ridges(i(coun))=1;          %add as a ridge point
    visitar=[visitar; i(coun)]; 

    Marcador(i(coun)) = false;
    
    %let's follow the ridge
    while ~isempty(visitar) %anem seguiint la cresta fins al final.
        iAct=visitar(1);  %
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
                        Ridges(Tmp(mxI))=3;
                    end

                end
            end
        end
        imTmp(ind)= 0;
        visitar=visitar(2:end);
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

