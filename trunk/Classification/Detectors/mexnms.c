#include <mex.h>
#include <math.h>

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
    int h, w, i, j, k, l, iscale;
    double *input, *output;
    double scale, thres, lmax;
    
    if (nrhs != 3) {
        mexErrMsgTxt("Three input argument required.");
    }
    
    input = mxGetPr(prhs[0]);
    scale = mxGetScalar(prhs[1]);
    thres = mxGetScalar(prhs[2]);
    
    h = mxGetM(prhs[0]); 
    w = mxGetN(prhs[0]);
    	       
    plhs[0] = mxCreateDoubleMatrix(h, w, mxREAL);
    output = mxGetPr(plhs[0]);
 
    iscale = (int) scale;
    
	for (j = iscale; j <= h-iscale-1; j++) {
        for (i = iscale; i<= w-iscale-1 ; i++) {           
           	lmax = -10000;
            for (l = j-iscale; l <= j+iscale; l++) {
                for (k = i-iscale; k<= i+iscale ; k++) {
                    if (input[l+h*k]>lmax && !(l==j && k==i)) {
                       lmax = input[l+h*k];
                    }
                }
            }
            if (input[j+h*i]>lmax && input[j+h*i]>thres) {
                output[j+h*i]=1;
            }                    
        }
    }
}