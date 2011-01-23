function cornerness = HarrisCorner(im, scale)

K   = 0.01;
si  = scale;
sd  = 0.7*scale;

mu11=zeros(size(im,1),size(im,2));
mu12=zeros(size(im,1),size(im,2));
mu22=zeros(size(im,1),size(im,2));

for k=1:size(im,3)
    Lx = gDer(im(:,:,k), sd, 1, 0);
    Ly = gDer(im(:,:,k), sd, 0, 1);
    mu11 = mu11 + gDer(Lx.*Lx, si, 0, 0).*(sd^2);
    mu12 = mu12 + gDer(Lx.*Ly, si, 0, 0).*(sd^2);
    mu22 = mu22 + gDer(Ly.*Ly, si, 0, 0).*(sd^2);
    
end 
cornerness = (mu11 .* mu22 - mu12 .^2) - K * (mu11 + mu22) .^2;

