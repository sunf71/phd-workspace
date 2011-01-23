function [pwconst_values, pwlinear_values,exact_values]=Do_libSVM_fast_Inria_Test(labels_T,testdata,model)

display('starting model Testing');
tic;


 
   [exact_values, pwconst_values, pwlinear_values] = fastpredict(labels_T,testdata, model,'-b 1');
                 
                 
             toc;   