function mix_segmentations_bench_from_to(from, to)

files = dir('./ORG');
for ind = from:to
    segInd = str2num(files(ind).name(1:end-4));
    mix_segmentations_bench(segInd);
end

end