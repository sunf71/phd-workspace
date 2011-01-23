function out=CanviEixos(i)
% Generacio de les matrius que permeten fer canvi d'eixos
% en base a la descomposicio en translacions i rotacions 
% de cada eix.
% Suposem un espai de tres dimensions que anomenem RGB
% I suposem que volem fer-li les seguents transformacions

sz=size(i);
if (size(i,3)==3)
	i=reshape(i,sz(1)*sz(2),3);
end

TR=0;
TG=0;
TB=-1;

AngleBR=-pi/4;
AngleGB=((pi/2)-atan(sqrt(2)));
AngleRG=0;

% Translacio d'eixos

Trans=[1 0 0 0; 0 1 0 0; 0 0 1 0; TR TG TB 1];

% Rotacio en el pla RG

RotRG=[cos(AngleRG) sin(AngleRG) 0 0; -sin(AngleRG) cos(AngleRG) 0 0; 0 0 1 0; 0 0 0 1];

% Rotacio en el pla GB

RotGB=[1 0 0 0; 0 cos(AngleGB) sin(AngleGB) 0; 0 -sin(AngleGB) cos(AngleGB) 0; 0 0 0 1];

% Rotacio en el pla BR

RotBR=[cos(AngleBR) 0 -sin(AngleBR) 0; 0 1 0 0; sin(AngleBR) 0 cos(AngleBR) 0; 0 0 0 1];

% Exemple: Canvi d'eixos de coordenades cromatiques a 2CC

T2CC=Trans*RotBR*RotGB;


% figure;
% hold;
% grid on;
% rang=1;
% Triangle=[rang 0 0 1; 0 rang 0 1; 0 0 rang 1; rang 0 0 1];
% %Extrems=[ 0 0 0 1 ; rang 0 0 1 ; rang rang 0 1 ; 0 rang 0 1 ; 0 0 rang 1 ; 0 rang rang 1 ; rang rang rang 1 ; rang 0 rang 1 ];
% Extrems=[ 0 0 0 1 ; rang 0 0 1 ; rang rang 0 1 ; 0 rang 0 1 ; 0 0 0 1 ; ...
% 0 0 rang 1 ; 0 rang rang 1 ; rang rang rang 1 ; rang 0 rang 1 ;0 0 rang 1 ;...
% 0 rang rang 1 ; 0 rang 0 1; rang rang 0 1; rang rang rang 1; rang 0 rang 1; rang 0 0 1];
% %TExtrems=zeros(size(Extrems,1),4);
% TExtrems=Extrems*T2CC;
% TTriangle=Triangle*T2CC;
% %for i=1:8,
% %    TExtrems(i,:)=Extrems(i,:)*T2CC;
% %end
% plot3(Extrems(:,1),Extrems(:,2),Extrems(:,3),'+r-');
% plot3(TExtrems(:,1),TExtrems(:,2),TExtrems(:,3),'^b-');
% plot3(Triangle(:,1),Triangle(:,2),Triangle(:,3),'*g-');
% plot3(TTriangle(:,1),TTriangle(:,2),TTriangle(:,3),'.k-');

out=[i,ones(size(i,1),1)]*T2CC;
out=reshape(out(:,1:3),sz);

