% based on Lowe-code
%
% Color Laplace Feature Detection 
% 
% input:         
%           'image_name' contains image location
%           'image_descriptor_dir' contains location where to save
%           the detector file 'detector_name' and the descriptor files if
%
%           M_boost can be used to transform the image into another
%           colorspace. This is used to perform color boosting.
%           
%           descriptor_flag=1 indicates that immediate descripors should be
%           computed for the patches. Both the descriptor and
%           descriptor file name have to be changed in the code !
%           
%           if grey_flag=1 the intensity image is used for detection
%
% note: the laplace threshold has to be set manually.

function []=DoG_color(image_name,detector_name,image_descriptor_dir,M_boost,descriptor_flag,grey_flag)
image_name
if(nargin<4)
    M_boost=eye(3);
end
if(nargin<5)
    descriptor_flag=1;
end
if(nargin<6)
    grey_flag=0;
end

input_im=(double(imread(image_name)));

if(size(input_im,3)~=3)     % in case the image is grey the R,G,B channel are set equal to the grey image
    input_im2=input_im;
    input_im=zeros(size(input_im,1),size(input_im,2),3);
    input_im(:,:,1)=input_im2;
    input_im(:,:,2)=input_im2;
    input_im(:,:,3)=input_im2;
end

InitSigma=1.6; 
LaplaceThreshold=20;        % 50 is normal %%% i used 20 for texture and soccer datasets for ICCV preparations
Scales=3;
filename=sprintf('%s/%s.txt',image_descriptor_dir,detector_name);        

[O1,O2,O3]=boostM(input_im,M_boost);    

if(grey_flag)
    O1=sum(input_im,3);
    O2=sum(input_im,3);
    O3=sum(input_im,3);
end
start_slice1=gDer(O1,sqrt(InitSigma^2-0.5^2),0,0);   
start_slice2=gDer(O2,sqrt(InitSigma^2-0.5^2),0,0);   
start_slice3=gDer(O3,sqrt(InitSigma^2-0.5^2),0,0);   

BorderDist=16;
minsize=2*BorderDist+2;

[ch,cw]=size(start_slice1);
scale_factor=1;
keycounter=1;
scaled_im=input_im;
patch_counter=0;
while (cw>minsize && ch>minsize),
    [new_x_points,new_y_points,new_s_points,new_max_points, nextO1, nextO2, nextO3, new_ColorFeatures]...
         = OctaveKeypoints(start_slice1,start_slice2,start_slice3,Scales,InitSigma,...
                           LaplaceThreshold,scaled_im,patch_counter,descriptor_flag);
                       
    nop=length(new_x_points);
    x_points(keycounter:keycounter+nop-1)=new_x_points*scale_factor;
    y_points(keycounter:keycounter+nop-1)=new_y_points*scale_factor;
    s_points(keycounter:keycounter+nop-1)=new_s_points*scale_factor;
    max_points(keycounter:keycounter+nop-1)=new_max_points;
    if(nop~=0 & descriptor_flag)
        ColorFeatures(keycounter:keycounter+nop-1,:)=new_ColorFeatures;
    end
    keycounter=keycounter+size(new_x_points,2);
    patch_counter=patch_counter+size(new_x_points,2);
    start_slice1=nextO1;
    start_slice2=nextO2;
    start_slice3=nextO3;
    
    [ch,cw]=size(start_slice1);
    fprintf(1,'inn this round %d features where detected\n',length(new_x_points));
    
    scale_factor=scale_factor*2;
    scaled_im=color_gauss(scaled_im,1,0,0);                                 % smoothing of s=1 is applied before rescaling
    scaled_im=scaled_im(1:2:size(scaled_im,1),1:2:size(scaled_im,2),:);
end
keys=zeros(size(x_points,2),7);
    
keys(:,1)=x_points';
keys(:,2)=y_points';
keys(:,3)=1./((s_points').^2);
keys(:,4)=zeros(size(keys,1),1);
keys(:,5)=1./((s_points').^2);
keys(:,6)=max_points';
keys(:,7)=(1:length(x_points))';


fid=fopen(filename,'w');
if(fid<0) 
    display('cannot find file');
    return;
end
fprintf(fid,'%f\n',2.);
fprintf(fid,'%d\n',size(keys,1));

fprintf(fid,'%f %f %f %f %f %f %d\n',keys');     %laatste is feature descriptor
% for *.mat format saving
%  save_mat
%%%%%%%%%%% for saving 

scaleT=1./sqrt(keys(:,3));
detector_points=[keys(:,1),keys(:,2),scaleT];
save ([image_descriptor_dir,'/',detector_name], 'detector_points');


fclose(fid);


if(descriptor_flag)
    
    new_points=[keys(:,1:5), ColorFeatures];
    save_points(sprintf('%s/CN.txt',image_descriptor_dir),[ new_points(:,1:5) , new_points(:,6:16) ] );
 %   save_points(sprintf('%s/hue6.txt',image_descriptor_dir),[ new_points(:,1:5) , new_points(:,42:77) ] );
 %  save_points(sprintf('%s/hue7.txt',image_descriptor_dir),[ new_points(:,1:5) , new_points(:,78:113) ] );

    %save_points(sprintf('%s/opp6b_m.txt',image_descriptor_dir),[ new_points(:,1:5) , new_points(:,6:41) ] );
    %save_points(sprintf('%s/opp6b_nm.txt',image_descriptor_dir),[ new_points(:,1:5) , new_points(:,42:77) ] );
    %save_points(sprintf('%s/opp7.txt',image_descriptor_dir),[ new_points(:,1:5) , new_points(:,78:113) ] );
end

fprintf(1,'a total of %d features where detected\n',length(x_points));

end

function [x_points,y_points,s_points,max_points, nextO1, nextO2, nextO3, ColorFeatures]...
                    =OctaveKeypoints(startO1,startO2,startO3,Scales,InitSigma,LaplaceThreshold,...
                                    scaled_im,patch_counter,descriptor_flag)
                
    % I use scaled_im because it is less blurred than the blurred images
    % (and is not tranformed by M_boost) 
    % Theorethical foundation missing.
    % the border problem is solved by allowing only patches sigma away from the border.
    
    ColorFeatures=[];
    BorderDist=18;
    hh=size(startO1,1);
    ww=size(startO1,2);
    blur1=zeros(hh,ww,Scales+3);
    blur2=zeros(hh,ww,Scales+3);
    blur3=zeros(hh,ww,Scales+3);
    dogs=zeros(hh,ww,Scales+2);
    
    sigmaRatio=2^(1/Scales);    %scales is choosen at 2
    prevSigma=InitSigma;
    blur1(:,:,1)=startO1;
    blur2(:,:,1)=startO2;
    blur3(:,:,1)=startO3;
       
    for ii=2:(Scales+3)
        increase=prevSigma*sqrt(sigmaRatio^2-1);
        blur1(:,:,ii)=gDer(blur1(:,:,ii-1),increase,0,0);
        blur2(:,:,ii)=gDer(blur2(:,:,ii-1),increase,0,0);
        blur3(:,:,ii)=gDer(blur3(:,:,ii-1),increase,0,0);
        prevSigma=prevSigma*sigmaRatio;
    end
    
    for ii=1:Scales+2
        dogs(:,:,ii)= (  blur3(:,:,ii)-blur3(:,:,ii+1)  ).^2 ...
            + ( (blur1(:,:,ii)-blur1(:,:,ii+1) ).^2 +( blur2(:,:,ii) - blur2(:,:,ii+1) ).^2 ) ;        
    end

    [max1,max2]=max(dogs,[],3);
    
    [yy,xx]=ndgrid(1:hh,1:ww);

    keycounter=1;
  
    for ii=2:(Scales+1)
        % this implementation does not allow multiple maxima on the same position in one octave
        maxima=(max2==ii).*(dilation33(dogs(:,:,ii))==dogs(:,:,ii));
        maxima=set_border(maxima,BorderDist,0);
        maxima=(maxima.*(dogs(:,:,ii)>LaplaceThreshold));
        
        y_max=yy(maxima==1);
        x_max=xx(maxima==1);

        radius=(InitSigma*sigmaRatio^ii+InitSigma*sigmaRatio^(ii+1))/2  * 2 ; % factor two indicates the region which will be extracted is 2 sigma
        
        nom=length(x_max);
        x_points(keycounter:keycounter+nom-1)=x_max;
        y_points(keycounter:keycounter+nom-1)=y_max;
        s_points(keycounter:keycounter+nom-1)=radius;
        max_points(keycounter:keycounter+nom-1)=max1(maxima==1);
        
        radius=floor(radius+0.5);
        radius2=radius+1;               % we get a one pixel bigger image out, but the affine transform is done on the 2*radius image
        patches_R=zeros(400,nom);
        patches_G=zeros(400,nom);
        patches_B=zeros(400,nom);
        local_counter=0;
        if(descriptor_flag)
            for(jj=1:nom)
                patch_counter=patch_counter+1;
                local_counter=local_counter+1;
                % [R,G,B] = O2RGB(blur1(y_max(jj)-radius2:y_max(jj)+radius2,x_max(jj)-radius2:x_max(jj)+radius2,ii-1) ...
                %               ,blur2(y_max(jj)-radius2:y_max(jj)+radius2,x_max(jj)-radius2:x_max(jj)+radius2,ii-1) ...
                %               ,blur3(y_max(jj)-radius2:y_max(jj)+radius2,x_max(jj)-radius2:x_max(jj)+radius2,ii-1) );
                
                R=scaled_im(y_max(jj)-radius2:y_max(jj)+radius2,x_max(jj)-radius2:x_max(jj)+radius2,1);
                G=scaled_im(y_max(jj)-radius2:y_max(jj)+radius2,x_max(jj)-radius2:x_max(jj)+radius2,2);
                B=scaled_im(y_max(jj)-radius2:y_max(jj)+radius2,x_max(jj)-radius2:x_max(jj)+radius2,3);                
                
                patches_R(:,local_counter) = reshape(affineTransform_fast( double(R), 2, 2, size(R,1)-1, 2, 2, size(R,2)-1, 20, 20, 'linear' ),400,1);           
                patches_G(:,local_counter) = reshape(affineTransform_fast( double(G), 2, 2, size(G,1)-1, 2, 2, size(G,2)-1, 20, 20, 'linear' ),400,1);           
                patches_B(:,local_counter) = reshape(affineTransform_fast( double(B), 2, 2, size(B,1)-1, 2, 2, size(B,2)-1, 20, 20, 'linear' ),400,1);           
                
                % put(uint8(make_image(R,G,B)),4);pause;
                % imwrite(uint8(make_image(R,G,B)),sprintf('%s/patch_%s.ppm',image_descriptor_dir,num2string(patch_counter,4)),'ppm');
                % [y_max(jj),x_max(jj),radius]
                % put(uint8(make_image(R,G,B)),3);pause;                
            end
            if(nom>0)
                 %cc_method=1;
                 %[patches_R,patches_G,patches_B]=apply_cc(patches_R,patches_G,patches_B,cc_method);    

                 %compute ColorFeatures
                 %[ColorFeatures2,weights]=spherical_descriptor(patches_R,patches_G,patches_B,37,1,3);
                 %[ColorFeatures2]=hue_luminance_descriptor(patches_R,patches_G,patches_B,15,5);        
                 %ColorFeatures=compute_rgb_descriptor(patches_R,patches_G,patches_B,7)/400;             

                 %[ColorFeatures2]=opponent_descriptor6b(patches_R,patches_G,patches_B,36,3,1);             
                 %[ColorFeatures3]=opponent_descriptor6b(patches_R,patches_G,patches_B,36,3,0);
                 %[ColorFeatures4]=opponent_descriptor7(patches_R,patches_G,patches_B,36,3);

                 %ColorFeatures2=compute_hue_descriptor5(patches_R,patches_G,patches_B,36,3);
                 %ColorFeatures3=compute_hue_descriptor6(patches_R,patches_G,patches_B,36,3);
                 %ColorFeatures4=compute_hue_descriptor7(patches_R,patches_G,patches_B,36,3);
%load('/home/joost/data/topics/wc_robust.mat','wc');                 
%[ColorFeatures2]=color_name_descriptor(patches_R,patches_G,patches_B,wc);

                 %ColorFeatures2=[ColorFeatures2;ColorFeatures3;ColorFeatures4];

                 ColorFeatures2=ColorFeatures2';
                 ColorFeatures(keycounter:keycounter+nom-1,:)=ColorFeatures2;

            end
        end
        keycounter=keycounter+nom;
        
        nextO1=blur1(1:2:hh,1:2:ww,Scales+1);
        nextO2=blur2(1:2:hh,1:2:ww,Scales+1);
        nextO3=blur3(1:2:hh,1:2:ww,Scales+1);
    end
end