function descriptor_points=Convert_ColorSIFT_UVA(fid1)
%%%%% read van de sande's format

descriptor_points=[];

s= fgetl(fid1);
s1 = fgetl(fid1);
s3 = fgetl(fid1);

while ~feof(fid1)

s4 = fgetl(fid1);
aaa=find(s4=='>');
descriptor_points1=s4(aaa+2:end);
descriptor_points1=str2num(descriptor_points1);
descriptor_points=[descriptor_points;descriptor_points1];
end

