function [out]=compute_hue_descriptor7(patches_R,patches_G,patches_B,number_of_bins,smooth_flag)
% smooth_flag indicats amount of smoothing

%hue descriptor5: the total color enery is normalized by color+grey. 
%hue descriptor6: the total color enery is normalized by sqrt(color+grey=sqrt(R^2+G^2+B^2)
%hue descriptor7 ; with saturation^2 update and I^2 normalization (yields further focus on most saturated colors).

% lambda=1;                   %multiplation factor to have comparable bin responses in SIFT and color

if(nargin<5) smooth_flag=0; end

spatial_flag=1;        % a spatial gaussian weight is added 

%%%% get the patch_size %%%%%%
patch_size=sqrt(size(patches_R,1));

if(spatial_flag==1)
%     [yy,xx]=ndgrid(-9.5:9.5,-9.5:9.5);
    [yy,xx]=ndgrid(-(patch_size-1)/2:(patch_size-1)/2,-(patch_size-1)/2:(patch_size-1)/2);
    spatial_weights=exp((-xx.^2-yy.^2)./(patch_size.^2/8));        % 2*sigma^2 (sigma=patchsize/4)
else
    spatial_weigths=ones(patch_size,patch_size);
end

out=zeros(number_of_bins,size(patches_R,2));

H=atan2((patches_R+patches_G-2*patches_B),sqrt(3)*(patches_R-patches_G))+pi;
H(isnan(H))=0;
saturation=(2/3*(patches_R.^2+patches_G.^2+patches_B.^2-patches_R.*(patches_G+patches_B)-patches_G.*patches_B)+0.01);
grey_energy=(sum((patches_R.^2+patches_G.^2+patches_B.^2).*(spatial_weights(:)*ones(1,size(patches_R,2)))));

H=floor(H/(2*pi)*(number_of_bins));
for(jj=0:number_of_bins-1)
        out(jj+1,:)=sum(saturation.*(spatial_weights(:)*ones(1,size(patches_R,2))).*(H==jj));
end

if(smooth_flag>0)
     for(ss=1:smooth_flag)
          out=(2*out+[out(2:size(out,1),:);out(1,:)]+[out(size(out,1),:);out(1:(size(out)-1),:)])/4;
     end
end

% out=lambda*sqrt(out./(ones(size(out,1),1)*grey_energy ));
out=sqrt(out./(ones(size(out,1),1)*grey_energy ));
