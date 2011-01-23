/*
mex crestes.c crestes3d/st_optim3D.c crestes3d/convGaus1D_Simetrica.c crestes3d/eigensystem.c crestes3d/conversioViLiMatlab.c crestes3d/nrutil.c crestes2d/MLSECST.c crestes2d/st_analitico2D.c crestes2d/diffinit2D.c

mex crestes.c MLSECST.c st_analitico2D.c convGaus1D_Simetrica.c diffinit2D.c conversioViLiMatlab.c nrutil.c

*/

#include "include/conversioViLiMatlab.h"
Image st_optim3D(Image *L, double sigmaD, double sigmaI, double cont);

#define SizeOfPixel (type==1?sizeof(char):(type==2?sizeof(short):(type==3?sizeof(long):sizeof(float))))
#define SizeOfImage (SizeOfPixel*dx*dy*dz)

#include <stdio.h>
#include <stdlib.h>


void mexFunction( int nlhs, mxArray *plhs[],int nrhs, const mxArray *prhs[])
{
	Image In, Out, Deriva=NULL, OLx=NULL, OLy=NULL;
	double sd, si, confianca;

	/* Check for proper number of arguments. */
	if(nrhs<3) mexErrMsgTxt("At least three inputs required.");
	if(nlhs > 2) mexErrMsgTxt("Too many output arguments.");

	if  ( !mxIsNumeric(prhs[0]) || mxIsComplex(prhs[0]) ) 
		mexErrMsgTxt("First parameter should be an image");

	if(nrhs>1) {
		if (!mxIsDouble(prhs[1]) || mxIsComplex(prhs[1]) ||
					mxGetN(prhs[1])*mxGetM(prhs[1]) != 1 ) {
			mexErrMsgTxt("2nd parameter must be a scalar.");
		} else {
			/* Get the scalar input cont. */ 
			sd = mxGetScalar(prhs[1]);
		}
	}
	if(nrhs>2) {
		if (!mxIsDouble(prhs[2]) || mxIsComplex(prhs[2]) ||
					mxGetN(prhs[2])*mxGetM(prhs[2]) != 1 ) {
			mexErrMsgTxt("3rd parameter must be a scalar.");
		} else {
			/* Get the scalar input cont. */ 
			si = mxGetScalar(prhs[2]);
		}
	}
	if(nrhs>3) {
		if (!mxIsDouble(prhs[3]) || mxIsComplex(prhs[3]) ||
					mxGetN(prhs[3])*mxGetM(prhs[3]) != 1 ) {
			mexErrMsgTxt("4rd parameter must be a scalar.");
		} else {
			/* Get the scalar input cont. */ 
			confianca = mxGetScalar(prhs[3]);
		}
	} else confianca=0;

	/* Prepara les dades d'entrada */
	In = Matlab2ViLi(prhs[0]);
	if (mxGetNumberOfDimensions(prhs[0]) == 3) {
		Out=st_optim3D(&In,sd,si,confianca);
		if (nlhs==2) plhs[1] = ViLi2Matlab(In,1);
	} else {
		if(nlhs <=1) 
			Out=MLSECST(In, sd, si, confianca,NULL,NULL,NULL);
		else {
			Out=MLSECST(In, sd, si, confianca, &Deriva,NULL,NULL);
			plhs[1] = ViLi2Matlab(Deriva,1);
		}

	}
	plhs[0] = ViLi2Matlab(Out,1);
	/*if(nlhs > 1) plhs[1] = ViLi2Matlab(OLx,1);*/
	/*if(nlhs > 2) plhs[2] = ViLi2Matlab(OLy,1);*/
	/*DelImage(OLx);
	DelImage(OLy);*/
	DelImage(Deriva);
	DelImage(In);
	DelImage(Out);

	/* Call the C subroutine. */
	return;
}