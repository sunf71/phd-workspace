function [ridgesFound,creasened,disSmooth]=maxCross(h3,deriva,integra,thr)
% h3=peaks;
mida=length(h3(:,1));
imPerPintar=h3;
mcc1Mod=zeros(mida+4,mida+4);
mcc1Mod(3:mida+2,3:mida+2)=imPerPintar(:,:);
% creasened=double(crestesVell(mcc1Mod,deriva,integra,thr)); %params -> distribucio derivació(4) integra(1.5) thr(0)
[creasened,disSmooth]=crestes(mcc1Mod,deriva,integra,thr); %params -> distribucio derivació(4) integra(1.5) thr(0)


creasened=-creasened;
creasened(mcc1Mod==0)=0; 



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%  TAKES POSITIVE CREASENESS VALUES %%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
imNormalized=creasened(3:mida+2,3:mida+2);
imPositiveBin=imNormalized>0.3+eps;
imPositiveBin=imNormalized.*imPositiveBin;
im3=zeros(mida+4,mida+4);
im3(3:mida+2,3:mida+2)=imPositiveBin;
dstVals=zeros(mida+4,mida+4);
maxims=zeros(mida+4,mida+4);
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
            maxims(i,j)=1;
            im33=im3;
            im33(i-1:i+1,j-1:j+1)=0;
            for i2=i-2:i+2
            for j2=j-2:j+2
                if i2>2 && j2>2 && i2<mida && j2<mida
            if ((sum(sum(im33(i2-1:i2+1,j2-1:j2+1)>im33(i2,j2)))==0) && (im33(i2,j2)>0))
                dstVals(i2,j2)=2;
            end
                end
            end
            end            
        end
    end
end
end
dstVals2=dstVals;
%ARA JA TENIM ELS MAXIMS LOCALS I CAP A ON VAN LES CRESTES
% im3=creasened;
labe=0;
im3cp=im3.*creua;
for i=3:mida+2
for j=3:mida+2
if dstVals2(i,j)==2 %ham d'anar amunt i avall

    dstVals2(i,j)=0; %en comptes de fer aixo cada vegada, n'hi ha prou en no fer res si dstVals té algun valor de labe en i,j
    im3=im3cp;

    %%%%%%%%%%%%% AMUNT %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    labe=labe+1000;
    [dstVals,dstVals2,im3]=followRidge(dstVals,dstVals2,im3,labe,i,j);

    %%%%%%%%%%%%% AVALL %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    labe=labe+1000;
    im32=im3cp;
    newi=i;
    newj=j;

    %ara el que hem de fer es simular que veniem des de l'altre costat (setntit max local) per a poder continuar la cresta desde l'altre costat.
    [ciTmp cjTmp]=ind2sub([3 3],find(dstVals(newi-1:newi+1,newj-1:newj+1)>2));
    veinsTmp=im32(newi-1:newi+1,newj-1:newj+1);
    if ~isempty(ciTmp)
    if ciTmp(1)~=2 && cjTmp(1)~=2 %distancia 2
        veinsTmp(ciTmp,cjTmp)=0;
        veinsTmp(2,cjTmp)=0;
        veinsTmp(ciTmp,2)=0;
    elseif ciTmp~=2
        veinsTmp(ciTmp,:)=0;
    elseif cjTmp~=2
        veinsTmp(1:3,cjTmp)=0;
    end
    end
    %%%%% FINS AQUI PER A SIMULAR EL QUE ESTAVEM FENT
     im3(newi-1:newi+1,newj-1:newj+1)=veinsTmp;
    [dstVals,dstVals2,im3]=followRidge(dstVals,dstVals2,im3,labe,i,j); 
end
end
end
dstValsTmp=(dstVals>0);
dstValsTmp(maxims>0)=10002;
ridgesFound=dstValsTmp(3:mida+2,3:mida+2);
function [dstVals,dstVals2,im3]=followRidge(dstVals,dstVals2,im3,labe,i,j)
newi=i;
newj=j;
final=0;
while ~final
im3(newi,newj)=0; %delete current creaseness value 
veins=im3(newi-1:newi+1,newj-1:newj+1);
veins2=dstVals(newi-2:newi+2,newj-2:newj+2);
if (labe-min(veins2(veins2>0))>9)&& (labe-min(veins2(veins2>0))<994)
    final=1;
else
    [ci cj]=ind2sub([3 3],find(veins==max(veins(:))));
    if length(ci)==1
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
        newi=newi+(ci-2);
        newj=newj+(cj-2);
        if dstVals(newi,newj)>999
            final=1;
        else
            dstVals(newi,newj)=labe;
            dstVals2(newi,newj)=0;
            labe=labe+1;
        end
    else
        final=1;
    end
end
end

