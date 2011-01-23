function job = do_all_svmtrain()
job = dfevalasync(@do_one_svmtrain, 2, {1,2,3,4,5,20}, 'jobmanager', ...
                  'bigprocess', 'PathDependencies', {'/home/fahad/Matlab_code/Classification', '/home/fahad/Matlab_code/libsvm-mat-2.84-1-fast'});
return