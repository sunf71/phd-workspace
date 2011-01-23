function [out]=DenseOpponentDescriptor(im, number_of_bins, sigma_xy, sigma_z,lambda)

% Computes the opponent descriptor for a set of N image patches. 
% The patches are hard coded to be 20x20 represented by vectors of (400,1). 
% Note that the descriptor is not normalized to one, instead the descriptor is normalized by color+grey derivative energy.
% Performance can differ significantly for different choices of lambda.
%
% patches_R, _G, _B ( each 400 * N ): red, green and blue channel of N input patches (400 *N )
% number of bins                    : number of bins of the descriptor
% smooth_flag                       : amount of smoothing of final histogram
% lambda                            : multiplication factor before combining with SIFT 
%
% out (number_of_bins * N)          : returns N descriptors
%
% LITERATURE :
%
% Joost van de Weijer, Cordelia Schmid
% "Coloring Local Feature Extraction"
% Proc. ECCV2006, Graz, Austria, 2006.
%


if(nargin<5), lambda=1; end
if(nargin<4), sigma_z=1; end
if(nargin<3), sigma_xy=3; end
if(nargin<2), number_of_bins=36; end

sigma_g=1.5;
out=zeros(size(im,1),size(im,2),number_of_bins);
    

[f_O1_x,f_O1_y,f_O2_x,f_O2_y,f_O3_x,f_O3_y] = eeOpponent_der(fill_border(im,floor(3*sigma_g+.5)),sigma_g);
    
    start_wh=floor(3*sigma_g+.5)+1;
    end_h=floor(3*sigma_g+.5)+size(im,1);
    end_w=floor(3*sigma_g+.5)+size(im,2);
	
	f_O1_x=f_O1_x(start_wh:end_h,start_wh:end_w);
	f_O1_y=f_O1_y(start_wh:end_h,start_wh:end_w);
	f_O2_x=f_O2_x(start_wh:end_h,start_wh:end_w);
	f_O2_y=f_O2_y(start_wh:end_h,start_wh:end_w);
	f_O3_x=f_O3_x(start_wh:end_h,start_wh:end_w);
	f_O3_y=f_O3_y(start_wh:end_h,start_wh:end_w);

    f_ang_x = ( f_O1_x.^2+f_O2_x.^2 );
    f_ang_y = ( f_O1_y.^2+f_O2_y.^2 );
    grey_energy=(f_O3_x.^2+f_O3_y.^2);
    
    %x-derivatives
    corner=atan2(f_O1_x,f_O2_x);
    corner=corner+pi.*(corner<0);

    corner=floor(corner/(pi)*(number_of_bins));    
    for jj=0:number_of_bins-1
         out(:,:,jj+1)=f_ang_x.*(corner==jj);
    end
                  
    %y-derivatives
    corner=atan2(f_O1_y,f_O2_y);
    corner=corner+pi.*(corner<0);

    corner=floor(corner/(pi)*(number_of_bins));    

    for jj=0:number_of_bins-1
         out(:,:,jj+1)=out(:,:,jj+1)+f_ang_y.*(corner==jj);
    end
    
    if(sigma_xy>0)
        out=color_gauss(out,sigma_xy,0,0);
        grey_energy=color_gauss(grey_energy,sigma_xy,0,0);
    end
    
    if(sigma_z>0)
        out2=zeros(size(out,1),size(out,2),size(out,3)+floor(sigma_z)*4);
    
        out2(:,:,floor(sigma_z)*2+1:floor(sigma_z)*2+number_of_bins)=out;    
        out2=gDer_z(out2,0,sigma_z,0);
    
        out=out2(:,:,floor(sigma_z)*2+1:floor(sigma_z)*2+number_of_bins);
        out(:,:,1:floor(sigma_z)*2)=out(:,:,1:floor(sigma_z)*2)+out2(:,:,floor(sigma_z)*2+number_of_bins+1:floor(sigma_z)*4+number_of_bins);
        out(:,:,number_of_bins-floor(sigma_z)*2+1:number_of_bins)=    out(:,:,number_of_bins-floor(sigma_z)*2+1:number_of_bins)+out2(:,:,1:floor(sigma_z)*2);    
    end       
    
    out=reshape(out,size(out,1)*size(out,2),number_of_bins);
    out=lambda*sqrt(out)./sqrt((sum(out,2)+reshape(grey_energy,size(out,1),1))*ones(1,number_of_bins));
    out=reshape(out,size(im,1),size(im,2),number_of_bins);

end
