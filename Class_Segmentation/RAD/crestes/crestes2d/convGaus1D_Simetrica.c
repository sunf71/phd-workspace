//-----------------------------------------------------------------------------------
//	convGaus1D_Simetrica.c
//-----------------------------------------------------------------------------------
//
//	Descripci�: Funcions de convoluci� amb una gaussiana
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


//#include "stdafx.h"
#include "../include/image.h"
#include <math.h>



/* constantes */

#define SOPORTE  3  /* minimo 2 */


/*
   x -> j -> columna
   y -> i -> fila
   z -> k -> plano
*/

/* Macros */


#define longitud_soporte(soporte,sigma,size_celda,w,w1) \
        (w) = (int)((soporte)*(sigma)); \
        (size_celda) = 1 + 2*(w); \
        (w1) = (w) + 1;

#define inicializa_kernel(w,w1,s,G,pG) \
        (G)  = NewImage("Gaus1D",IM_FLOAT,(w1),1,1,1,GRID_RECT); \
        (pG) = ImageF((G)); \
        for(im=(w);im>=0;im--,(pG)++) *(pG) = (0.39894228/s)*exp(-(0.5*im*im)/((s)*(s))); \
        (pG) = ImageF((G)); \

#define inicializa_desplazamientos(w1,d,G,pG) \
        (G)  = NewImage("Desp",IM_LONG,(w1),1,1,1,GRID_RECT); \
        (pG) = ImageL((G)); \
        for(im=0;im<(w1);im++,(pG)++) *(pG) = im*(d); \
        (pG) = ImageL((G)); \

 
Image convGaus1D_Simetrica(Image L,double si,int dir)
{
  Image Out,gi,DF,DP;
  float *pL,*pOut,*pgi,*pgiWi;
  float res,centro,derecha,izquierda;
  int   i,j,k,im,indgi,fils,cols,plns,filsWi,colsWi,plnsWi,sizesopi,Wi,Wi1;
  long  *pDF,*pDP;
  long  offsetplano;

  if(ImType(L)!=IM_FLOAT) Raise("La imagen de entrada ha de ser float.\n");
  if(si<=0)               Raise("La sigma ha de ser un numero mayor que zero\n");
  if((dir<0)||(dir>2))    Raise("La codificacion del parametro de la direccion de convolucion es: 0 -> x (columna), 1 -> y (fila), 2 -> z (plano)");

  fils = ImNLin(L);
  cols = ImNCol(L);
  plns = ImNPlanes(L);

  longitud_soporte(SOPORTE,si,sizesopi,Wi,Wi1);  

  if((dir==0)&&(fils<2*sizesopi+1)) Raise("Numero de filas muy peque�o comparado con sigma.\n");
  if((dir==1)&&(cols<2*sizesopi+1)) Raise("Numero de columnas muy peque�o comparado con sigma.\n");
  if((dir==2)&&(plns<2*sizesopi+1)) Raise("Numero de planos muy peque�o comparado con sigma.\n");
  if((dir==3)&&(plns==1))           Raise("No se puede suavizar en Z (planos) una imagen 2D.\n");

  
  inicializa_kernel(Wi,Wi1,si,gi,pgi); 
  inicializa_desplazamientos(Wi1,cols,DF,pDF);

  if(plns>1){
    offsetplano = fils*cols;
    inicializa_desplazamientos(Wi1,offsetplano,DP,pDP);
  }

  Out = NewImage("convGauss1D_Simetrica",IM_FLOAT,cols,fils,plns,1,GRID_RECT); 

  pOut=ImageF(Out);
  pL=ImageF(L);

  pgiWi=pgi+Wi;
  centro=*pgiWi;

  if(dir==0){ /* por columnas ------------------------------------------------------------------------------------*/

     colsWi=cols-Wi;  

     for(k=0;k<plns;k++) 
        for(i=0;i<fils;i++){

           for(j=0;j<Wi;j++,pOut++,pL++){ /* parte inicial */
           
             res=centro*(*pL);
             for(indgi=1;indgi<Wi1;indgi++){

                if((j-indgi)>=0) izquierda=*(pL-indgi);
                else izquierda=0;

                res=res+(*(pgiWi-indgi))*(izquierda + *(pL+indgi));

             } 
             *pOut=res;
 
           }

           for(j=Wi;j<colsWi;j++,pOut++,pL++){ /* parte central */
           
             res=centro*(*pL);
             for(indgi=1;indgi<Wi1;indgi++) res=res+(*(pgiWi-indgi))*(*(pL-indgi) + *(pL+indgi));
             *pOut=res;
 
           }


           for(j=colsWi;j<cols;j++,pOut++,pL++){ /* parte final */
           
             res=centro*(*pL);
             for(indgi=1;indgi<Wi1;indgi++){

                if((j+indgi)<cols) derecha=*(pL+indgi);
                else derecha=0;

                res=res+(*(pgiWi-indgi))*(*(pL-indgi) + derecha);

             } 
             *pOut=res;
 
           }

        }

  } /* Fin por columnas */
  else if(dir==1){ /* por filas ------------------------------------------------------------------------------------*/

         filsWi=fils-Wi;  

         for(k=0;k<plns;k++){  

            for(i=0;i<Wi;i++) /* parte inicial */
               for(j=0;j<cols;j++,pOut++,pL++){

                  res=centro*(*pL);
                  for(indgi=1;indgi<Wi1;indgi++){
  
                     if((i-indgi)>=0) izquierda=*(pL - *(pDF+indgi));
                     else izquierda=0;
  
                     res=res+(*(pgiWi-indgi))*(izquierda + *(pL + *(pDF+indgi)));

                  } 
                  *pOut=res;

               }

            for(i=Wi;i<filsWi;i++) /* parte central */
               for(j=0;j<cols;j++,pOut++,pL++){

                  res=centro*(*pL);
                  for(indgi=1;indgi<Wi1;indgi++) res=res+(*(pgiWi-indgi))*(*(pL - *(pDF+indgi)) + *(pL + *(pDF+indgi)));
                  *pOut=res;

               }

            for(i=filsWi;i<fils;i++) /* parte final */
               for(j=0;j<cols;j++,pOut++,pL++){

                  res=centro*(*pL);
                  for(indgi=1;indgi<Wi1;indgi++){
  
                     if((i+indgi)<fils) derecha=*(pL + *(pDF+indgi));
                     else derecha=0;
 
                     res=res+(*(pgiWi-indgi))*(*(pL - *(pDF+indgi)) + derecha);

                  } 
                  *pOut=res;

               }

         }

       } /* Fin por filas */
       else{ /* por planos ------------------------------------------------------------------------------------*/

            plnsWi=plns-Wi;  

            for(k=0;k<Wi;k++) /* parte inicial */
               for(i=0;i<fils;i++)
                  for(j=0;j<cols;j++,pOut++,pL++){

                     res=centro*(*pL);
                     for(indgi=1;indgi<Wi1;indgi++){
 
                        if((k-indgi)>=0) izquierda=*(pL - *(pDP+indgi));
                        else izquierda=0;

                        res=res+(*(pgiWi-indgi))*(izquierda + *(pL + *(pDP+indgi)));
 
                    } 
                    *pOut=res;

                  }

            for(k=Wi;k<plnsWi;k++) /* parte central */
               for(i=0;i<fils;i++)
                  for(j=0;j<cols;j++,pOut++,pL++){

                     res=centro*(*pL);
                     for(indgi=1;indgi<Wi1;indgi++) res=res+(*(pgiWi-indgi))*(*(pL - *(pDP+indgi)) + *(pL + *(pDP+indgi)));
                    *pOut=res;

                  }

            for(k=plnsWi;k<plns;k++) /* parte final */
               for(i=0;i<fils;i++)
                  for(j=0;j<cols;j++,pOut++,pL++){

                     res=centro*(*pL);
                     for(indgi=1;indgi<Wi1;indgi++){
 
                        if((k+indgi)<plns) derecha=*(pL + *(pDP+indgi));
                        else derecha=0;

                        res=res+(*(pgiWi-indgi))*(*(pL - *(pDP+indgi)) + derecha);
 
                    } 
                    *pOut=res;

                  }

       } /* Fin por planos */

  DelImage(gi);
  DelImage(DF);
  if(plns>1) DelImage(DP);
 
  return Out;
}




#undef SOPORTE 
#undef longitud_soporte 
#undef inicializa_kernel 
#undef inicializa_desplazamientos
