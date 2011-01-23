function r = fastAffineTransform( f, x0, y0, x1, y1, x2, y2, Na, Ma, ipm )
% Fast affine transformation
% ipm is the interpolation method ('linear' or 'nearest').
N = size(f, 1);
M = size(f, 2);

Bu = [x0 x1 x2; y0 y1 y2] * inv( [ 1 Na 1; 1 1 Ma; 1 1 1] );
[x,y] = ndgrid(1:Na,1:Ma);
allxayaone = [ x(:) y(:) ones(Na*Ma,1) ]';
allxy = Bu * allxayaone;
allx = allxy(1,:)';
ally = allxy(2,:)';
r=zeros(Na*Ma,size(f,3));
for ii=1:size(f,3)
    r(:,ii) = interp2( f(:,:,ii), ally, allx, ipm );    
end
if(sum(isnan(r)))
    r(isnan(r(:,1)),:)=ones(sum(isnan(r(:,1))),1)*(sum(r(~isnan(r(:,1)),:))/sum(~isnan(r(:,1))));
end
r(isnan(r))=0;
r = reshape( r, Na, Ma, size(f,3));
