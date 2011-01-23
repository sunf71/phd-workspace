#include <mex.h>
#include <math.h>

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
    int nWidth, nHeight, w, h, x, y, N, M, xi, yi, rows, cols, imgM, imgN, ii, jj;
    double *imgR, *imgG, *imgB, *imoutR, *imoutG, *imoutB, *imgR_blk, *imgG_blk, *imgB_blk, *trp, *srp1, *srp2, px, py;
    double scalex, scaley, dx, dy, yms, yps, xms, xps, sumR, sumG, sumB, count;
    mxArray *blkR, *blkG, *blkB;

    imgR    = mxGetPr(prhs[0]);
    imgG    = mxGetPr(prhs[1]);
    imgB    = mxGetPr(prhs[2]);    
    yms     = mxGetScalar(prhs[3]);
	yps     = mxGetScalar(prhs[4]);
    xms     = mxGetScalar(prhs[5]);
	xps     = mxGetScalar(prhs[6]);
    nWidth  = (int) mxGetScalar(prhs[7]);
    nHeight = (int) mxGetScalar(prhs[8]);

    imgM    = (int) mxGetM(prhs[0]);
    imgN    = (int) mxGetN(prhs[0]);
    
    M       = (int) (floor(yps) - floor(yms));
    N       = (int) (floor(xps) - floor(xms));
    
    scalex  = (double) N / nWidth;
	scaley  = (double) M / nHeight;
      
    /* check the inputs */
	if (nrhs!=9)
        mexErrMsgTxt("Nine input arguments are required.\n");

    if (!mxIsDouble(prhs[0]) | !mxIsDouble(prhs[1]) | !mxIsDouble(prhs[2]))
        mexErrMsgTxt("Input image should be double.\n");

    /* creating matrices for intermediate and output patches (per channel) */
    blkR = mxCreateDoubleMatrix(M, N, mxREAL);
    blkG = mxCreateDoubleMatrix(M, N, mxREAL);
    blkB = mxCreateDoubleMatrix(M, N, mxREAL);

    imgR_blk = mxGetPr(blkR);
    imgG_blk = mxGetPr(blkG);
    imgB_blk = mxGetPr(blkB);

    plhs[0] = mxCreateDoubleMatrix(nWidth, nHeight, mxREAL);
    plhs[1] = mxCreateDoubleMatrix(nWidth, nHeight, mxREAL);
    plhs[2] = mxCreateDoubleMatrix(nWidth, nHeight, mxREAL);

    imoutR = mxGetPr(plhs[0]);
    imoutG = mxGetPr(plhs[1]);
    imoutB = mxGetPr(plhs[2]);

    /* code for test (to see the intermediate patch in the output) 
    plhs[3] = mxCreateDoubleMatrix(M, N, mxREAL);      
    plhs[4] = mxCreateDoubleMatrix(M, N, mxREAL);      
    plhs[5] = mxCreateDoubleMatrix(M, N, mxREAL);      

    imgR_blk = mxGetPr(plhs[3]);
    imgG_blk = mxGetPr(plhs[4]);
    imgB_blk = mxGetPr(plhs[5]); */    

    rows=floor(yms);
    cols=floor(xms);
    
    for (ii=0; ii<M; ii++) {
        for (jj=0; jj<N; jj++) {
                    imgR_blk[ii+M*jj] = -1;
        }
    }  
   
    /* Transfering pixels from original image to an intermediate patch */
    for (ii=0; ii<M; ii++) {
        for (jj=0; jj<N; jj++) {
                if (rows+ii>=0 && cols+jj>=0 && rows+ii<imgM && cols+jj<imgN) {
                    imgR_blk[ii+M*jj] = imgR[rows+imgM*cols+ii+imgM*jj];
                    imgG_blk[ii+M*jj] = imgG[rows+imgM*cols+ii+imgM*jj];
                    imgB_blk[ii+M*jj] = imgB[rows+imgM*cols+ii+imgM*jj];
                }
        }
    }  
    
    /* filling the empty spaces with patch mean value */
    sumR  = 0;
    sumG  = 0;
    sumB  = 0;
    count = 0;

    for (ii=0; ii<M; ii++) {
        for (jj=0; jj<N; jj++) {
                if (imgR_blk[ii+M*jj]>=0) {
                    sumR = sumR + imgR_blk[ii+M*jj];
                    sumG = sumG + imgG_blk[ii+M*jj];
                    sumB = sumB + imgB_blk[ii+M*jj];
                    count++;
                }
        }
    }  
    for (ii=0; ii<M; ii++) {
        for (jj=0; jj<N; jj++) {
                if (imgR_blk[ii+M*jj]<0) {
                    imgR_blk[ii+M*jj] = sumR/count;
                    imgG_blk[ii+M*jj] = sumG/count;
                    imgB_blk[ii+M*jj] = sumB/count;
                }
        }
    }  

    w = M - 1;
  	h = N - 1;
    
    /* scaling and interpolation of R channel */
    for(y = 0; y < nHeight; y++) {
        trp  = imoutR + nHeight*y;
        py   = y*scaley;
        yi   = (int) py;
        dy   = py - yi;
        srp1 = imgR_blk + M*yi;
        srp2 = imgR_blk + M*(yi+1);
        for(x = 0 ; x < nWidth; x++, trp++){
            px = x * scalex;
            xi = (int) px;
            dx = px-xi;
            if( (xi<w) && (yi<h) )
                (*trp) = (1.-dy)*((1.-dx)*srp1[xi]+dx*srp1[xi+1]) + dy*((1.-dx)*srp2[xi]+dx*srp2[xi+1]);
            else if( (xi<=w) && (yi<h) )
                (*trp) = (1.-dy)*((1.-dx)*srp1[w]+dx*srp1[w]) + dy*((1.-dx)*srp2[w]+dx*srp2[w]);
            else if( (xi<w) && (yi<=h) )
                (*trp) = (1.-dy)*((1.-dx)*srp1[xi]+dx*srp1[xi+1]) + dy*((1.-dx)*srp1[xi]+dx*srp1[xi+1]);
            else if( (xi<=w) && (yi<=h) )
                (*trp) = (1.-dy)*((1.-dx)*srp1[w]+dx*srp1[w]) + dy*((1.-dx)*srp1[w]+dx*srp1[w]);
            }
        }

	/* scaling and interpolation of G channel */
    for(y = 0; y < nHeight; y++) {
        trp  = imoutG + nHeight*y;
        py   = y*scaley;
        yi   = (int) py;
        dy   = py - yi;
        srp1 = imgG_blk + M*yi;
        srp2 = imgG_blk + M*(yi+1);
        for(x = 0 ; x < nWidth; x++, trp++){
            px = x * scalex;
            xi = (int) px;
            dx = px-xi;
            if( (xi<w) && (yi<h) )
                (*trp) = (1.-dy)*((1.-dx)*srp1[xi]+dx*srp1[xi+1]) + dy*((1.-dx)*srp2[xi]+dx*srp2[xi+1]);
            else if( (xi<=w) && (yi<h) )
                (*trp) = (1.-dy)*((1.-dx)*srp1[w]+dx*srp1[w]) + dy*((1.-dx)*srp2[w]+dx*srp2[w]);
            else if( (xi<w) && (yi<=h) )
                (*trp) = (1.-dy)*((1.-dx)*srp1[xi]+dx*srp1[xi+1]) + dy*((1.-dx)*srp1[xi]+dx*srp1[xi+1]);
            else if( (xi<=w) && (yi<=h) )
                (*trp) = (1.-dy)*((1.-dx)*srp1[w]+dx*srp1[w]) + dy*((1.-dx)*srp1[w]+dx*srp1[w]);
            }
        }

	/* scaling and interpolation of B channel */
    for(y = 0; y < nHeight; y++) {
        trp  = imoutB + nHeight*y;
        py   = y*scaley;
        yi   = (int) py;
        dy   = py - yi;
        srp1 = imgB_blk + M*yi;
        srp2 = imgB_blk + M*(yi+1);
        for(x = 0 ; x < nWidth; x++, trp++){
            px = x * scalex;
            xi = (int) px;
            dx = px-xi;
            if( (xi<w) && (yi<h) )
                (*trp) = (1.-dy)*((1.-dx)*srp1[xi]+dx*srp1[xi+1]) + dy*((1.-dx)*srp2[xi]+dx*srp2[xi+1]);
            else if( (xi<=w) && (yi<h) )
                (*trp) = (1.-dy)*((1.-dx)*srp1[w]+dx*srp1[w]) + dy*((1.-dx)*srp2[w]+dx*srp2[w]);
            else if( (xi<w) && (yi<=h) )
                (*trp) = (1.-dy)*((1.-dx)*srp1[xi]+dx*srp1[xi+1]) + dy*((1.-dx)*srp1[xi]+dx*srp1[xi+1]);
            else if( (xi<=w) && (yi<=h) )
                (*trp) = (1.-dy)*((1.-dx)*srp1[w]+dx*srp1[w]) + dy*((1.-dx)*srp1[w]+dx*srp1[w]);
            }
        }
   
}