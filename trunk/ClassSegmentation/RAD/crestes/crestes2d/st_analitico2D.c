/*/-----------------------------------------------------------------------------------
//	st_analitico2D.c
//-----------------------------------------------------------------------------------
//
//	Descripci�: Funcions de detecci� de crestes i valls
//	Versi�: 1.0
//	Autor/a: Antonio L�pez 
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
#include <math.h>
#include "../include/nrutil.h"



/********************************************************************

*********************************************************************/

#define DIVER                                             \
        *pout=((U1[centro][j-1] + U2[anterior][j]) -     \
               (U1[centro][j+1] + U2[posterior][j])      \
              )*(-0.25)*CONFIDENCIA[centro][j]
/*              )*(-0.25)*CONFIDENCIA[centro][j]*/

#define CALCULO(I,J)                                                  \
                                                                      \
        if(*lxy!=0){                                                  \
          aux1     = *lxx - *lyy;                                     \
          difvaps2 = aux1*aux1 + 4*(*lxy)*(*lxy);                     \
          aux2     = sqrt(difvaps2);                                  \
                                                                      \
          U1[I][J] = ( (aux1+aux2) / (2.0*(*lxy)) );                  \
          U2[I][J] = 1.0;                                             \
                                                                      \
          m = sqrt(U1[I][J]*U1[I][J] + 1.0);                          \
                                                                      \
          U1[I][J]=U1[I][J]/m;                                        \
          U2[I][J]=1.0/m;                                             \
                                                                      \
          m=(*lx)*U1[I][J]+(*ly)*U2[I][J];                            \
                                                                      \
          if(m==0.0){                                                 \
            U1[I][J]=0.0;                                             \
            U2[I][J]=0.0;                                             \
          }                                                           \
          else if(m<0.0){                                             \
                 U1[I][J] = -U1[I][J];                                \
                 U2[I][J] = -U2[I][J];                                \
               }                                                      \
        }                                                             \
        else /* la matriz ya es diagonal */                           \
            if((*lxx==0)&&(*lyy==0)){                                 \
              U1[I][J]=0;                                             \
              U2[I][J]=0;                                             \
              difvaps2=0;                                             \
            }                                                         \
            else if(*lxx>*lyy){                                       \
                   if(*lx==0) U1[I][J]=0;                             \
                   else if(*lx<0) U1[I][J]=-1;                        \
                        else U1[I][J]=1;                              \
                   U2[I][J]=0;                                        \
                   difvaps2=(*lxx)-(*lyy);                            \
                   difvaps2=difvaps2*difvaps2;                        \
                 }                                                    \
                 else{                                                \
                      U1[I][J]=0;                                     \
                      if(*ly==0) U2[I][J]=0;                          \
                      else if(*ly<0) U2[I][J]=-1;                     \
                           else U2[I][J]=1;                           \
                      difvaps2=(*lxx)-(*lyy);                         \
                      difvaps2=difvaps2*difvaps2;                     \
                     }                                                \
                                                                      \
        if(cont2==0.0) CONFIDENCIA[I][J] = 1.0;                       \
        else CONFIDENCIA[I][J] = 1.0 - exp(difvaps2/cont2);           \



Image st_analitico2D(Image Lx,Image Ly,Image Lxx,Image Lyy,Image Lxy,double contraste,int fils, int cols)
{
 int i,j,centro,anterior,posterior,swap;
 Image Out;
 register float *pout,*lx,*ly,*lxx,*lyy,*lxy,**U1,**U2,**CONFIDENCIA; 
 float cont2,aux1,aux2,difvaps2,m; 

    Out = NewImage("st_analitico2D",IM_FLOAT,cols,fils,1,1,GRID_RECT); 

    pout = ImageF(Out);
    lx   = ImageF(Lx); 
    ly   = ImageF(Ly); 
    lxx  = ImageF(Lxx); 
    lyy  = ImageF(Lyy); 
    lxy  = ImageF(Lxy); 


    U1 = matrix(0,2,0,cols-1);
    U2 = matrix(0,2,0,cols-1);
    CONFIDENCIA = matrix(0,2,0,cols-1);

    cont2 = -2.0*contraste*contraste;


    /* inicializacion de buffers */

    
    for(i=0;i<fils;i++) 
       for(j=0;j<cols;j++,pout++) *pout = 0.0;

    for(i=0;i<3;i++) 
       for(j=0;j<cols;j++,lx++,ly++,lxx++,lyy++,lxy++){ CALCULO(i,j) }

    /* calculos */

    pout = ImageF(Out)+cols+1;

    anterior  = 0;
    centro    = 1;
    posterior = 2;


    for(i=3;i<fils;i++,pout+=2){
 
       for(j=1;j<cols-1;j++,pout++) DIVER;
           
       swap=anterior;
       anterior=centro;
       centro=posterior;
       posterior=swap;

       for(j=0;j<cols;j++,lx++,ly++,lxx++,lyy++,lxy++){ CALCULO(posterior,j) }
    }
       
    for(j=1;j<cols-1;j++,pout++) DIVER;

    free_matrix(U1,0,2,0,cols-1);
    free_matrix(U2,0,2,0,cols-1);
    free_matrix(CONFIDENCIA,0,2,0,cols-1);

    return Out;
}


