#include <mex.h>
#include "image.h"

Image Matlab2ViLi(const mxArray *In);
mxArray* ViLi2Matlab(Image In, int setdouble);
void DelImage(Image Im);
Image NewImage(char *Ident,int Type,int NCol,int NLin,int NPlanes,int NChannels,int GridType);
unsigned SizeOfImage(Image PtrIma);
void Raise(char *msg);
void Warning(char *msg);


#define NewTypeIm(IM,Ident) NewImage((Ident), \
                    (IM)->Type, \
                    (int) (IM)->NCol,(int) (IM)->NLin,(int) (IM)->NPlanes, \
                    (int) (IM)->NChannels,(IM)->GridType)
                    
                    
#define EqImType(Im1,Im2) \
    	  ((Im1)->Type==(Im2)->Type &&\
           (Im1)->NCol==(Im2)->NCol &&\
           (Im1)->NLin==(Im2)->NLin &&\
           (Im1)->NPlanes==(Im2)->NPlanes &&\
           (Im1)->NChannels==(Im2)->NChannels &&\
           (Im1)->GridType==(Im2)->GridType)

/*#define SizeOfPixel (type==1?sizeof(char):(type==2?sizeof(short):(type==3?sizeof(long):sizeof(float))))*/
/*#define SizeOfImage (SizeOfPixel*dx*dy*dz)*/
