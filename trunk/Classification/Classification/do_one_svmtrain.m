function [cc, cv] = do_one_svmtrain(cc)
cmd = ['-v 5 -t 4 -s 0 -c ', num2str(cc)];
cv = svmtrain(labels_L, traindata, cmd);
return

