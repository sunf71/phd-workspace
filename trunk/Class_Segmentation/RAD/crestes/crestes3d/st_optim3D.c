#include "../include/conversioViLiMatlab.h"
#include <math.h>
#include "../include/nrutil.h"
#include "eigensystem.h"



/* constantes */

#define MINDETER 1.0  
#define MINTRAZA 1.0  
#define SOPORTE  3  /* minimo 2 */
#define FACTOR1 85.0 /* 255/3 */
#define FACTOR2 42.5 /* 255/6 */


/* definicion de tipos */

typedef struct{
         float *Lx2,*Ly2,*Lz2,*LxLy,*LxLz,*LyLz;
        } pbufferj ;

typedef struct{
         Image Lx2,Ly2,Lz2,LxLy,LxLz,LyLz;
        } bufferj ;

typedef struct{
         float *Lx2,*Ly2,*Lz2,*LxLy,*LxLz,*LyLz;
        } pbufferi ;

typedef struct{
         Image Lx2,Ly2,Lz2,LxLy,LxLz,LyLz;
        } bufferi ;

typedef struct{
         float *Lx2,*Ly2,*Lz2,*LxLy,*LxLz,*LyLz;
        } pbufferk ;

typedef struct{
         Image Lx2,Ly2,Lz2,LxLy,LxLz,LyLz;
        } bufferk ;

typedef struct{
         Image Lx,Ly,Lz,C;
        } bufferV ;

typedef struct{
         float *Lx,*Ly,*Lz,*C;
        } pbufferV ;

typedef struct{
         Image Lx,Ly,Lz;
        } bufferderivs ;

typedef struct{
         float *Lx,*Ly,*Lz;
        } pbufferderivs ;


/*
   x -> j -> columna
   y -> i -> fila
   z -> k -> plano
*/

/* funciones */

float convolucion_dir_j_o_k(indice_f,pf,pg,w)
int *indice_f;
float *pf,*pg;
int w;
{
 int i,aux1,aux2;
 float res;
 
 res = (*pg)*(*(pf+indice_f[w]));
 pg++;

 
 for(i=1,aux1=w-1,aux2=w+1;i<=w;i++,pg++,aux1--,aux2++) res = res +  (*pg)*( (*(pf+indice_f[aux1])) + (*(pf+indice_f[aux2])) );

 return res;

}


float convolucion_inicial_diri(pf,pg,w,inc_i)
float *pf,*pg;
int w,inc_i;
{
 int i;
 float *pf0,*pf1,*pf2;
 float res;
 
 pf0 = pf + w*inc_i; 
 res = (*pg)*(*pf0);
 pg++;


 for(i=1,pf1=pf0-inc_i,pf2=pf0+inc_i;i<=w;i++,pg++,pf1=pf1-inc_i,pf2=pf2+inc_i) res = res + (*pg)*((*pf1) + (*pf2));

 return res;

}

float convolucion_diri(indice_f,pf,pg,w,inc_i)
int *indice_f;
float *pf,*pg;
int w,inc_i;
{
 int i,aux1,aux2;
 float res;
 
 res = (*pg)*(*(pf+indice_f[w]*inc_i));
 pg++;

 for(i=1,aux1=w-1,aux2=w+1;i<=w;i++,pg++,aux1--,aux2++) 
    res = res +  (*pg)*( (*(pf+indice_f[aux1]*inc_i)) + (*(pf+indice_f[aux2]*inc_i)) );

 return res;

}


Image Imx (int nx,int ny,int nz,int nc,int tg,double xi,double xf)
{
  Image Out;
  register i,j,k,l;
  register float *POut;
  double lx;

  if((nx<1)||(ny<1)||(nz<1)||(nc<1)) Raise("Dimensions error");
  lx = (nx>1 ? (xf-xi)/(nx-1) : 0.0);
  Out = NewImage("Imx",IM_FLOAT,nx,ny,nz,nc,tg);
  POut = ImageF(Out);
  for (l= 0; l < nc; l++)
     for (k= 0; k < nz; k++)
        for (j= 0; j < ny; j++)
           for (i= 0; i < nx ; i++,POut++)
             *POut=(float)(i*lx+xi);
        
  return Out;
}    
/* Macros */


#define longitud_soporte(soporte,sigma,size_celda,w,w1) \
        (w) = (int) ((soporte)*(sigma)); \
        (size_celda) = 1 + 2*(w); \
        (w1) = (w) + 1;

#define inicializa_kernel(w,w1,s,G,pG) \
        (G)  = Imx((w1),1,1,1,GRID_RECT,0,(w)); \
        (pG) = ImageF((G)); \
        for(im=0;im<(w1);im++,(pG)++) \
          *(pG) = (0.39894228/s)*exp(-(0.5*(*(pG))*(*(pG)))/((s)*(s)));

#define inicializa_out(pO,O,f,c,p) \
        pO = ImageF(O); \
        for(km=0;km<(p);km++)    \
           for(im=0;im<(f);im++) \
              for(jm=0;jm<(c);jm++,pO++) \
                 *pO = 0.0;

#define  sumaoffset_derivs(p,offset) \
         ((p).Lx) = ((p).Lx) + (offset); \
         ((p).Ly) = ((p).Ly) + (offset); \
         ((p).Lz) = ((p).Lz) + (offset);

#define sumaoffset(p,offset) \
        ((p).Lx2) = ((p).Lx2) + (offset); \
        ((p).Ly2) = ((p).Ly2) + (offset); \
        ((p).Lz2) = ((p).Lz2) + (offset); \
        ((p).LxLy) = ((p).LxLy) + (offset); \
        ((p).LxLz) = ((p).LxLz) + (offset); \
        ((p).LyLz) = ((p).LyLz) + (offset);

#define  inc_pderivs(p) \
         ((p).Lx)++; \
         ((p).Ly)++; \
         ((p).Lz)++;

#define inc_pbuffers(p) \
        ((p).Lx2)++; \
        ((p).Ly2)++; \
        ((p).Lz2)++; \
        ((p).LxLy)++; \
        ((p).LxLz)++; \
        ((p).LyLz)++;

#define rellena_de_ceros_buffers(pb,f,c,p) \
        for(km=0;km<(p);km++)    \
           for(im=0;im<(f);im++) \
              for(jm=0;jm<(c);jm++) \
              {                     \
                 *((pb).Lx2) = 0.0; \
                 *((pb).Ly2) = 0.0; \
                 *((pb).Lz2) = 0.0; \
                 *((pb).LxLy) = 0.0; \
                 *((pb).LxLz) = 0.0; \
                 *((pb).LyLz) = 0.0; \
                 inc_pbuffers((pb)); \
              }

#define inicializa_pbuffers(b,pb) \
        (pb).Lx2 = ImageF((b).Lx2); \
        (pb).Ly2 = ImageF((b).Ly2); \
        (pb).Lz2 = ImageF((b).Lz2); \
        (pb).LxLy = ImageF((b).LxLy); \
        (pb).LxLz = ImageF((b).LxLz); \
        (pb).LyLz = ImageF((b).LyLz);

#define inicializa_pbuffers_derivs(b,pb) \
        (pb).Lx = ImageF((b).Lx); \
        (pb).Ly = ImageF((b).Ly); \
        (pb).Lz = ImageF((b).Lz);

#define inicializa_pbuffers_V(b,pb) \
        (pb).Lx = ImageF((b).Lx); \
        (pb).Ly = ImageF((b).Ly); \
        (pb).Lz = ImageF((b).Lz); \
        (pb).C  = ImageF((b).C);

#define inicializa_indice(indice,length,ini) \
        for(im=(ini);im<(ini)+length;im++) \
           indice[im-(ini)] = im%length;

#define crea_buffers(f,c,p,b) \
        (b).Lx2 = NewImage("Lx2",IM_FLOAT,(c),(f),(p),1,GRID_RECT); \
        (b).Ly2 = NewImage("Ly2",IM_FLOAT,(c),(f),(p),1,GRID_RECT); \
        (b).Lz2 = NewImage("Lz2",IM_FLOAT,(c),(f),(p),1,GRID_RECT); \
        (b).LxLy = NewImage("LxLy",IM_FLOAT,(c),(f),(p),1,GRID_RECT); \
        (b).LxLz = NewImage("LxLz",IM_FLOAT,(c),(f),(p),1,GRID_RECT); \
        (b).LyLz = NewImage("LyLz",IM_FLOAT,(c),(f),(p),1,GRID_RECT);

#define crea_buffers_V(c,p,b) \
        (b).Lx = NewImage("Lx",IM_FLOAT,3,1,(p),1,GRID_RECT); \
        (b).Ly = NewImage("Ly",IM_FLOAT,(c),3,(p),1,GRID_RECT); \
        (b).Lz = NewImage("Lz",IM_FLOAT,1,1,3,1,GRID_RECT); \
        (b).C  = NewImage("C",IM_FLOAT,(c),3,(p),1,GRID_RECT); 

#define crea_buffers_derivs(f,c,p,b) \
        (b).Lx = NewImage("Lx",IM_FLOAT,(c),(f),(p),1,GRID_RECT); \
        (b).Ly = NewImage("Ly",IM_FLOAT,(c),(f),(p),1,GRID_RECT); \
        (b).Lz = NewImage("Lz",IM_FLOAT,(c),(f),(p),1,GRID_RECT); 
 
#define borra_buffers(b) \
        DelImage(b.Lx2); \
        DelImage(b.LxLy); \
        DelImage(b.LxLz); \
        DelImage(b.Ly2); \
        DelImage(b.LyLz); \
        DelImage(b.Lz2);

#define borra_buffersV(b) \
        DelImage(b.Lx); \
        DelImage(b.Ly); \
        DelImage(b.Lz); \
        DelImage(b.C);

#define borra_buffers_derivs(b) \
        DelImage(b.Lx); \
        DelImage(b.Ly); \
        DelImage(b.Lz);

#define calcula_derivs(pd,pf,ix,iy,iz) \
        *(pd).Lx = (*((pf)+(ix)) - *((pf)-(ix)))/2.0 ; \
        *(pd).Ly = (*((pf)+(iy)) - *((pf)-(iy)))/2.0 ; \
        *(pd).Lz = (*((pf)+(iz)) - *((pf)-(iz)))/2.0 ;

#define asignacion_inicial_buffersj(pd,pb) \
        *(pb).Lx2 = (*(pd).Lx)*(*(pd).Lx); \
        *(pb).Ly2 = (*(pd).Ly)*(*(pd).Ly); \
        *(pb).Lz2 = (*(pd).Lz)*(*(pd).Lz); \
        *(pb).LxLy = (*(pd).Lx)*(*(pd).Ly); \
        *(pb).LxLz = (*(pd).Lx)*(*(pd).Lz); \
        *(pb).LyLz = (*(pd).Ly)*(*(pd).Lz);

#define asigna_valor_buffers_j_o_k(pd,pb,ib,col) \
        *((pb).Lx2 + ib[(col)]) = (*((pd).Lx))*(*((pd).Lx)); \
        *((pb).Ly2 + ib[(col)]) = (*((pd).Ly))*(*((pd).Ly)); \
        *((pb).Lz2 + ib[(col)]) = (*((pd).Lz))*(*((pd).Lz)); \
        *((pb).LxLy + ib[(col)]) = (*((pd).Lx))*(*((pd).Ly)); \
        *((pb).LxLz + ib[(col)]) = (*((pd).Lx))*(*((pd).Lz)); \
        *((pb).LyLz + ib[(col)]) = (*((pd).Ly))*(*((pd).Lz));

#define asigna_ceros_buffers_j_o_k(presult,indice,col) \
        *((presult).Lx2 + indice[(col)]) = 0.0; \
        *((presult).Ly2 + indice[(col)]) = 0.0; \
        *((presult).Lz2 + indice[(col)]) = 0.0; \
        *((presult).LxLy + indice[(col)]) = 0.0; \
        *((presult).LxLz + indice[(col)]) = 0.0; \
        *((presult).LyLz + indice[(col)]) = 0.0;

#define asigna_ceros_buffersi(pb) \
        *((pb).Lx2) = 0.0; \
        *((pb).Ly2) = 0.0; \
        *((pb).Lz2) = 0.0; \
        *((pb).LxLy) = 0.0; \
        *((pb).LxLz) = 0.0; \
        *((pb).LyLz) = 0.0;

#define desplaza_circular(indice,length) \
        auxm = indice[0]; \
        for(im=0;im<(length);im++) indice[im]=indice[im+1]; \
        indice[(length)]=auxm;

#define convolucion_hacia_buffersi(indice_f,pf,pgj,w,presult) \
        *(presult).Lx2 = convolucion_dir_j_o_k((indice_f),(pf).Lx2,(pgj),(w)); \
        *(presult).Ly2 = convolucion_dir_j_o_k((indice_f),(pf).Ly2,(pgj),(w)); \
        *(presult).Lz2 = convolucion_dir_j_o_k((indice_f),(pf).Lz2,(pgj),(w)); \
        *(presult).LxLy = convolucion_dir_j_o_k((indice_f),(pf).LxLy,(pgj),(w)); \
        *(presult).LxLz = convolucion_dir_j_o_k((indice_f),(pf).LxLz,(pgj),(w)); \
        *(presult).LyLz = convolucion_dir_j_o_k((indice_f),(pf).LyLz,(pgj),(w));

#define convolucion_inicial_1_hacia_buffersk(pf,pgi,w,inc_i,presult) \
        *(presult).Lx2 = convolucion_inicial_diri((pf).Lx2,(pgi),(w),(inc_i)); \
        *(presult).Ly2 = convolucion_inicial_diri((pf).Ly2,(pgi),(w),(inc_i)); \
        *(presult).Lz2 = convolucion_inicial_diri((pf).Lz2,(pgi),(w),(inc_i)); \
        *(presult).LxLy = convolucion_inicial_diri((pf).LxLy,(pgi),(w),(inc_i)); \
        *(presult).LxLz = convolucion_inicial_diri((pf).LxLz,(pgi),(w),(inc_i)); \
        *(presult).LyLz = convolucion_inicial_diri((pf).LyLz,(pgi),(w),(inc_i));

#define convolucion_1_hacia_buffersk(indice_f,pf,pgi,w,inc_i,presult) \
        *(presult).Lx2 = convolucion_diri((indice_f),(pf).Lx2,(pgi),(w),(inc_i)); \
        *(presult).Ly2 = convolucion_diri((indice_f),(pf).Ly2,(pgi),(w),(inc_i)); \
        *(presult).Lz2 = convolucion_diri((indice_f),(pf).Lz2,(pgi),(w),(inc_i)); \
        *(presult).LxLy = convolucion_diri((indice_f),(pf).LxLy,(pgi),(w),(inc_i)); \
        *(presult).LxLz = convolucion_diri((indice_f),(pf).LxLz,(pgi),(w),(inc_i)); \
        *(presult).LyLz = convolucion_diri((indice_f),(pf).LyLz,(pgi),(w),(inc_i));

#define convolucion_inicial_2_hacia_buffersk(pf,pgi,w,inc_i,indice,col,presult) \
        *((presult).Lx2 + indice[(col)]) = convolucion_inicial_diri((pf).Lx2,(pgi),(w),(inc_i)); \
        *((presult).Ly2 + indice[(col)]) = convolucion_inicial_diri((pf).Ly2,(pgi),(w),(inc_i)); \
        *((presult).Lz2 + indice[(col)]) = convolucion_inicial_diri((pf).Lz2,(pgi),(w),(inc_i)); \
        *((presult).LxLy + indice[(col)]) = convolucion_inicial_diri((pf).LxLy,(pgi),(w),(inc_i)); \
        *((presult).LxLz + indice[(col)]) = convolucion_inicial_diri((pf).LxLz,(pgi),(w),(inc_i)); \
        *((presult).LyLz + indice[(col)]) = convolucion_inicial_diri((pf).LyLz,(pgi),(w),(inc_i));

#define convolucion_2_hacia_buffersk(indice_f,pf,pgi,w,inc_i,indice,col,presult) \
        *((presult).Lx2 + indice[(col)]) = convolucion_diri((indice_f),(pf).Lx2,(pgi),(w),(inc_i)); \
        *((presult).Ly2 + indice[(col)]) = convolucion_diri((indice_f),(pf).Ly2,(pgi),(w),(inc_i)); \
        *((presult).Lz2 + indice[(col)]) = convolucion_diri((indice_f),(pf).Lz2,(pgi),(w),(inc_i)); \
        *((presult).LxLy + indice[(col)]) = convolucion_diri((indice_f),(pf).LxLy,(pgi),(w),(inc_i)); \
        *((presult).LxLz + indice[(col)]) = convolucion_diri((indice_f),(pf).LxLz,(pgi),(w),(inc_i)); \
        *((presult).LyLz + indice[(col)]) = convolucion_diri((indice_f),(pf).LyLz,(pgi),(w),(inc_i));


#define ultima_convolucion(indice_f,pf,pgk,w,presult) \
        presult[1][1] = convolucion_dir_j_o_k((indice_f),(pf).Lx2,(pgk),(w)); \
        presult[1][2] = convolucion_dir_j_o_k((indice_f),(pf).LxLy,(pgk),(w)); \
        presult[1][3] = convolucion_dir_j_o_k((indice_f),(pf).LxLz,(pgk),(w)); \
        presult[2][1] = presult[1][2]; \
        presult[2][2] = convolucion_dir_j_o_k((indice_f),(pf).Ly2,(pgk),(w)); \
        presult[2][3] = convolucion_dir_j_o_k((indice_f),(pf).LyLz,(pgk),(w)); \
        presult[3][1] = presult[1][3]; \
        presult[3][2] = presult[2][3]; \
        presult[3][3] = convolucion_dir_j_o_k((indice_f),(pf).Lz2,(pgk),(w));


#define calcula_componente_y_de_vep_mayor(vaps,vecps,pb,pd) \
        if( (vaps[1]>=vaps[2])&&(vaps[1]>=vaps[3]) ) auxm=1; /* vaps1 >= vaps2, vaps3 */    \
        else if( (vaps[2]>=vaps[1])&&(vaps[2]>=vaps[3]) ) auxm=2;  /* vaps2 >= vaps1, vaps3 */ \
             else auxm=3; /* vaps3 >= vaps1, vaps2 */ \
        m = sqrt(vecps[1][auxm]*vecps[1][auxm] + vecps[2][auxm]*vecps[2][auxm] + vecps[3][auxm]*vecps[3][auxm]); \
        if(m==0.0) *pb = 0.0; \
        else{ \
             vecps[1][auxm] = vecps[1][auxm]/m; \
             vecps[2][auxm] = vecps[2][auxm]/m; \
             vecps[3][auxm] = vecps[3][auxm]/m; \
             m=vecps[1][auxm]*(*(pd).Lx)+vecps[2][auxm]*(*(pd).Ly)+vecps[3][auxm]*(*(pd).Lz);  \
             if(m==0.0) *pb = 0.0;  \
             else if(m<0.0) *pb = -vecps[2][auxm]; \
                  else *pb = vecps[2][auxm]; \
        }
        

#define ordena_veps_asignando_primero_y_calcula_confidencia(vaps,vecps,offset_x,offset_y,indice_x,indice_y,indice_z,pb,pd,contraste) \
        if( (vaps[1]>=vaps[2])&&(vaps[1]>=vaps[3]) ) auxm=1; /* vaps1 >= vaps2, vaps3 */    \
        else if( (vaps[2]>=vaps[1])&&(vaps[2]>=vaps[3]) ) auxm=2;  /* vaps2 >= vaps1, vaps3 */ \
             else auxm=3; /* vaps3 >= vaps1, vaps2 */ \
        m = sqrt(vecps[1][auxm]*vecps[1][auxm] + vecps[2][auxm]*vecps[2][auxm] + vecps[3][auxm]*vecps[3][auxm]); \
        if(m==0.0){ \
          *((pb).Lx + (offset_x) + indice_x[2]) = 0.0; \
          *((pb).Ly + (offset_y) + indice_y[2]*cols2) = 0.0; \
          *((pb).Lz + indice_z[2]) = 0.0; \
        } \
        else{ \
          vecps[1][auxm] = vecps[1][auxm]/m; \
          vecps[2][auxm] = vecps[2][auxm]/m; \
          vecps[3][auxm] = vecps[3][auxm]/m; \
          m=vecps[1][auxm]*(*(pd).Lx)+vecps[2][auxm]*(*(pd).Ly)+vecps[3][auxm]*(*(pd).Lz);  \
          if(m==0.0){\
            *((pb).Lx + (offset_x) + indice_x[2]) = 0.0; \
            *((pb).Ly + (offset_y) + indice_y[2]*cols2) = 0.0; \
            *((pb).Lz + indice_z[2]) = 0.0; \
          } \
          else{ \
               if(m<0.0){ \
                 vecps[1][auxm]= -vecps[1][auxm]; \
                 vecps[2][auxm]= -vecps[2][auxm]; \
                 vecps[3][auxm]= -vecps[3][auxm]; \
               } \
               *((pb).Lx + (offset_x) + indice_x[2]) = vecps[1][auxm]; \
               *((pb).Ly + (offset_y) + indice_y[2]*cols2) = vecps[2][auxm]; \
               *((pb).Lz + indice_z[2]) = vecps[3][auxm]; \
             } \
        } \
        if(contraste==0.0) *((pb).C + (offset_y) + indice_y[2]*cols2) = 1.0;  \
        else{ \
             dif1 = vaps[1] - vaps[2]; \
             dif2 = vaps[1] - vaps[3]; \
             dif3 = vaps[2] - vaps[3]; \
             *((pb).C + (offset_y) + indice_y[2]*cols2) = 1.0 - exp( (dif1*dif1 + dif2*dif2 + dif3*dif3)/contraste);  \
        }


/*
#define DETERTRAZA \
    deter=(u[1][1]*u[2][2]*u[3][3] + 2*u[1][2]*u[1][3]*u[2][3]) - (u[1][1]*u[2][3]*u[2][3] + u[2][2]*u[1][3]*u[1][3] + u[3][3]*u[1][2]*u[1][2]); \
   traza=u[1][1]+u[2][2]+u[3][3] 
*/

#define DETERTRAZA traza=u[1][1]+u[2][2]+u[3][3]

#define asignacion_por_defecto(offset_x,offset_y,indice_x,indice_y,indice_z,pb,pd,contraste) \
          m=sqrt((*(pd).Lx)*(*(pd).Lx)+(*(pd).Ly)*(*(pd).Ly)+(*(pd).Lz)*(*(pd).Lz));  \
          if(m!=0.0){ \
            *((pb).Lx + (offset_x) + indice_x[2]) = (*(pd).Lx)/m;       \
            *((pb).Ly + (offset_y) + indice_y[2]*cols2) = (*(pd).Ly)/m; \
            *((pb).Lz + indice_z[2]) = (*(pd).Lz)/m;                    \
          } \
          else{ \
            *((pb).Lx + (offset_x) + indice_x[2]) = 0.0;       \
            *((pb).Ly + (offset_y) + indice_y[2]*cols2) = 0.0; \
            *((pb).Lz + indice_z[2]) = 0.0;                    \
          }\
          if(contraste==0.0) *((pb).C + (offset_y) + indice_y[2]*cols2) = 1.0;  \
          else *((pb).C + (offset_y) + indice_y[2]*cols2) = 0.0

#define asignacion_por_defecto_de_componente_y(pb,pd) \
          m=sqrt((*(pd).Lx)*(*(pd).Lx)+(*(pd).Ly)*(*(pd).Ly)+(*(pd).Lz)*(*(pd).Lz));  \
          if(m!=0.0) *pb=(*(pd).Ly)/m; \
          else *pb=0.0



/*****************************************************************************/

Image st_optim3D(Image *Inp, double sigmaD, double sigmaI, double cont)
{

  pbufferj      pbj;
  pbufferi      pbi;
  pbufferk      pbk; 
  pbufferV      pbV; 
  pbufferderivs pbd;
  bufferj        bj;
  bufferi        bi;
  bufferk        bk;
  bufferV        bV;
  bufferderivs   bd;

  Image Out,gi,gj,gk,L;

  float *pL,*pOut,*pgi,*pgj,*pgk,*baseaux1,*baseaux2,*baseaux3,*baseaux4,**u,*w,*e;
  float m,dif1,dif2,dif3,cont2,/*deter,*/traza,CALCULADOS;
  double si,sj,sk,tipo_output;
  int  *ibi,*ibk,*ibj,*ibd,*iVx,*iVy,*iVz; 
  int  fils,cols,plns,fils2,cols2,plns2,
       sizesopi,sizesopj,sizesopk,Wi,Wj,Wk,Wi1,Wj1,Wk1,
       i,j,k,im,jm,km,auxm,calcula_Vx,calcula_Vy,calcula_Vz,
       val_output;

  long offsetplano,offsetaux1,offsetaux2,offsetaux3;
  tipo_output=0;
  val_output=0;
  si=sj=sk=sigmaI;
  L=*Inp;
  
  if(ImType(L)!=IM_FLOAT) Raise("La imagen de entrada ha de ser float.\n");

  if (sigmaD>0) {
  	gi = convGaus1D_Simetrica(L,sigmaD,0);
    DelImage(L);
    gj = convGaus1D_Simetrica(gi,sigmaD,1);
    DelImage(gi);
    L = convGaus1D_Simetrica(gj,sigmaD,2);
    DelImage(gj);
  }    
  *Inp=L;

  fils = ImNLin(L);
  cols = ImNCol(L);
  plns = ImNPlanes(L);

  longitud_soporte(SOPORTE,si,sizesopi,Wi,Wi1);  
  if(fils<2*sizesopi+1) Raise("Numero de filas muy peque�o o sigma muy grande.\n");

  longitud_soporte(SOPORTE,sj,sizesopj,Wj,Wj1);  
  if(cols<2*sizesopj+1) Raise("Numero de columnas muy peque�o o sigma muy grande.\n");

  longitud_soporte(SOPORTE,sk,sizesopk,Wk,Wk1);  
  if(plns<2*sizesopk+1) Raise("Numero de planos muy peque�o o sigma muy grande.\n");


  CALCULADOS=0;

  inicializa_kernel(Wi,Wi1,si,gi,pgi);
  inicializa_kernel(Wj,Wj1,sj,gj,pgj);
  inicializa_kernel(Wk,Wk1,sk,gk,pgk);

  fils2 = fils-2;
  cols2 = cols-2;
  plns2 = plns-2;

  offsetplano = fils*cols;


  crea_buffers(sizesopi,cols2,plns2,bi);
  crea_buffers(1,sizesopj,1,bj);
  crea_buffers(1,1,sizesopk,bk);

  crea_buffers_V(cols2,plns2,bV);
  crea_buffers_derivs(Wi1,cols2,plns2,bd);


  Out = NewImage("st_optim3D",IM_FLOAT,cols,fils,plns,1,GRID_RECT); 


  ibi = ivector(0,sizesopi-1);
  ibj = ivector(0,sizesopj-1);
  ibk = ivector(0,sizesopk-1);
  ibd = ivector(0,Wi);
  iVx = ivector(0,2);
  iVy = ivector(0,2);
  iVz = ivector(0,2);


  /* Parte inicial **************************************************************/

 
  baseaux1 = ImageF(L)+offsetplano+cols+1;
  pL = baseaux1;
  inicializa_pbuffers_derivs(bd,pbd);
  inicializa_pbuffers(bi,pbi);
  rellena_de_ceros_buffers(pbi,sizesopi,cols2,plns2);
  inicializa_pbuffers(bi,pbi);
  sumaoffset(pbi,Wi*cols2);
  pgj=ImageF(gj);


  for(k=0;k<plns2;k++,pL=baseaux1+k*offsetplano){
     for(i=0;i<Wi1;i++,pL=pL+2){
        
        inicializa_pbuffers(bj,pbj);
        rellena_de_ceros_buffers(pbj,1,Wj,1);
        inicializa_pbuffers(bj,pbj);
        sumaoffset(pbj,Wj); 

        for(j=0;j<Wj1;j++,pL++){   
           calcula_derivs(pbd,pL,1,cols,offsetplano);  
           asignacion_inicial_buffersj(pbd,pbj);           
           inc_pderivs(pbd);
           inc_pbuffers(pbj);
        }

        inicializa_pbuffers(bj,pbj);
        inicializa_indice(ibj,sizesopj,0); 

        for(j=0;j<cols2-Wj1;j++,pL++){           
           convolucion_hacia_buffersi(ibj,pbj,pgj,Wj,pbi);    
           desplaza_circular(ibj,sizesopj-1);
           calcula_derivs(pbd,pL,1,cols,offsetplano);
           asigna_valor_buffers_j_o_k(pbd,pbj,ibj,sizesopj-1);
           inc_pderivs(pbd);
           inc_pbuffers(pbi);
        }

        for(j=0;j<Wj1;j++){                
           convolucion_hacia_buffersi(ibj,pbj,pgj,Wj,pbi); 
           desplaza_circular(ibj,sizesopj-1); 
           asigna_ceros_buffers_j_o_k(pbj,ibj,sizesopj-1); 
           inc_pbuffers(pbi); 
        }

      }
     
     sumaoffset(pbi,Wi*cols2); 

   }
   
   u=matrix(1,3,1,3);
   e=vector(1,3);
   w=vector(1,3);

   pgi=ImageF(gi);
   pgk=ImageF(gk);

   for(j=0;j<cols2;j++){

      inicializa_pbuffers_derivs(bd,pbd);
      sumaoffset_derivs(pbd,j); 
      inicializa_pbuffers(bi,pbi);
      sumaoffset(pbi,j); 
      pbV.Ly=ImageF(bV.Ly)+j;

      inicializa_pbuffers(bk,pbk);
      rellena_de_ceros_buffers(pbk,1,1,Wk);
      inicializa_pbuffers(bk,pbk);
      sumaoffset(pbk,Wk); 

      for(k=0;k<Wk1;k++){   
           convolucion_inicial_1_hacia_buffersk(pbi,pgi,Wi,cols2,pbk);  
           sumaoffset(pbi,sizesopi*cols2); 
           inc_pbuffers(pbk);
      }

      inicializa_pbuffers(bk,pbk);
      inicializa_indice(ibk,sizesopk,0); 

      for(k=0;k<plns2-Wk1;k++,pbV.Ly=pbV.Ly+3*cols2){     
         
         ultima_convolucion(ibk,pbk,pgk,Wk,u);
     
         DETERTRAZA;

         if(/*(deter<MINDETER)&&*/(traza<MINTRAZA)){
          asignacion_por_defecto_de_componente_y(pbV.Ly,pbd);
         }
         else{
              CALCULADOS++;
              mitred(u,w,e);    
              tqli(w,e,3,u);
              calcula_componente_y_de_vep_mayor(w,u,pbV.Ly,pbd);
         }

         desplaza_circular(ibk,sizesopk-1);
         convolucion_inicial_2_hacia_buffersk(pbi,pgi,Wi,cols2,ibk,sizesopk-1,pbk);          
         sumaoffset(pbi,sizesopi*cols2); 
         sumaoffset_derivs(pbd,Wi1*cols2); 
         
      }

      for(k=0;k<Wk1;k++,pbV.Ly=pbV.Ly+3*cols2){                
           
         ultima_convolucion(ibk,pbk,pgk,Wk,u);

         DETERTRAZA;

         if(/*(deter<MINDETER)&&*/(traza<MINTRAZA)){
          asignacion_por_defecto_de_componente_y(pbV.Ly,pbd);
         }
         else{
              CALCULADOS++;
              mitred(u,w,e);    
              tqli(w,e,3,u);
              calcula_componente_y_de_vep_mayor(w,u,pbV.Ly,pbd);
         }

         desplaza_circular(ibk,sizesopk-1);
         asigna_ceros_buffers_j_o_k(pbk,ibk,sizesopk-1);          
         sumaoffset_derivs(pbd,Wi1*cols2); 

      } 
   }


  /* Parte central **************************************************************/

   inicializa_out(pOut,Out,fils,cols,plns);   

   cont2 = -2.0*cont*cont;

   baseaux1 = ImageF(L)+offsetplano+(Wi1+1)*cols+1;
   baseaux2 = ImageF(Out)+offsetplano+2*cols+1;
  
   inicializa_pbuffers_V(bV,pbV);

   inicializa_indice(ibd,Wi1,1); 
   inicializa_indice(ibi,sizesopi,1); 

   inicializa_indice(iVy,3,2);
   calcula_Vy = 1;

   for(i=0;i<fils2-Wi1;i++){
      
      baseaux3 = baseaux1+i*cols;

      offsetaux1 = ibi[sizesopi-1]*cols2;
      offsetaux2 = ibd[Wi]*cols2;

      for(k=0;k<plns2;k++){
  
         inicializa_pbuffers_derivs(bd,pbd);
         inicializa_pbuffers(bi,pbi);

         sumaoffset(pbi, offsetaux1 + k*sizesopi*cols2);     
         sumaoffset_derivs(pbd, offsetaux2 + k*Wi1*cols2);         
         pL=baseaux3+k*offsetplano;

         inicializa_pbuffers(bj,pbj);
         rellena_de_ceros_buffers(pbj,1,Wj,1);
         inicializa_pbuffers(bj,pbj);
         sumaoffset(pbj,Wj); 

         for(j=0;j<Wj1;j++,pL++){   
            calcula_derivs(pbd,pL,1,cols,offsetplano);  
            asignacion_inicial_buffersj(pbd,pbj);           
            inc_pderivs(pbd);
            inc_pbuffers(pbj);
         }

         inicializa_pbuffers(bj,pbj);
         inicializa_indice(ibj,sizesopj,0); 

         for(j=0;j<cols2-Wj1;j++,pL++){                
            convolucion_hacia_buffersi(ibj,pbj,pgj,Wj,pbi);
            desplaza_circular(ibj,sizesopj-1);
            calcula_derivs(pbd,pL,1,cols,offsetplano);
            asigna_valor_buffers_j_o_k(pbd,pbj,ibj,sizesopj-1);
            inc_pderivs(pbd);
            inc_pbuffers(pbi);
         }

         for(j=0;j<Wj1;j++){                
            convolucion_hacia_buffersi(ibj,pbj,pgj,Wj,pbi); 
            desplaza_circular(ibj,sizesopj-1); 
            asigna_ceros_buffers_j_o_k(pbj,ibj,sizesopj-1); 
            inc_pbuffers(pbi); 
         }
      }

      inicializa_indice(iVx,3,1); 
      calcula_Vx = 0;

      baseaux4 = baseaux2+i*cols;

      offsetaux3 = ibd[0]*cols2;

      for(j=0;j<cols2;j++){

         inicializa_pbuffers_derivs(bd,pbd);
         sumaoffset_derivs(pbd,offsetaux3+j);
         inicializa_pbuffers(bi,pbi);
         sumaoffset(pbi,j);
         pOut=baseaux4+j;

         inicializa_pbuffers(bk,pbk);
         rellena_de_ceros_buffers(pbk,1,1,Wk);
         inicializa_pbuffers(bk,pbk);
         sumaoffset(pbk,Wk); 

         for(k=0;k<Wk1;k++){   
            convolucion_1_hacia_buffersk(ibi,pbi,pgi,Wi,cols2,pbk);  
            sumaoffset(pbi,sizesopi*cols2); 
            inc_pbuffers(pbk);
         }
         

         inicializa_pbuffers(bk,pbk);
         inicializa_indice(ibk,sizesopk,0); 

         inicializa_indice(iVz,3,1); 
         calcula_Vz = 0;

         for(k=0;k<plns2-Wk1;k++,pOut=pOut+offsetplano){     
         
            ultima_convolucion(ibk,pbk,pgk,Wk,u);

            DETERTRAZA;

            if(/*(deter<MINDETER)&&*/(traza<MINTRAZA)){
              asignacion_por_defecto(3*k,3*k*cols2+j,iVx,iVy,iVz,pbV,pbd,cont2);
            }
            else{
                CALCULADOS++;
                mitred(u,w,e);    
                tqli(w,e,3,u);
                ordena_veps_asignando_primero_y_calcula_confidencia(w,u,3*k,3*k*cols2+j,iVx,iVy,iVz,pbV,pbd,cont2);
            }

            
            desplaza_circular(ibk,sizesopk-1);
            convolucion_2_hacia_buffersk(ibi,pbi,pgi,Wi,cols2,ibk,sizesopk-1,pbk);          

            sumaoffset(pbi,sizesopi*cols2); 
            sumaoffset_derivs(pbd,Wi1*cols2); 
        
            if(calcula_Vz==2) *(pOut - offsetplano) = (*(pOut - offsetplano)) + (*(pbV.Lz + iVz[2]) - *(pbV.Lz + iVz[0])); 
            else calcula_Vz++; 

            if(calcula_Vx==2) *(pOut - 1) = (*(pOut - 1)) + (*(pbV.Lx + 3*k + iVx[2]) - *(pbV.Lx + 3*k + iVx[0])); 

            if(calcula_Vy==2){
              *(pOut - cols) = (*(pOut - cols)) + (*(pbV.Ly + 3*k*cols2 + iVy[2]*cols2 + j) - *(pbV.Ly + 3*k*cols2 + iVy[0]*cols2 + j));
              *(pOut - cols) = (*(pOut - cols)/2.0) * (*(pbV.C + 3*k*cols2 + iVy[1]*cols2 + j));
            }
           
            desplaza_circular(iVz,2); 

         }

         for(k=0;k<Wk1;k++,pOut=pOut+offsetplano){                
           
            ultima_convolucion(ibk,pbk,pgk,Wk,u);

            DETERTRAZA;

            if(/*(deter<MINDETER)&&*/(traza<MINTRAZA)){
              asignacion_por_defecto(3*(k+plns2-Wk-2),3*(k+plns2-Wk-2)*cols2+j,iVx,iVy,iVz,pbV,pbd,cont2);
            }
            else{
                CALCULADOS++;
                mitred(u,w,e);    
                tqli(w,e,3,u);
                ordena_veps_asignando_primero_y_calcula_confidencia(w,u,3*(k+plns2-Wk-2),3*(k+plns2-Wk-2)*cols2+j,iVx,iVy,iVz,pbV,pbd,cont2);
            }

            desplaza_circular(ibk,sizesopk-1);
            asigna_ceros_buffers_j_o_k(pbk,ibk,sizesopk-1);          
            sumaoffset_derivs(pbd,Wi1*cols2); 

            if(calcula_Vz==2) *(pOut - offsetplano) = (*(pOut - offsetplano)) + (*(pbV.Lz + iVz[2]) - *(pbV.Lz + iVz[0])); 
            else calcula_Vz++; 

            if(calcula_Vx==2) *(pOut - 1) = (*(pOut - 1)) + (*(pbV.Lx + 3*(k+plns2-Wk-2) + iVx[2]) - *(pbV.Lx + 3*(k+plns2-Wk-2) + iVx[0])); 

            if(calcula_Vy==2){
              *(pOut - cols) = (*(pOut - cols)) + (*(pbV.Ly + 3*(k+plns2-Wk-2)*cols2 + j + iVy[2]*cols2) - *(pbV.Ly + 3*(k+plns2-Wk-2)*cols2 + iVy[0]*cols2 + j));
              *(pOut - cols) = (*(pOut - cols)/2.0) * (*(pbV.C + 3*(k+plns2-Wk-2)*cols2 + j + iVy[1]*cols2));
            }

            desplaza_circular(iVz,2); 

         }

         if(calcula_Vx<2) calcula_Vx++;

         desplaza_circular(iVx,2);

      }


      if(calcula_Vy<2) calcula_Vy++;

      desplaza_circular(iVy,2);

      desplaza_circular(ibi,sizesopi-1);
      desplaza_circular(ibd,Wi1-1);

   } 

  /* Parte final **************************************************************/


   baseaux2 = ImageF(Out)+offsetplano+(fils2-Wi+1)*cols+1;

   for(i=0;i<Wi;i++){
      
      offsetaux1 = ibi[sizesopi-1]*cols2;

      for(k=0;k<plns2;k++){

         inicializa_pbuffers(bi,pbi);
         sumaoffset(pbi, offsetaux1 + k*sizesopi*cols2);     

         for(j=0;j<cols2;j++){                
            asigna_ceros_buffersi(pbi);
            inc_pbuffers(pbi);
         }

      }

      inicializa_indice(iVx,3,1); 
      calcula_Vx = 0;

      baseaux4 = baseaux2+i*cols;

      offsetaux3 = ibd[0]*cols2;

      for(j=0;j<cols2;j++){

         inicializa_pbuffers_derivs(bd,pbd);
         sumaoffset_derivs(pbd,offsetaux3+j);
         inicializa_pbuffers(bi,pbi);
         sumaoffset(pbi,j);
         pOut=baseaux4+j;

         inicializa_pbuffers(bk,pbk);
         rellena_de_ceros_buffers(pbk,1,1,Wk);
         inicializa_pbuffers(bk,pbk);
         sumaoffset(pbk,Wk); 

         for(k=0;k<Wk1;k++){   
            convolucion_1_hacia_buffersk(ibi,pbi,pgi,Wi,cols2,pbk);  
            sumaoffset(pbi,sizesopi*cols2); 
            inc_pbuffers(pbk);
         }
         

         inicializa_pbuffers(bk,pbk);
         inicializa_indice(ibk,sizesopk,0); 

         inicializa_indice(iVz,3,1); 
         calcula_Vz = 0;

         for(k=0;k<plns2-Wk1;k++,pOut=pOut+offsetplano){     
         
            ultima_convolucion(ibk,pbk,pgk,Wk,u);

            DETERTRAZA;

            if(/*(deter<MINDETER)&&*/(traza<MINTRAZA)){
              asignacion_por_defecto(3*k,3*k*cols2+j,iVx,iVy,iVz,pbV,pbd,cont2);
            }
            else{
                CALCULADOS++;
                mitred(u,w,e);    
                tqli(w,e,3,u);
                ordena_veps_asignando_primero_y_calcula_confidencia(w,u,3*k,3*k*cols2+j,iVx,iVy,iVz,pbV,pbd,cont2);
            }

            desplaza_circular(ibk,sizesopk-1);
            convolucion_2_hacia_buffersk(ibi,pbi,pgi,Wi,cols2,ibk,sizesopk-1,pbk);          
            sumaoffset(pbi,sizesopi*cols2); 
            sumaoffset_derivs(pbd,Wi1*cols2); 
        
            if(calcula_Vz==2) *(pOut - offsetplano) = (*(pOut - offsetplano)) + (*(pbV.Lz + iVz[2]) - *(pbV.Lz + iVz[0])); 
            else calcula_Vz++; 

            if(calcula_Vx==2) *(pOut - 1) = (*(pOut - 1)) + (*(pbV.Lx + 3*k + iVx[2]) - *(pbV.Lx + 3*k + iVx[0])); 

            *(pOut - cols) = (*(pOut - cols)) + (*(pbV.Ly + 3*k*cols2 + iVy[2]*cols2 + j) - *(pbV.Ly + 3*k*cols2 + iVy[0]*cols2 + j));
            *(pOut - cols) = (*(pOut - cols)/2.0) * (*(pbV.C + 3*k*cols2 + iVy[1]*cols2 + j));
            
            desplaza_circular(iVz,2); 

         }

         for(k=0;k<Wk1;k++,pOut=pOut+offsetplano){                
           
            ultima_convolucion(ibk,pbk,pgk,Wk,u);

            DETERTRAZA;

            if(/*(deter<MINDETER)&&*/(traza<MINTRAZA)){
              asignacion_por_defecto(3*(k+plns2-Wk-2),3*(k+plns2-Wk-2)*cols2+j,iVx,iVy,iVz,pbV,pbd,cont2);
            }
            else{
                CALCULADOS++;
                mitred(u,w,e);    
                tqli(w,e,3,u);
                ordena_veps_asignando_primero_y_calcula_confidencia(w,u,3*(k+plns2-Wk-2),3*(k+plns2-Wk-2)*cols2+j,iVx,iVy,iVz,pbV,pbd,cont2);
            }


            desplaza_circular(ibk,sizesopk-1);
            asigna_ceros_buffers_j_o_k(pbk,ibk,sizesopk-1);          
            sumaoffset_derivs(pbd,Wi1*cols2); 

            if(calcula_Vz==2) *(pOut - offsetplano) = (*(pOut - offsetplano)) + (*(pbV.Lz + iVz[2]) - *(pbV.Lz + iVz[0])); 
            else calcula_Vz++; 

            if(calcula_Vx==2) *(pOut - 1) = (*(pOut - 1)) + (*(pbV.Lx + 3*(k+plns2-Wk-2) + iVx[2]) - *(pbV.Lx + 3*(k+plns2-Wk-2) + iVx[0])); 

            *(pOut - cols) = (*(pOut - cols)) + (*(pbV.Ly + 3*(k+plns2-Wk-2)*cols2 + j + iVy[2]*cols2) - *(pbV.Ly + 3*(k+plns2-Wk-2)*cols2 + iVy[0]*cols2 + j));
            *(pOut - cols) = (*(pOut - cols)/2.0) * (*(pbV.C + 3*(k+plns2-Wk-2)*cols2 + j + iVy[1]*cols2));

            desplaza_circular(iVz,2); 

         }

         if(calcula_Vx<2) calcula_Vx++;

         desplaza_circular(iVx,2);

      }

      desplaza_circular(iVy,2);

      desplaza_circular(ibi,sizesopi-1);

   } 

  /* Adecuar al tipo de output solicitado:

      x > 0
   
      'tipo_output' = - x ==> pondra a 'val_output' los valores que sean menores que -x,
                              lo demas a cero.
                              
      'tipo_output' =   x ==> pondra a 'val_output' los valores que sean mayores que x,
                              lo demas a cero.

      'tipo_output' =   0 ==> 'val_output' = 0 ==> salida directa.
                              'val_output' > 0 ==> se conservan los valores mayores que 0 con su valor,
                                                   los demas se ponen a 0. 
                              'val_output' < 0 ==> se conservan los valores menores que 0 con su valor absoluto
                                                   pero pasandolos a positivo, los demas se ponen a 0. 
   */
   


   pOut=ImageF(Out);

   if((tipo_output!=0)||(val_output!=0)){
   
     if(tipo_output<0.0){     
        for(km=0;km<plns;km++)    
           for(im=0;im<fils;im++) 
              for(jm=0;jm<cols;jm++,pOut++) 
                 if((*pOut)<tipo_output) *pOut= (float)val_output;
                 else *pOut=0.0;
     }         
     else if(tipo_output>0.0){
            for(km=0;km<plns;km++)    
               for(im=0;im<fils;im++) 
                  for(jm=0;jm<cols;jm++,pOut++) 
                     if((*pOut)>tipo_output) *pOut= (float)val_output;
                     else *pOut=0.0;
          } 
          else if(val_output>0){ /* tipo_out == 0 */
                 for(km=0;km<plns;km++)    
                    for(im=0;im<fils;im++) 
                       for(jm=0;jm<cols;jm++,pOut++) 
                          if((*pOut)<0) *pOut=0.0;
                          else *pOut = FACTOR1*(*pOut);
               }
               else{ /* tipo_out == 0 y val_output<0 */
                    for(km=0;km<plns;km++)    
                       for(im=0;im<fils;im++) 
                          for(jm=0;jm<cols;jm++,pOut++) 
                             if((*pOut)>=0) *pOut=0.0;
                             else *pOut= -FACTOR1*(*pOut);
               } 
   }
   else{
        for(km=0;km<plns;km++)    
           for(im=0;im<fils;im++) 
              for(jm=0;jm<cols;jm++,pOut++) *pOut = *pOut/3.0;/*FACTOR2*(*pOut + 3);*/
   }
 



   /* poner marco de ceros: de anchura 2 respecto a cada borde, en cada eje */
   
 
   pOut=ImageF(Out);
   
   for(k=0;k<2;k++)
      for(i=0;i<fils;i++)
         for(j=0;j<cols;j++,pOut++) *pOut = 0.0;

   pOut=ImageF(Out)+plns2*offsetplano;
  
   for(k=0;k<2;k++)
      for(i=0;i<fils;i++)
         for(j=0;j<cols;j++,pOut++) *pOut = 0.0;

   pOut=ImageF(Out)+2*offsetplano;

   for(k=2;k<plns2;k++,pOut=pOut+fils2*cols)
      for(i=0;i<2;i++)
         for(j=0;j<cols;j++,pOut++) *pOut = 0.0;

   pOut=ImageF(Out)+2*offsetplano+fils2*cols;

   for(k=2;k<plns2;k++,pOut=pOut+fils2*cols)
      for(i=0;i<2;i++)
         for(j=0;j<cols;j++,pOut++) *pOut = 0.0;

   pOut=ImageF(Out)+2*offsetplano+2*cols;

   for(k=4;k<plns;k++,pOut=pOut+4*cols)
      for(i=2;i<fils2;i++,pOut=pOut+cols2)
         for(j=0;j<2;j++,pOut++) *pOut = 0.0;

   pOut=ImageF(Out)+2*offsetplano+2*cols+cols2;

   for(k=4;k<plns;k++,pOut=pOut+4*cols)
      for(i=2;i<fils2;i++,pOut=pOut+cols2)
         for(j=0;j<2;j++,pOut++) *pOut = 0.0;




   /* Liberar buffers e indices */

   
   borra_buffers(bi);   
   borra_buffers(bj);   
   borra_buffers(bk);     
   borra_buffersV(bV);      
   borra_buffers_derivs(bd);
      
   free_ivector(ibi,0,sizesopi-1);
   free_ivector(ibj,0,sizesopj-1);
   free_ivector(ibk,0,sizesopk-1);
   free_ivector(ibd,0,Wi);
   free_ivector(iVx,0,2);
   free_ivector(iVy,0,2);
   free_ivector(iVz,0,2);

   free_matrix(u,1,3,1,3);
   free_vector(e,1,3);
   free_vector(w,1,3);

   DelImage(gi);
   DelImage(gj);
   DelImage(gk);

   /*printf("\nCALCULADOS:%f\n",CALCULADOS);*/

   return Out;
}





