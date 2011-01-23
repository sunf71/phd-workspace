function d=chi_square(x,y)
% aa=sum(x.*x,2); bb=sum(y.*y,2); ab=x*y'; 
% d1=repmat(aa,[1 size(bb,1)]) + repmat(bb',[size(aa,1) 1]) - 2*ab;
% d2=repmat(aa,[1 size(bb,1)]) + repmat(bb',[size(aa,1) 1]);
% d=d_final./2;


 d1 = (x-y).^2;
 d2 = x+y;
 d2(find(d2==0)) = 1;
 d = sum(d1 ./ d2);
end
