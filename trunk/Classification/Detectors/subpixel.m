% SUBPIXEL  Subpixel interpolation of peakes
%
%	[dxr, dyr] = subpixel(surf)
%	[dxr, dyr] = subpixel(surf, dx, dy)
%
%  Given a 2-d surface refine the estimate of the peak to subpixel precision/
%  The peak may be given by (dx, dy) or searched for.

function [ddx,ddy] = subpixel(im, dx, dy)
	[nr,nc] = size(im);
    ddx=zeros(size(dx));
    ddy=zeros(size(dy));
 
    for k=1:length(dx)
        if dx(k) > 1 && dy(k) > 1 && dx(k) < (nc-1) && dy(k) < (nr-1),
            zn = im(dy(k)-1, dx(k));
            zs = im(dy(k)+1, dx(k));
            ze = im(dy(k), dx(k)+1);
            zw = im(dy(k), dx(k)-1);
            zc = im(dy(k), dx(k));

            ddx(k) = 0.5*(ze-zw)/(2*zc-zw-ze);
            ddy(k) = 0.5*(zs-zn)/(2*zc-zn-zs);

            if abs(ddx(k)) < 1 && abs(ddy(k)) > 1,
                fprintf('interpolation too big %f %f\n', ddx(k), ddy(k));
                ddx(k) = 0;
                ddy(k) = 0;
            end
            
        end
    end
