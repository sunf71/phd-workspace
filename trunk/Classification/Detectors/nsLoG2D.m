function nLoG = nsLoG2D(im, sigma) 
% Compute the normalized-scale Laplacian of Gaussian in
% color and gray-level images
%
% Sintax: nLoG = nsLoG2D(im, sigma)

Lxx=zeros(size(im));
Lyy=zeros(size(im));
for i=1:size(im,3)
   Lxx(:,:,i) = gDer(im(:,:,i), sigma, 0, 2);
   Lyy(:,:,i) = gDer(im(:,:,i), sigma, 2, 0);
end
LoG = (Lxx + Lyy).^2;
nLoG = sqrt(sum(LoG,3)).*(sigma^2);