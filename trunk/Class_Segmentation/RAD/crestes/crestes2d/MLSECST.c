/*/-----------------------------------------------------------------------------------
//	MLSECST.cpp
//-----------------------------------------------------------------------------------
//
//	Descripci�: Funcions interface CoSeL / OpenCV 
//	Versi�: 1.0
//	Autor/a: Eva Costa (codi de detecci� de crestes d'Antonio L�pez)
//	Data creaci�: 1-06-2004
//
//	Modificacions:
//
//		Data	Tipus_de_modificaci�.
//
//	COPYRIGHT (c) Centre de Visi� per Computador 2004
//	Tots els drets reservats	
//////////////////////////////////////////////////////////////////////////////////////

//#include "stdafx.h"*/
#include "../include/image.h"
#include <stdlib.h>

#include "st_analitico2D.h"
#include "convGaus1D_Simetrica.h"
#include "diffinit2D.h"
#include "../include/conversioViLiMatlab.h"

Image MulIm(Image Op1, Image Op2);

/*/-----------------------------------------------------------------------------------
//	Image MLSECST(	Image imIn, 
//					double sigmaD,
//					double sigmaI,
//					double confianca) 
//-----------------------------------------------------------------------------------
//
//	Funci� de c�lcul de crestes i valls
//			
//	Par�metres:
//
//		Image imIn: imatge d'entrada (ha de ser float)
//		double sigmaD: sigma de la gaussiana de derivaci� 
//		double sigmaI: sigma de la gaussiana d'integraci�
//		double confianca: valor de confian�a
//
//	Retorn:
//
//		Imatge de crestes (float)
//
//	Versi�: 1.0
//	Autor/a: Eva Costa
//	Data creaci�: 1-06-2004
//
//	Modificacions:
//
//		Data		Tipus_de_modificaci�.
/////////////////////////////////////////////////////////////////////////////////////*/


Image MLSECST(	Image imIn, 
				double sigmaD,
				double sigmaI,
				double confianca,
				Image *Deriva,
				Image *OLx,
				Image *OLy) 
{

	/*/ Suavitzaci� de la imatge (sigma de derivaci�)*/
	
	Image tmp=NULL,LxLx,LyLy,LxLy;
	Image imOut;
	Image imInS1;
	Image imInS2;
	Image Lx, Ly;
	
	if (sigmaD>0) {
		imInS1 = convGaus1D_Simetrica(imIn,sigmaD,0);
		imInS2 = convGaus1D_Simetrica(imInS1,sigmaD,1);
	} else imInS2=imIn;
	
	/*/ C�lcul de les derivades en X,Y */
	
	Lx = dfc2D_x(imInS2);
	Ly = dfc2D_y(imInS2);

	DelImage(imInS1);
	if (Deriva) *Deriva = imInS2;
	else if (sigmaD>0) DelImage(imInS2);	

	/*/ C�lcul dels productes punt a punt*/

	LxLx = MulIm(Lx,Lx);
	LyLy = MulIm(Ly,Ly);
	LxLy = MulIm(Lx,Ly);

	/*/ Suavitzaci� de les imatges derivades (sigma d'integraci�)*/
	
/*/	Lx = convGaus1D_Simetrica(Lx,sigmaI,0);
//	Lx = convGaus1D_Simetrica(Lx,sigmaI,1);
	
//	Ly = convGaus1D_Simetrica(Ly,sigmaI,0);
//	Ly = convGaus1D_Simetrica(Ly,sigmaI,1);*/

	tmp=LxLx;
	LxLx = convGaus1D_Simetrica(LxLx,sigmaI,0);
	DelImage(tmp);
	tmp=LxLx;
	LxLx = convGaus1D_Simetrica(LxLx,sigmaI,1);
	DelImage(tmp);

	tmp=LyLy;
	LyLy = convGaus1D_Simetrica(LyLy,sigmaI,0);
	DelImage(tmp);
	tmp=LyLy;
	LyLy = convGaus1D_Simetrica(LyLy,sigmaI,1);
	DelImage(tmp);

	tmp=LxLy;
	LxLy = convGaus1D_Simetrica(LxLy,sigmaI,0);
	DelImage(tmp);
	tmp=LxLy;
	LxLy = convGaus1D_Simetrica(LxLy,sigmaI,1);
	DelImage(tmp);

	/*/ C�lcul de les crestes*/


	imOut = st_analitico2D(Lx,Ly,LxLx,LyLy,LxLy,confianca,ImNLin(imIn),ImNCol(imIn));

	if (OLx) *OLx=Lx;
	else DelImage(Lx);
	if (OLy) *OLy=Ly;
	else DelImage(Ly);
	DelImage(LxLx);
	DelImage(LyLy);
	DelImage(LxLy);

    return imOut;
}


/* Producto imagenes =========================================================*/

Image MulIm(Image Op1, Image Op2)
{
    Image Out;
    register int NPix;

    if (!EqImType(Op1,Op2)) Raise("Type image error");
    NPix=DimImage(Op1);
    Out=NewTypeIm(Op1,"*");
    switch (ImType(Op1)) {
        case IM_BYTE: {
            register Byte *POp1, *POp2, *POut;

            POp1=ImageB(Op1);
            POp2=ImageB(Op2);
            POut=ImageB(Out);
            for (; NPix>0; --NPix) *POut++ = *POp1++ * *POp2++;
            break;
        }
        case IM_SHORT: {
            register short *POp1, *POp2, *POut;

            POp1=ImageS(Op1);
            POp2=ImageS(Op2);
            POut=ImageS(Out);
            for (; NPix>0; --NPix) *POut++ = *POp1++ * *POp2++;
            break;
        }
        case IM_LONG: {
            register long *POp1, *POp2, *POut;

            POp1=ImageL(Op1);
            POp2=ImageL(Op2);
            POut=ImageL(Out);
            for (; NPix>0; --NPix) *POut++ = *POp1++ * *POp2++;
            break;
        }
        case IM_FLOAT: {
            register float *POp1, *POp2, *POut;

            POp1=ImageF(Op1);
            POp2=ImageF(Op2);
            POut=ImageF(Out);
            for (; NPix>0; --NPix) *POut++ = *POp1++ * *POp2++;
            break;
        }
        case IM_COMPLEX: {
            register Complex *POp1, *POp2, *POut;

            POp1=ImageC(Op1);
            POp2=ImageC(Op2);
            POut=ImageC(Out);
            for (; NPix>0; --NPix)
            {
                 POut->Re = POp1->Re * POp2->Re - POp1->Im * POp2->Im;
                 POut->Im = POp1->Im * POp2->Re + POp2->Im * POp1->Re;
                 POp1++;POp2++;POut++;
            }
            break;
        }

        default:
            DelImage(Out);
            Raise("Type image error");
    }
    return Out;
}

