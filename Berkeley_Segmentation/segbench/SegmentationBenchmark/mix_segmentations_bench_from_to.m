function mix_segmentations_bench_from_to(from, to)

files = dir('./ORG');
op_path = 'UNIMODAL';
mkdir(op_path);
for ind = from:to
    ind
    segInd = str2num(files(ind).name(1:end-4));
    mix_segmentations_bench(segInd, op_path);
end

end