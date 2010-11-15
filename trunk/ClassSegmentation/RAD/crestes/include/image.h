/*******************************************************************************
 *
 * EXTENSION DEL XLISP PARA EL TRATAMIENTO DE IMAGENES
 * Definici�n de las estructuras de imagen
 * Autor: Francisco Javier S�nchez Pujadas
 * Creaci�n: 31-10-1991
 ******************************************************************************/

#ifndef __IMAGE__
#define __IMAGE__

#ifdef _VILI_IMPLEMENTATION_
#define FUNCTYPE __declspec(dllexport)
#else
#define FUNCTYPE __declspec(dllimport)
#endif

#ifdef _USR_IMPLEMENTATION_
#define USRFUNCTYPE __declspec(dllexport)
#else
#define USRFUNCTYPE __declspec(dllimport)
#endif

/*#include <xllib.h>*/
#define ARGS(A) A

#ifdef __cplusplus
extern "C" {
#endif

typedef struct Image_str {
    char *Ident; /* image identifier */
    int Type; /* image type IMA_BYTE IMA_SHORT IMA_LONG IMA_FLOAT IMA_COMPLEX */
    int NCol; /* number of columns */
    int NLin; /* number of lines */
    int NPlanes; /* number of planes 1=2d image, >1 3d image */
    int NChannels; /* number of channels ex: colour image (RGB) = 3 */
    int GridType; /* GRID_RECT, GRID_HEX */
    void *Data; /* image data */
} *Image;

/* image types ===============================================================*/

#define IM_BYTE    1
#define IM_SHORT   2
#define IM_LONG    3
#define IM_FLOAT   4
#define IM_COMPLEX 5

/* grid types ================================================================*/

#define GRID_RECT     1
#define GRID_HEX      2

/* Tipo byte =================================================================*/

typedef unsigned char Byte;

/* Tipo complejo =============================================================*/

typedef struct Complex {
    float Re,Im; /* parte real y parte imaginaria */
} Complex;

/* access functions ==========================================================*/

/* Los pixels de una imagen se guardan seg�n la siguiente formula:
             SizePixel=sizeof tipo de imagen (char, int, long, float...)
             dir(x,y,z,c)=x+y*ncol+z*(ncol*nlin)+c*(nplanes*ncol*nlin)
*/

/* Macros de acceso a los atributos de la imagen =============================*/

#define ImIdent(Im)     ((Im)->Ident)
#define ImType(Im)      ((Im)->Type)
#define ImNLin(Im)      ((Im)->NLin)
#define ImNCol(Im)      ((Im)->NCol)
#define ImNPlanes(Im)   ((Im)->NPlanes)
#define ImNChannels(Im) ((Im)->NChannels)
#define ImGridType(Im)  ((Im)->GridType)

/* Dimensiones en Pixels de la imagen ========================================*/

#define DimImage(Im)   ((Im)->NChannels*(Im)->NPlanes*(Im)->NLin*(Im)->NCol)
#define DimChannel(Im) ((Im)->NPlanes*(Im)->NLin*(Im)->NCol)
#define DimPlane(Im)   ((Im)->NLin*(Im)->NCol)
#define DimLine(Im)    ((Im)->NCol)

/* Macros de acceso a los pixels de la imagen ================================*/

/* Acceso a imagenes Byte ----------------------------------------------------*/
#define PixelB(Im,X,Y,Z,C) ((Byte*) (Im)->Data+\
            (X)+((Y)+((Z)+(C)*(Im)->NPlanes)*(Im)->NLin)*(Im)->NCol)
#define LineB(Im,Y,Z,C) ((Byte*) (Im)->Data+\
            ((Y)+((Z)+(C)*(Im)->NPlanes)*(Im)->NLin)*(Im)->NCol)
#define PlaneB(Im,Z,C) ((Byte*) (Im)->Data+\
            ((Z)+(C)*(Im)->NPlanes)*(Im)->NLin*(Im)->NCol)
#define ChannelB(Im,C) ((Byte*) (Im)->Data+\
            (C)*(Im)->NPlanes*(Im)->NLin*(Im)->NCol)
#define ImageB(Im) ((Byte *)(Im)->Data)

/* Acceso a imagenes short ---------------------------------------------------*/
#define PixelS(Im,X,Y,Z,C) ((short*) (Im)->Data+\
            (X)+((Y)+((Z)+(C)*(Im)->NPlanes)*(Im)->NLin)*(Im)->NCol)
#define LineS(Im,Y,Z,C) ((short*) (Im)->Data+\
            ((Y)+((Z)+(C)*(Im)->NPlanes)*(Im)->NLin)*(Im)->NCol)
#define PlaneS(Im,Z,C) ((short*) (Im)->Data+\
            ((Z)+(C)*(Im)->NPlanes)*(Im)->NLin*(Im)->NCol)
#define ChannelS(Im,C) ((short*) (Im)->Data+\
            (C)*(Im)->NPlanes*(Im)->NLin*(Im)->NCol)
#define ImageS(Im) ((short *)(Im)->Data)

/* Acceso a imagenes long ---------------------------------------------------*/
#define PixelL(Im,X,Y,Z,C) ((long*) (Im)->Data+\
            (X)+((Y)+((Z)+(C)*(Im)->NPlanes)*(Im)->NLin)*(Im)->NCol)
#define LineL(Im,Y,Z,C) ((long*) (Im)->Data+\
            ((Y)+((Z)+(C)*(Im)->NPlanes)*(Im)->NLin)*(Im)->NCol)
#define PlaneL(Im,Z,C) ((long*) (Im)->Data+\
            ((Z)+(C)*(Im)->NPlanes)*(Im)->NLin*(Im)->NCol)
#define ChannelL(Im,C) ((long*) (Im)->Data+\
            (C)*(Im)->NPlanes*(Im)->NLin*(Im)->NCol)
#define ImageL(Im) ((long *)(Im)->Data)

/* Acceso a imagenes float ---------------------------------------------------*/
#define PixelF(Im,X,Y,Z,C) ((float*) (Im)->Data+\
            (X)+((Y)+((Z)+(C)*(Im)->NPlanes)*(Im)->NLin)*(Im)->NCol)
#define LineF(Im,Y,Z,C) ((float*) (Im)->Data+\
            ((Y)+((Z)+(C)*(Im)->NPlanes)*(Im)->NLin)*(Im)->NCol)
#define PlaneF(Im,Z,C) ((float*) (Im)->Data+\
            ((Z)+(C)*(Im)->NPlanes)*(Im)->NLin*(Im)->NCol)
#define ChannelF(Im,C) ((float*) (Im)->Data+\
            (C)*(Im)->NPlanes*(Im)->NLin*(Im)->NCol)
#define ImageF(Im) ((float *)(Im)->Data)

/* Acceso a imagenes Complex -------------------------------------------------*/
#define PixelC(Im,X,Y,Z,C) ((Complex*) (Im)->Data+\
            (X)+((Y)+((Z)+(C)*(Im)->NPlanes)*(Im)->NLin)*(Im)->NCol)
#define LineC(Im,Y,Z,C) ((Complex*) (Im)->Data+\
            ((Y)+((Z)+(C)*(Im)->NPlanes)*(Im)->NLin)*(Im)->NCol)
#define PlaneC(Im,Z,C) ((Complex*) (Im)->Data+\
            ((Z)+(C)*(Im)->NPlanes)*(Im)->NLin*(Im)->NCol)
#define ChannelC(Im,C) ((Complex*) (Im)->Data+\
            (C)*(Im)->NPlanes*(Im)->NLin*(Im)->NCol)
#define ImageC(Im) ((Complex *)(Im)->Data)

#ifdef __cplusplus
}
#endif

#endif
