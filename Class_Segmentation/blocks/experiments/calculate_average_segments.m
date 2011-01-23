function avg = calculate_average_segments(segpath)

    avg = 0;

    for ind = 1:632
        fname = sprintf('%05d.mat', ind);
        load(fname, 'segs');
        avg = avg + length(segs);
    end

    avg = avg / 632;

end