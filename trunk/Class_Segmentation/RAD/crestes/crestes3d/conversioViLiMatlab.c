#include "../include/conversioViLiMatlab.h"

Image Matlab2ViLi(const mxArray *In) {

Image Res;
int Type;
int i, j, k;

if (mxIsUint8(In)) {
      Type = IM_BYTE;
} else if (mxIsInt16(In)) {
      Type = IM_SHORT;
} else if (mxIsUint32(In)) {
      Type = IM_LONG;
} else if (mxIsDouble(In)||mxIsSingle(In)) {
		if (mxIsComplex(In)) {
	   	Type = IM_COMPLEX;
		}
		else {
		   Type = IM_FLOAT;
		}
} else {
      mexErrMsgTxt("Array type not supported");
}
      
if (mxGetNumberOfDimensions(In) == 2) {
      Res = NewImage("from MATLAB", Type, mxGetDimensions(In)[1], mxGetDimensions(In)[0], 1, 1, GRID_RECT);
} else if ( (mxGetNumberOfDimensions(In) == 3) && (mxGetDimensions(In)[2] == 3)) {
         Res = NewImage("from MATLAB", Type, mxGetDimensions(In)[1], mxGetDimensions(In)[0], 1,  mxGetDimensions(In)[2], GRID_RECT);
} else if ( (mxGetNumberOfDimensions(In) == 3) && (mxGetDimensions(In)[2] != 3)) {
         Res = NewImage("from MATLAB", Type, mxGetDimensions(In)[1], mxGetDimensions(In)[0], mxGetDimensions(In)[2], 1, GRID_RECT);
} else if (mxGetNumberOfDimensions(In) == 4) {
         Res = NewImage("from MATLAB", Type, mxGetDimensions(In)[1], mxGetDimensions(In)[0], mxGetDimensions(In)[2], mxGetDimensions(In)[3], GRID_RECT);
} else {
     mexErrMsgTxt("Dimensions not supported");
}

switch(Type) {
      case IM_BYTE:
			{
         unsigned char *pIn, *pRes;
         pRes = (unsigned char *) Res->Data;
         pIn = (unsigned char *) mxGetData(In);
			/* Copia transponiendo filas y columnas */
			for (k=0; k<Res->NPlanes * Res->NChannels; k++) {
				for (j=0; j<Res->NCol; j++) {
					for (i=0; i<Res->NLin; i++) {
						pRes[ j + i * Res->NCol + k * Res->NCol * Res->NLin] =
							pIn[ i + j * Res->NLin + k * Res->NCol * Res->NLin];
					}
				}
			}
			}
         break;
      case IM_SHORT:
			{
         short *pIn, *pRes;
         pRes = (short *) Res->Data;
         pIn = (short *) mxGetData(In);
			/* Copia transponiendo filas y columnas */
			for (k=0; k<Res->NPlanes * Res->NChannels; k++) {
				for (j=0; j<Res->NCol; j++) {
					for (i=0; i<Res->NLin; i++) {
						pRes[ j + i * Res->NCol + k * Res->NCol * Res->NLin] =
							pIn[ i + j * Res->NLin + k * Res->NCol * Res->NLin];
					}
				}
			}
			}
         break;
      case IM_LONG:
			{
         unsigned long *pIn, *pRes;
         pRes = (unsigned long *) Res->Data;
         pIn = (unsigned long *) mxGetData(In);
			/* Copia transponiendo filas y columnas */
			for (k=0; k<Res->NPlanes * Res->NChannels; k++) {
				for (j=0; j<Res->NCol; j++) {
					for (i=0; i<Res->NLin; i++) {
						pRes[ j + i * Res->NCol + k * Res->NCol * Res->NLin] =
							pIn[ i + j * Res->NLin + k * Res->NCol * Res->NLin];
					}
				}
			}
			}
         break;
      case IM_FLOAT:
			{
			float *pRes;
         	pRes = (float *) Res->Data;
         	if (mxIsSingle(In)){
	        	float *pIn;
         		pIn = (float *) mxGetData(In);
				/* Copia transponiendo filas y columnas */
				for (k=0; k<Res->NPlanes * Res->NChannels; k++) {
					for (j=0; j<Res->NCol; j++) {
						for (i=0; i<Res->NLin; i++) {
							pRes[ j + i * Res->NCol + k * Res->NCol * Res->NLin] =
								(float) pIn[ i + j * Res->NLin + k * Res->NCol * Res->NLin];
						}
					}
				}
			} else {
	        	double *pIn;
         		pIn = (double *) mxGetData(In);
				/* Copia transponiendo filas y columnas */
				for (k=0; k<Res->NPlanes * Res->NChannels; k++) {
					for (j=0; j<Res->NCol; j++) {
						for (i=0; i<Res->NLin; i++) {
							pRes[ j + i * Res->NCol + k * Res->NCol * Res->NLin] =
								(float) pIn[ i + j * Res->NLin + k * Res->NCol * Res->NLin];
						}
					}
				}
			}
			}
         break;
		case IM_COMPLEX:
			{
			Complex *pRes;
	        pRes = (Complex *) Res->Data;
           	if (mxIsSingle(In)){
	        	float *pInR, *pInI;
	    	    pInR = mxGetPr(In);
	        	pInI = mxGetPi(In);
	
				/* Copia transponiendo filas y columnas */
				for (k=0; k<Res->NPlanes * Res->NChannels; k++) {
					for (j=0; j<Res->NCol; j++) {
						for (i=0; i<Res->NLin; i++) {
							pRes[ j + i * Res->NCol + k * Res->NCol * Res->NLin].Re =
								(float) pInR[ i + j * Res->NLin + k * Res->NCol * Res->NLin];
							pRes[ j + i * Res->NCol + k * Res->NCol * Res->NLin].Im =
								(float) pInI[ i + j * Res->NLin + k * Res->NCol * Res->NLin];
						}
					}
				}
			} else {
	        	double *pInR, *pInI;
	    	    pInR = mxGetPr(In);
	        	pInI = mxGetPi(In);
	
				/* Copia transponiendo filas y columnas */
				for (k=0; k<Res->NPlanes * Res->NChannels; k++) {
					for (j=0; j<Res->NCol; j++) {
						for (i=0; i<Res->NLin; i++) {
							pRes[ j + i * Res->NCol + k * Res->NCol * Res->NLin].Re =
								(float) pInR[ i + j * Res->NLin + k * Res->NCol * Res->NLin];
							pRes[ j + i * Res->NCol + k * Res->NCol * Res->NLin].Im =
								(float) pInI[ i + j * Res->NLin + k * Res->NCol * Res->NLin];
						}
					}
				}
			}
			}
         break;
	
}
   
return Res;
}

mxArray* ViLi2Matlab(Image In, int setdouble) {
	mxArray *Res;
	int dims[4], Ndims;
	mxClassID class;
	int i, j, k;

	if (In->NPlanes == 1) {
		if (In->NChannels == 1) {
			dims[0] = In->NLin;
			dims[1] = In->NCol;
			Ndims = 2;
		}
		else {
			dims[0] = In->NLin;
			dims[1] = In->NCol;
			dims[2] = In->NChannels;
			Ndims = 3;
		}
	}
	else {
		if (In->NChannels == 1) {
			dims[0] = In->NLin;
			dims[1] = In->NCol;
			dims[2] = In->NPlanes;
			Ndims = 3;
		}
		else {
			dims[0] = In->NLin;
			dims[1] = In->NCol;
			dims[2] = In->NPlanes;
			dims[3] = In->NChannels;
			Ndims = 4;
		}
	}
	switch(In->Type) {
		case IM_BYTE:
			class = setdouble?mxSINGLE_CLASS:mxUINT8_CLASS;
			break;
		case IM_SHORT:
			class = setdouble?mxSINGLE_CLASS:mxINT16_CLASS;
			break;
		case IM_LONG:
			class = setdouble?mxSINGLE_CLASS:mxUINT32_CLASS;
			break;
		case IM_FLOAT:
			class = mxSINGLE_CLASS;
			break;
		case IM_COMPLEX:
			class = mxSINGLE_CLASS;
			break;
	}
	
	Res = mxCreateNumericArray(Ndims, dims, class, In->Type==IM_COMPLEX?mxCOMPLEX:mxREAL);

	switch(In->Type) {
	      case IM_BYTE:
			{
         unsigned char *pIn;
         pIn = (unsigned char *) In->Data;
		 if (setdouble) {
			float *pRes;
			 pRes = (float *) mxGetData(Res);
				/* Copia transponiendo filas y columnas */
				for (k=0; k<In->NPlanes * In->NChannels; k++) {
					for (j=0; j<In->NCol; j++) {
						for (i=0; i<In->NLin; i++) {
							pRes[ i + j * In->NLin + k * In->NCol * In->NLin] =
								pIn[ j + i * In->NCol + k * In->NCol * In->NLin];
						}
					}
				}
		 } else {
			unsigned char *pRes;
			 pRes = (unsigned char *) mxGetData(Res);
				/* Copia transponiendo filas y columnas */
				for (k=0; k<In->NPlanes * In->NChannels; k++) {
					for (j=0; j<In->NCol; j++) {
						for (i=0; i<In->NLin; i++) {
							pRes[ i + j * In->NLin + k * In->NCol * In->NLin] =
								pIn[ j + i * In->NCol + k * In->NCol * In->NLin];
						}
					}
				}
		 }
			}
         break;
      case IM_SHORT:
			{
         short *pIn;
         pIn = (short *) In->Data;
		 if (setdouble) {
			float *pRes;
			 pRes = (float *) mxGetData(Res);
				/* Copia transponiendo filas y columnas */
				for (k=0; k<In->NPlanes * In->NChannels; k++) {
					for (j=0; j<In->NCol; j++) {
						for (i=0; i<In->NLin; i++) {
							pRes[ i + j * In->NLin + k * In->NCol * In->NLin] =
								pIn[ j + i * In->NCol + k * In->NCol * In->NLin];
						}
					}
				}
		 } else {
			short *pRes;
			 pRes = (short *) mxGetData(Res);
				/* Copia transponiendo filas y columnas */
				for (k=0; k<In->NPlanes * In->NChannels; k++) {
					for (j=0; j<In->NCol; j++) {
						for (i=0; i<In->NLin; i++) {
							pRes[ i + j * In->NLin + k * In->NCol * In->NLin] =
								pIn[ j + i * In->NCol + k * In->NCol * In->NLin];
						}
					}
				}
		 }
			}
         break;			
      case IM_LONG:
			{
         unsigned long *pIn;
         pIn = (unsigned long *) In->Data;
		 if (setdouble) {
			float *pRes;
			 pRes = (float *) mxGetData(Res);
				/* Copia transponiendo filas y columnas */
				for (k=0; k<In->NPlanes * In->NChannels; k++) {
					for (j=0; j<In->NCol; j++) {
						for (i=0; i<In->NLin; i++) {
							pRes[ i + j * In->NLin + k * In->NCol * In->NLin] =
								pIn[ j + i * In->NCol + k * In->NCol * In->NLin];
						}
					}
				}
		 } else {
			unsigned long *pRes;
			 pRes = (unsigned long *) mxGetData(Res);
				/* Copia transponiendo filas y columnas */
				for (k=0; k<In->NPlanes * In->NChannels; k++) {
					for (j=0; j<In->NCol; j++) {
						for (i=0; i<In->NLin; i++) {
							pRes[ i + j * In->NLin + k * In->NCol * In->NLin] =
								pIn[ j + i * In->NCol + k * In->NCol * In->NLin];
						}
					}
				}
		 }
			}
         break;
      case IM_FLOAT:
			{
         float *pIn;
			float *pRes;
         pRes = (float *) mxGetData(Res);
         pIn = (float *) In->Data;
			/* Copia transponiendo filas y columnas */
			for (k=0; k<In->NPlanes * In->NChannels; k++) {
				for (j=0; j<In->NCol; j++) {
					for (i=0; i<In->NLin; i++) {
					pRes[ i + j * In->NLin + k * In->NCol * In->NLin] =
							pIn[ j + i * In->NCol + k * In->NCol * In->NLin];
						}
				}
			}
			}
         break;
      case IM_COMPLEX:
			{
         Complex *pIn;
			float *pResR, *pResI;

         pResR = mxGetPr(Res);
         pResI = mxGetPr(Res);
         pIn = (Complex *) In->Data;
			/* Copia transponiendo filas y columnas */
			for (k=0; k<In->NPlanes * In->NChannels; k++) {
				for (j=0; j<In->NCol; j++) {
					for (i=0; i<In->NLin; i++) {
						pResR[ i + j * In->NLin + k * In->NCol * In->NLin] =
							pIn[ j + i * In->NCol + k * In->NCol * In->NLin].Re;
						pResI[ i + j * In->NLin + k * In->NCol * In->NLin] =
							pIn[ j + i * In->NCol + k * In->NCol * In->NLin].Im;

					}
				}
			}
			}
         break;
	}
	return Res;
		
}


unsigned SizeOfImage(Image PtrIma)
{
    unsigned Pixels;

    Pixels=PtrIma->NCol*PtrIma->NLin*PtrIma->NPlanes*PtrIma->NChannels;
    switch (PtrIma->Type) {
        case IM_BYTE:      Pixels*= sizeof(unsigned char);break;
        case IM_SHORT:     Pixels*= sizeof(short);break;
        case IM_LONG:      Pixels*= sizeof(long);break;
        case IM_FLOAT:     Pixels*= sizeof(float);break;
        /*case IM_COMPLEX:   Pixels*= sizeof(Complex);break;*/
    }
    return Pixels;
}

Image NewImage(char *Ident,int Type,int NCol,int NLin,int NPlanes,int NChannels,int GridType)
{
    Image PtrIma=NULL;;

	PtrIma=(Image)malloc(sizeof (*PtrIma));
    if (PtrIma) {
		PtrIma->Ident=NULL;
		PtrIma->Data=NULL;
		PtrIma->Type=Type;
		PtrIma->NCol=NCol;
		PtrIma->NLin=NLin;
		PtrIma->NPlanes=NPlanes;
		PtrIma->NChannels=NChannels;
		PtrIma->GridType=GridType;
		PtrIma->Data=malloc(SizeOfImage(PtrIma));
		if (!PtrIma->Data) free(PtrIma);
		else {
			if (Ident) {
				PtrIma->Ident=(char*)malloc(strlen(Ident)+1);
				if (!PtrIma->Ident)	Raise("Out of memory");
				strcpy((char *) PtrIma->Ident,Ident);
			}
		}
		memset( PtrIma->Data, 0, SizeOfImage(PtrIma) );
	} else
	Raise("Out of memory");
    return PtrIma;
}

void DelImage(Image Im)
{
    if (Im) {
		if (Im->Ident) 
			free(Im->Ident);
		free(Im->Data);
		Im->Data = Im->Ident=NULL;
        free(Im);
    }
}

void Raise(char *msg)
{
	mexErrMsgTxt(msg);
}

void Warning(char *msg)
{
	mexWarnMsgTxt(msg);
}
