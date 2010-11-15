function [imRes]=superPixelRADsegmentation(differentiation,integration,thr,sizeDis,im,PostProcFlag,superPixelFlag)

% H = fspecial('gaussian',[15 15]);
% im=imfilter(im,H);

 distribution=histnd(reshape(double(im),[],3),repmat([0:256/sizeDis:256-1]',1,3));

%  [creasened3,ridgesFound,disSmooth3]=superPixelRidges(distribution,differentiation,integration,thr); 
 [creasened3,ridgesFound,disSmooth3]=ERidgeNDv2Antonio(distribution,differentiation,integration,thr);
 
 
 creasened=creasened3(2:(length(creasened3)-1),2:(length(creasened3)-1),2:(length(creasened3)-1));
 disSmooth=disSmooth3(2:(length(creasened3)-1),2:(length(creasened3)-1),2:(length(creasened3)-1));

 [aprimada]=sortRidges(ridgesFound,creasened,disSmooth);
 if (superPixelFlag)
 aprimada(aprimada==10004)=0;  %del minima
 end

%  [imRes]=zonesInf(creasened,aprimada,im,distribucio);
 [imRes,w]=superPixelPostClassDom(creasened,aprimada,im,distribution,PostProcFlag);
 
end