function [imRes, thinRidge, creasened, distribucio]=RAD(differentiation,integration,thr,sizeDis,filesearchdir,super)

% [imRes]=RAD(1.5,0.01,5,80,OriginalImage,oversegmentation');
% INPUT: segmenta(integration,differentiation,thr,sizeDist,imatge)
% 
%   -> differentiation: size of the objects whose orientation has to be
%                      determined.
%   -> integration: size of the neighbourhood in which orientation is 
%                    dominant.
%   -> thr: confidence measure. Reduce creaseness in the structures we are
%           not interested in.
%   -> sizeDist: \bins of the histogram. Recommended 80, 125.
%   -> im = Original image
%   -> super: if 1, it yields an oversegmntation
% 
% 
% OUTPUT: [imRes]
% 
%  ->  imRes: segmented image.
%
% 

filelist=dir(filesearchdir);

for x=1:length(filelist)

    if (filelist(x).isdir==0) %make sure its not a dir

        %here you would do whatever you wanted with filelist(x)
        im=imread(fullfile(filesearchdir,filelist(x).name));
        im=uint8(double(im).*repmat(cat(3,0.9,0.6, 0.75),size(im,1),size(im,2)));
        
        figure,imshow(im)

        im2=gammaCorrect(im);
        im=uint8(im2.*255);

        H = fspecial('gaussian');
        im=imfilter(im,H);

        %Image's histogram
          distribucio=histnd(reshape(double(im),[],3),repmat([0:255/sizeDis:255-1]',1,3));
        %Ridge extraction
          [creasened3,ridgesFound,disSmooth3]=ERidgeNDv2(distribucio,differentiation,integration,thr);
          creasened=creasened3(2:(length(creasened3)-1),2:(length(creasened3)-1),2:(length(creasened3)-1));
          disSmooth=disSmooth3(2:(length(creasened3)-1),2:(length(creasened3)-1),2:(length(creasened3)-1));


        if super==1 %oversegmentation
            [thinRidge]=thinAndLabelRidge(ridgesFound,creasened,disSmooth);
            thinRidge(thinRidge==10004)=0; 
        else
            thinRidge=ridgesFound;
        end

        %from histgram's clusters to image segmentation
        [imRes]=superPixelPostClassDom(creasened,thinRidge,im,distribucio,1);
        
        figure,imshow(uint8(imRes))
%         figure,imagesc(double(disSmooth))
%         figure,surf(flipud(double(disSmooth)),'edgecolor','none')
        figure,pinta(ridgesFound)
        
        pause
        close all
    end
end;

function out=gammaCorrect(in)
a=0.055;
in=double(in)/255;
ind=in>0.03928;
out=in/12.92;
out(ind)=((in(ind)+a)/(1+a)).^2.4;
