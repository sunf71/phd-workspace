function [aprimada]=sortChulu(ima,creasened)

% % % % % % % % % % % % % % % % % % % % % % % % % % %
% % %
% % %   AGAFA UNA IMATGE, LA PASSA A C8 APRIMANT-LA
% % %   MARCA ELS ENDPOINTS A 10000
% % %   MARCA LES INTERSECCIONS A 10001
% % %   MARCA ELS MAXIMS A 10002
% % %   MARCA ELS MINIMS A 10003
% % % 
% % % % % % % % % % % % % % % % % % % % % % % % % % % 

mida=length(ima);
aprimada=zeros(mida+4,mida+4);
aprimada(3:mida+2,3:mida+2)=ima;
[ci cj]=ind2sub(size(aprimada),find((aprimada>0)));

for i=1:numel(ci)
    v1=aprimada(ci(i)-1:ci(i)+1,cj(i)-1:cj(i)+1);
    if sum(v1(:)>0)>1%si no es un maxim aillat
    v1(2,2)=0;
    v1Lab=bwlabeln(v1,8);
    v2=aprimada(ci(i)-2:ci(i)+2,cj(i)-2:cj(i)+2);
    v2Lab=bwlabeln(v2,8);
    if max(v1Lab(:))==1                             %	No ha tencat connectivitat. Eliminem a no ser que sigui EP.
        v2Lab(v2Lab~=v2Lab(3,3))=0;                 %   Eliminaem crestes alienes.
        v2Lab(2:4,2:4)=0;                           %   V1=0
        v2Lab2=bwlabeln(v2Lab,8);
        if (max(v2Lab2(:))==1) && (max(v1(:))<10000)%	EP
            aprimada(ci(i),cj(i))=10000; 
        elseif aprimada(ci(i),cj(i))~=10002         %	eliminable a no ser que sigui un maxim
            aprimada(ci(i),cj(i))=0;
        end
    end  
    end
end
 
creSave=creasened;
%a pels maxs, mins i intersections
[ci cj]=ind2sub(size(aprimada),find((aprimada>0)));
creasened=creasened.*(aprimada>0);
for i=1:numel(ci)
    if aprimada(ci(i),cj(i))<10000
    v1=aprimada(ci(i)-1:ci(i)+1,cj(i)-1:cj(i)+1);
    v1Crea=creasened(ci(i)-1:ci(i)+1,cj(i)-1:cj(i)+1);
    v1(2,2)=0;
    if (sum(v1(:)>0)>2) && sum(sum(sum(v1==10001)))<2
        aprimada(ci(i),cj(i))=10001; %X
    elseif sum(v1Crea(v1Crea>0)<v1Crea(2,2))==2
        aprimada(ci(i),cj(i))=10002; %Max
    elseif sum(v1Crea(v1Crea>0)>v1Crea(2,2))==2
        aprimada(ci(i),cj(i))=10003; %Min
    end
    end
    if (sum(sum(creSave(ci(i)-1:ci(i)+1,cj(i)-1:cj(i)+1)>creSave(ci(i),cj(i))))>3) %poso '<' pq disSmooth me viene del reves
        aprimada(ci(i),cj(i))=10004;
    end
end
aprimada=aprimada(3:mida+2,3:mida+2);
end

