
function pinta(crestesDistrib,Msize)

if nargin==1
    Msize=5;
end

mida=length(crestesDistrib);
[i j k]=ind2sub(size(crestesDistrib),find(crestesDistrib>0));

hold on

line([0 mida],[0 0],[0 0])
line([0 mida],[mida mida],[0 0])
line([0 mida],[mida mida],[mida mida])
line([0 mida],[0 0],[mida mida])

line([0 0],[0 mida],[0 0])
line([mida mida],[0 mida],[0 0])
line([mida mida],[0 mida],[mida mida])
line([0 0],[0 mida],[mida mida])

line([0 0],[0 0],[0 mida])
line([0 0],[mida mida],[0 mida])
line([mida mida],[mida mida],[0 mida])
line([mida mida],[0 0],[0 mida])
axis([0 mida 0 mida 0 mida])

for count=1:length(i)
    r=(i(count)*(255/mida))/255;
    g=(j(count)*(255/mida))/255;
    b=(k(count)*(255/mida))/255;        
      plot3(i(count),j(count),k(count),'-o','MarkerEdgeColor',[r g b],'MarkerFaceColor',[r g b],'MarkerSize',Msize)
end


end