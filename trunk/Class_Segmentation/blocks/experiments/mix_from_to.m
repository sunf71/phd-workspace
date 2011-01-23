function mix_from_to(from, to)

opdir = 'OppsegSegs';
mkdir(['/home/amounir/Workspace/Superpixels-iccv2009/results/' opdir]);
system(['chmod -R a+rwx ' '/home/amounir/Workspace/Superpixels-iccv2009/results/' opdir]);

parfor segInd = from:to
    
segInd

ofname = sprintf('/home/amounir/Workspace/Superpixels-iccv2009/results/%s/%05d.mat', opdir, segInd);
if (exist(ofname, 'file') == 2)
    continue;
end

[Iseg map] = mix_segmentations2(segInd);

Iseg = uint8(Iseg);

result = struct();
result.Iseg = Iseg;
result.map = map;

saveResult(ofname, result);

end

end


function saveResult(ofname, result)
    save(ofname, '-STRUCT', 'result', '-MAT');
end