function [out2,corner,f_ang_y]=opponent_descriptor6b_original(patches_R,patches_G,patches_B,number_of_bins,smooth_flag,mirror_flag)
% computes the opponent color angle
% first bin is used to store the grey-derivative-energy.
% magic number:
% devision by four in the last line, to diminish the influence of the grey
% energy.
%opponent_descriptor3: does divide the first bin bu the number of bins (to
%lessen its influence)
%opponent_descriptor4: the energy is used to normalize but then first bin
%is put to a constant 0.01
%opponent descriptor5: same as 4 only now all bins are used to encode the
%color, and the constant bin has been removed.
%MAGIC NUMBER : to compute the normalized energy we use numebr_of_bins/4;
% opponent descriptor6: does bilinear bin  filling of the histograms.
%mirro_flag is removed: always mirroring which means opposite
%colorderivatives are considered equal.
% opponent descriptor6b: normalizes with total derivative energy

if(nargin<6) mirror_flag=1;end      %if mirror_flag=1 only orientation  (0,pi) is taken into account otherwise the direction (0,2*pi) is used.

% lambda=1;
spatial_flag=1;        % a spatial gaussian weight is added 

if(spatial_flag==1)
    [yy,xx]=ndgrid(-9.5:9.5,-9.5:9.5);
    spatial_weights=exp((-xx.^2-yy.^2)./50);        % a sigma of 5 pixels 
else
    spatial_weigths=ones(20,20);
end
    
number_of_patches=size(patches_R,2);

patch_in=zeros(20,20,3);
out2=zeros(number_of_bins,number_of_patches);
weights=zeros(1,number_of_patches);
sigma_g=1.;

for(kk=1:number_of_patches)   
    mask=ones(20,20);    

    patch_in(:,:,1)=reshape(patches_R(:,kk),20,20);
    patch_in(:,:,2)=reshape(patches_G(:,kk),20,20);
    patch_in(:,:,3)=reshape(patches_B(:,kk),20,20);
    
    if(sum(sum(sum(patch_in,3)==0))) mask_flag=1; mask=double(sum(patch_in,3)~=0); end
    
	out=zeros(number_of_bins,1);
	
	[f_O1_x,f_O1_y,f_O2_x,f_O2_y,f_O3_x,f_O3_y] = eeOpponent_der(fill_border(patch_in,floor(3*sigma_g+.5)),sigma_g);
    
	start_wh=floor(3*sigma_g+.5)+1;
	end_h=floor(3*sigma_g+.5)+size(patch_in,1);
	end_w=floor(3*sigma_g+.5)+size(patch_in,2);
	
	f_O1_x=f_O1_x(start_wh:end_h,start_wh:end_w);
	f_O1_y=f_O1_y(start_wh:end_h,start_wh:end_w);
	f_O2_x=f_O2_x(start_wh:end_h,start_wh:end_w);
	f_O2_y=f_O2_y(start_wh:end_h,start_wh:end_w);
	f_O3_x=f_O3_x(start_wh:end_h,start_wh:end_w);
	f_O3_y=f_O3_y(start_wh:end_h,start_wh:end_w);

    f_ang_x = spatial_weights.* ( f_O1_x.^2+f_O2_x.^2 );
    f_ang_y = spatial_weights.* ( f_O1_y.^2+f_O2_y.^2 );
    TotalEnergy=sum(spatial_weights(:).*(f_O3_x(:).^2+f_O3_y(:).^2))+sum(f_ang_x(:))+sum(f_ang_y(:));
    
    if(mirror_flag)
        %x-derivatives
        corner=atan2(f_O1_x,f_O2_x);
        corner=corner+pi.*(corner<0);
        out_x=make_hist_corner(corner,f_ang_x,number_of_bins);
        %y-derivatives
        corner=atan2(f_O1_y,f_O2_y);
        corner=corner+pi.*(corner<0);
        out_y=make_hist_corner(corner,f_ang_y,number_of_bins);
        out=out_x+out_y;
        out=out';
    else
        %x-derivatives
        corner=atan2(f_O1_x,f_O2_x);
        corner=(corner+pi)/2;       
        out_x=make_hist_corner(corner,f_ang_x,number_of_bins);
        %y-derivatives
        corner=atan2(f_O1_y,f_O2_y);
        corner=(corner+pi)/2;       
        out_y=make_hist_corner(corner,f_ang_y,number_of_bins);
        out=out_x+out_y;
        out=out';
    end
    if(smooth_flag>0)
            for(ss=1:smooth_flag)
                out=(2*out+[out(2:length(out));out(1)]+[out(length(out));out(1:(length(out)-1))])/4;
            end
    end
%     out2(:,kk)=lambda*sqrt(out)/sqrt(TotalEnergy);
      out2(:,kk)=sqrt(out)/sqrt(TotalEnergy);
end

function out=make_hist_corner(angle_in,weights,number_of_bins)

out2=zeros(1,number_of_bins+1);
bin_number= (angle_in/pi*number_of_bins);

width=size(angle_in,2);
height=size(angle_in,1);

for(jj=1:height)
    for(ii=1:width)
         bn=bin_number(jj,ii);
         if (bn>=number_of_bins) bn=number_of_bins-.1; end
         cc1=floor(bn);
         w_loc=weights(jj,ii);
         for(dd1=cc1:cc1+1)
                 weight2=(1-abs(bn-dd1) );
                 out2(dd1+1)=out2(dd1+1)+weight2.*w_loc;
         end
    end
end

out=out2(1:number_of_bins);
out(1)=out(1)+out2(1+number_of_bins);

