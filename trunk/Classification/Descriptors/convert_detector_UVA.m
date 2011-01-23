function b=convert_detector_UVA(detector_points)
%%%%%%%%  to convert our detector into Van de sande's output %%%%%%
delete('/media/DATA/Datasets/Texture_own/Temp/DoG_milan.txt')

fid = fopen('/media/DATA/Datasets/Texture_own/Temp/DoG_milan.txt','wt'); 

% fid1 = fopen('/media/DATA/Matlab_code/UVA_Color_Descriptor/milan1.txt'); 
%  s= fgetl(fid1);


fprintf(fid,'KOEN1'); 
fprintf(fid,'\n');
b=0;
fprintf(fid,'%d \n',b);
fprintf(fid,'%d \n',size(detector_points,1));

for i=1:size(detector_points,1)
    fprintf(fid,'<CIRCLE %d %d %f %d %d>;; \n',detector_points(i,1),detector_points(i,2),detector_points(i,3),b,b);
end
fclose(fid);








% delete('/media/DATA/Matlab_code/UVA_Color_Descriptor/UVA_try.txt')
% 
% fid = fopen('/media/DATA/Matlab_code/UVA_Color_Descriptor/UVA_try.txt','wt'); 
% 
%  fid1 = fopen('/media/DATA/Matlab_code/UVA_Color_Descriptor/milan1.txt'); 
%  s= fgetl(fid1);
% 
% 
% fprintf(fid,'%s \n',s); 
% b='0';
% fprintf(fid,'%s \n',b);
% 
% 
% fprintf(fid,'%s \n',num2str(size(detector_points,1)));
% c=0;
% for i=1:size(detector_points,1)
%     fprintf(fid,'<CIRCLE %d %d %f %d %d>;; \n',detector_points(i,1),detector_points(i,2),detector_points(i,3),c,c);
% end