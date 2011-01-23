function ridgesSurf(jal,dis,hx,midaPunt,shift)

% imatge=((ridgesFound>0).*h3)+10;
% imatge(imatge==10)=0;

if nargin==3
    midaPunt=5;
    shift=0.01;
elseif nargin==4
    shift=0.01;
end
mida=length(dis);
figure
hold on
surf(hx(:,1),hx(:,2),dis,'edgecolor','none');

imatge=((jal>0).*(dis+shift));

for i=1:mida
for j=1:mida
    if imatge(i,j)>0    
      plot3(j,i,imatge(i,j),'-o','MarkerEdgeColor',[0 0 0],'MarkerFaceColor',[0 0 0],'MarkerSize',midaPunt)
 end
end
end

end

