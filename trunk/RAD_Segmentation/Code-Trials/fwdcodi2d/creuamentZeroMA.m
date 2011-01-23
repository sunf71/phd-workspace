% im=imread('../imas/Partha/3.bmp');
% D = bwdist(im);
% D=D.^3;
% % figure, imshow(D,[])
% h3=D;
% h3=peaks;


mida=length(h3(:,1));
imPerPintar=h3;
mcc1Mod=zeros(mida+4,mida+4);
mcc1Mod(3:mida+2,3:mida+2)=imPerPintar(:,:);
creasened=double(crestes(mcc1Mod,4,1.5,1)); %params -> distribucio derivació integra thr  MARCAL:0.2,2,5
creasened=-creasened;
% creasened=imrotate(creasened,90);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%  TAKES POSITIVE CREASENESS VALUES %%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
imNormalized=creasened(3:mida+2,3:mida+2);
imPositiveBin=imNormalized>0.2+eps; %0.2
imPositiveBin=imNormalized.*imPositiveBin;
im3=zeros(mida+4,mida+4);
im3(3:mida+2,3:mida+2)=imPositiveBin;
dstVals=zeros(mida+4,mida+4);

im3cp=im3; %because we delete some values of im3
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%% zero-crossing %%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
creua=zeros(mida+4,mida+4);
for i=3:mida+2 %beginning on coordinate 4th, instead of 3th, we avoid problems with 'ghost' maxima
for j=3:mida+2
    if im3(i,j)>0
        veins=im3(i-1:i+1,j-1:j+1);
        if sum(sum(veins(:)<veins(2,2)))>4
            creua(i,j)=1;
        end
    end
end
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%% FIND LOCAL MAXIMA %%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i=3:mida+2 %beginning on coordinate 4th, instead of 3th, we avoid problems with 'ghost' maxima
for j=3:mida+2
    if im3(i,j)>0
        veins=im3(i-1:i+1,j-1:j+1);
        if sum(sum(veins(:)>veins(2,2)))==0
            dstVals(i,j)=1;
        end
    end
end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%  #RIDGES STARING ON LOCAL MAXIMA?  %%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i=3:mida+2
for j=3:mida+2
if dstVals(i,j)==1
    for i2=i-1:i+1
    for j2=j-1:j+1
    if ((sum(sum(im3(i2-1:i2+1,j2-1:j2+1)>im3(i2,j2)))==1) & (im3(i2,j2)>0))
        dstVals(i2,j2)=2;
    end
    end
    end
end
end
end
dstVals2=dstVals;
im32=im3;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% STARTING ON LOCAL MAXIMA,IT FOLLOWS RIDGE POINTS %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
labe=0;
im3cp=im3.*creua; %es possible que aixo sigui TMP, o no... muhahahahaahahahahahahahahahahahahahahahhaah (TOTS MORTS, HAN DE MORIR)
% delLabe=0;
for i=3:mida+2
for j=3:mida+2
if dstVals2(i,j)>0
    im3=im3cp;
    labe=labe+1000;
%     delLabe=delLabe+1000;
%current search coordinates  
 newi=i;
 newj=j;
 final=0;
 itera=0; %tmp chivato var
  while ~final
%       itera
      itera=itera+1;
    im3(newi,newj)=0; %delete current creaseness value 
    veins=im3(newi-1:newi+1,newj-1:newj+1);
    veinsVals=dstVals(newi-1:newi+1,newj-1:newj+1);
    veins2=dstVals(newi-2:newi+2,newj-2:newj+2);
    if (labe-min(veins2(veins2>0))>9)& (labe-min(veins2(veins2>0))<1000)
        final=1;
    else
        [ci cj]=ind2sub([3 3],find(veins==max(veins(:))));
        if length(ci)==1  & dstVals(ci,cj)<3
%      iniciTmp
                if ((newi+(ci-2))-newi)<0
                im3(newi:newi+1,newj-1:newj+1)=0;
                elseif ((newi+(ci-2))-newi)>0
                    im3(newi-1:newi,newj-1:newj+1)=0;
                end
                if ((newj+(cj-2))-newj)<0
                im3(newi-1:newi+1,newj:newj+1)=0;
                elseif ((newj+(cj-2))-newj)>0
                    im3(newi-1:newi+1,newj-1:newj)=0;
                end
%      FI TMP
%             im3(newi-1:newi+1,newj-1:newj+1)=0; original
            newi=newi+(ci-2);
            newj=newj+(cj-2);
            dstVals(newi,newj)=labe;
            labe=labe+1;
        else
            final=1;
        end
    end
  end
end
end
end

hres=dstVals(3:mida+2,3:mida+2);  %ridges found
etiqueta=bwlabeln(hres>0+eps,26);  %ridges labeled

% hres2=dstVals(3:mida+2,3:mida+2).*creua(3:mida+2,3:mida+2);
% % % % % % %  final struct 
% % [hres.i,hres.j]=ind2sub([mida mida],find(hres>0));
% % inds=sub2ind([mida mida mida],hres.i,hres.j);
% % hres.lab=etiqueta(inds);
% % hres.mid=mida;
% 
% figure, imshow(hres,[])
% figure, imshow(hres2,[])
% 
% 
% edu=zeros(mida+4,mida+4);
% edu(3:mida+2,3:mida+2)=~dstVals(3:mida+2,3:mida+2).*h3;
% figure, imshow(edu,[])