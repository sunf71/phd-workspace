/*/-----------------------------------------------------------------------------------
//	diffinit2D.c
//-----------------------------------------------------------------------------------
//
//	Descripci�: Funcions de c�lcul de difer�ncia finites
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
#include "../include/conversioViLiMatlab.h"


#define INI \
        for(i=0;i<fils;i++) \
           for(j=0;j<cols;j++,pout++) *pout = 0 


/********************************************************************


   Dado el campo scalar bidimensional L, se calculan primeras 
   diferencias finitas segun distintos esquemas:

   a) Aproximando el operador de derivada por diferencias
   finitas centradas:

            Dx(L[i,j]) := (L[i,j+1] - L[i,j-1])/2      a.1)
            Dy(L[i,j]) := (L[i+1,j] - L[i-1,j])/2      a.2)

      --> La formula a.1) solo se puede aplicar en  "SI"

             0   1   ....  n-1        n := cols
           +---+---+-....-+---+       m := fils
         0 |   |          |   |
           +   +          +   +
         1 |   |          |   |       
           +   +          +   +           
           | NO|    SI    | NO|          
           :   :          :   :         
           :   :          :   :            
           +   +          +   +           
       m-1 |   |          |   |
           +---+---+.....-+---+     

       el resto se deja a cero.

     --> La formula a.2) solo se puede aplicar en  "SI"

             0   1   ....  n-1        n := cols
           +---+---+-....-+---+       m := fils
         0 |        NO        |
           +---+---+-....-+---+
         1 |                  |
           +                  +
           |        SI        |
           :                  :
           :                  :
           +---+---+-....-+---+
       m-1 |        NO        |
           +---+---+.....-+---+     

       el resto se deja a cero.

   b) Aproximando el operador de derivada por diferencias
   finitas hacia delante:
   
            Dx(L[i,j]) := L[i,j+1] - L[i,j]     b.1)
            Dy(L[i,j]) := L[i+1,j] - L[i,j]     b.2)

      --> La formula b.1) solo se puede aplicar en  "SI"

             0   1   ....  n-1        n := cols
           +---+---+-....-+---+       m := fils
         0 |              |   |
           +              +   +
         1 |              |   |
           +              +   +
           |     SI       | NO|
           :              :   :
           :              :   :
           +              +   +
       m-1 |              |   |
           +---+---+.....-+---+     

       el resto se deja a cero.

     --> La formula b.2) solo se puede aplicar en  "SI"

             0   1   ....  n-1        n := cols
           +---+---+-....-+---+       m := fils
         0 |                  |
           +                  +
         1 |                  |
           +                  +
           |        SI        |
           :                  :
           :                  :
           +---+---+-....-+---+
       m-1 |        NO        |
           +---+---+.....-+---+     

       el resto se deja a cero.


   c) Aproximando el operador de derivada por diferencias
   finitas hacia atras:

            Dx(L[i,j]) := L[i,j] - L[i,j-1]      c.1)
            Dy(L[i,j]) := L[i,j] - L[i-1,j]      c.2)

      --> La formula c.1) solo se puede aplicar en  "SI"

             0   1   ....  n-1        n := cols
           +---+---+-....-+---+       m := fils
         0 |   |              |
           +   +              +
         1 |   |              |       
           +   +              +           
           | NO|    SI        |          
           :   :              :         
           :   :              :            
           +   +              +           
       m-1 |   |              |
           +---+---+.....-+---+     

       el resto se deja a cero.

     --> La formula c.2) solo se puede aplicar en  "SI"

             0   1   ....  n-1        n := cols
           +---+---+-....-+---+       m := fils
         0 |        NO        |
           +---+---+-....-+---+
         1 |                  |
           +                  +
           |        SI        |
           :                  :
           :                  :
           +                  +
       m-1 |                  |
           +---+---+.....-+---+     

       el resto se deja a cero.

*********************************************************************/



/* diferencias centradas de L en la direccion X */

#define DFCX \
        for(i=0;i<fils;i++,pout+=2,pl+=2) \
           for(j=1;j<cols-1;j++,pout++,pl++) \
              *pout = ( *(pl+1) - *(pl-1) )/2


Image dfc2D_x(Image L)
{
 int i,j,cols,fils,imtype;
 Image Out;
 register float *pout;

    fils = ImNLin(L);
    cols = ImNCol(L);
    imtype = ImType(L);
  
    Out = NewImage("dfc2D_x",IM_FLOAT,cols,fils,1,1,GRID_RECT); 

    pout = ImageF(Out);
    INI;
    pout = ImageF(Out)+1;
  
    switch(imtype){                   
        case IM_BYTE: {               
            register Byte *pl;        
            pl = ImageB(L)+1;  
            DFCX;
            break;                    
        }                             
        case IM_SHORT: {              
            register short *pl;       
            pl = ImageS(L)+1;  
            DFCX;
            break;                    
        }                             
        case IM_LONG: {               
            register long *pl;        
            pl = ImageL(L)+1;  
            DFCX;
            break;                    
        }                             
        case IM_FLOAT: {              
            register float *pl;       
            pl = ImageF(L)+1;  
            DFCX;
            break;                    
        }                             
        default: {                    
            DelImage(Out);            
            Raise("Type image error");         
        }                             
    }

    return Out;
}


/* diferencias centradas de L en la direccion Y */

#define DFCY \
    for(i=1;i<fils-1;i++) \
       for(j=0;j<cols;j++,pout++,pl++) \
          *pout = ( *(pl+cols) - *(pl-cols) )/2

Image dfc2D_y(Image L)
{
 int i,j,cols,fils,imtype;
 Image Out;
 register float *pout; 

    fils = ImNLin(L);
    cols = ImNCol(L);
    imtype = ImType(L);
  
    Out = NewImage("dfc2D_y",IM_FLOAT,cols,fils,1,1,GRID_RECT); 

    pout = ImageF(Out);
    INI;
    pout = ImageF(Out)+cols;

    switch(imtype){                   
        case IM_BYTE: {               
            register Byte *pl;        
            pl = ImageB(L)+cols;  
            DFCY;
            break;                    
        }                             
        case IM_SHORT: {              
            register short *pl;       
            pl = ImageS(L)+cols;  
            DFCY;
            break;                    
        }                             
        case IM_LONG: {               
            register long *pl;        
            pl = ImageL(L)+cols;  
            DFCY;
            break;                    
        }                             
        case IM_FLOAT: {              
            register float *pl;       
            pl = ImageF(L)+cols;  
            DFCY;
            break;                    
        }                             
        default: {                    
            DelImage(Out);            
            Raise("Type image error");         
        }                             
    }

    return Out;
}



/* diferencias hacia delante de L en la direccion X */

#define DFFX \
        for(i=0;i<fils;i++,pout++,pl++) \
           for(j=0;j<cols-1;j++,pout++,pl++) \
              *pout = ( *(pl+1) - *pl )


Image dff2D_x(Image L)
{
 int i,j,cols,fils,imtype;
 Image Out;
 register float *pout;

    fils = ImNLin(L);
    cols = ImNCol(L);
    imtype = ImType(L);
  
    Out = NewImage("dff2D_x",IM_FLOAT,cols,fils,1,1,GRID_RECT); 

    pout = ImageF(Out);
    INI;
    pout = ImageF(Out);
  
    switch(imtype){                   
        case IM_BYTE: {               
            register Byte *pl;        
            pl = ImageB(L);  
            DFFX;
            break;                    
        }                             
        case IM_SHORT: {              
            register short *pl;       
            pl = ImageS(L);  
            DFFX;
            break;                    
        }                             
        case IM_LONG: {               
            register long *pl;        
            pl = ImageL(L);  
            DFFX;
            break;                    
        }                             
        case IM_FLOAT: {              
            register float *pl;       
            pl = ImageF(L);  
            DFFX;
            break;                    
        }                             
        default: {                    
            DelImage(Out);            
            Raise("Type image error");         
        }                             
    }

    return Out;
}


/* diferencias hacia delante de L en la direccion Y */

#define DFFY \
    for(i=0;i<fils-1;i++) \
       for(j=0;j<cols;j++,pout++,pl++) \
          *pout = ( *(pl+cols) - *pl )

Image dff2D_y(Image L)
{
 int i,j,cols,fils,imtype;
 Image Out;
 register float *pout; 

    fils = ImNLin(L);
    cols = ImNCol(L);
    imtype = ImType(L);
  
    Out = NewImage("dff2D_y",IM_FLOAT,cols,fils,1,1,GRID_RECT); 

    pout = ImageF(Out);
    INI;
    pout = ImageF(Out);

    switch(imtype){                   
        case IM_BYTE: {               
            register Byte *pl;        
            pl = ImageB(L);  
            DFFY;
            break;                    
        }                             
        case IM_SHORT: {              
            register short *pl;       
            pl = ImageS(L);  
            DFFY;
            break;                    
        }                             
        case IM_LONG: {               
            register long *pl;        
            pl = ImageL(L);  
            DFFY;
            break;                    
        }                             
        case IM_FLOAT: {              
            register float *pl;       
            pl = ImageF(L);  
            DFFY;
            break;                    
        }                             
        default: {                    
            DelImage(Out);            
            Raise("Type image error");         
        }                             
    }

    return Out;
}

/* diferencias hacia atras de L en la direccion X */

#define DFBX \
        for(i=0;i<fils;i++,pout++,pl++) \
           for(j=1;j<cols;j++,pout++,pl++) \
              *pout = ( *pl - *(pl-1) )


Image dfb2D_x(Image L)
{
 int i,j,cols,fils,imtype;
 Image Out;
 register float *pout;

    fils = ImNLin(L);
    cols = ImNCol(L);
    imtype = ImType(L);
  
    Out = NewImage("dfb2D_x",IM_FLOAT,cols,fils,1,1,GRID_RECT); 

    pout = ImageF(Out);
    INI;
    pout = ImageF(Out)+1;
  
    switch(imtype){                   
        case IM_BYTE: {               
            register Byte *pl;        
            pl = ImageB(L)+1;  
            DFBX;
            break;                    
        }                             
        case IM_SHORT: {              
            register short *pl;       
            pl = ImageS(L)+1;  
            DFBX;
            break;                    
        }                             
        case IM_LONG: {               
            register long *pl;        
            pl = ImageL(L)+1;  
            DFBX;
            break;                    
        }                             
        case IM_FLOAT: {              
            register float *pl;       
            pl = ImageF(L)+1;  
            DFBX;
            break;                    
        }                             
        default: {                    
            DelImage(Out);            
            Raise("Type image error");         
        }                             
    }

    return Out;
}


/* diferencias hacia atras de L en la direccion Y */

#define DFBY \
    for(i=1;i<fils;i++) \
       for(j=0;j<cols;j++,pout++,pl++) \
          *pout = ( *pl - *(pl-cols) )

Image dfb2D_y(Image L)
{
 int i,j,cols,fils,imtype;
 Image Out;
 register float *pout; 

    fils = ImNLin(L);
    cols = ImNCol(L);
    imtype = ImType(L);
  
    Out = NewImage("dfb2D_y",IM_FLOAT,cols,fils,1,1,GRID_RECT); 

    pout = ImageF(Out);
    INI;
    pout = ImageF(Out)+cols;

    switch(imtype){                   
        case IM_BYTE: {               
            register Byte *pl;        
            pl = ImageB(L)+cols;  
            DFBY;
            break;                    
        }                             
        case IM_SHORT: {              
            register short *pl;       
            pl = ImageS(L)+cols;  
            DFBY;
            break;                    
        }                             
        case IM_LONG: {               
            register long *pl;        
            pl = ImageL(L)+cols;  
            DFBY;
            break;                    
        }                             
        case IM_FLOAT: {              
            register float *pl;       
            pl = ImageF(L)+cols;  
            DFBY;
            break;                    
        }                             
        default: {                    
            DelImage(Out);            
            Raise("Type image error");         
        }                             
    }

    return Out;
}

/********************************************************************


   Dado el campo scalar bidimensional L, se calculan segundas 
   diferencias finitas segun distintos esquemas:

   a) Aproximando el operador de derivada por diferencias
   finitas centradas:

   Dxx(L[i,j]) := (L[i,j+2] - 2 L[i,j] + L[i,j-2])/4                         a.1)
   Dyy(L[i,j]) := (L[i+2,j] - 2 L[i,j] + L[i-2,j])/4                         a.2)
   Dxy(L[i,j]) := ((L[i+1,j+1] + L[i-1,j-1]) - (L[i-1,j+1] + L[i+1,j-1]))/4  a.3)

      --> La formula a.1) solo se puede aplicar en  "SI"

             0   1   2  ....   n-2 n-1        n := cols
           +---+---+---+....--+---+---+       m := fils
         0 |       |          |       |
           +       +          +       +
         1 |       |          |       |       
           +       +          +       +         
           | NO    |    SI    |  NO   |        
           :       :          :       :         
           :       :          :       :            
           +       +          +       +           
       m-1 |       |          |       |
           +---+---+---+.....-+---+---+     

       el resto se deja a cero.

     --> La formula a.2) solo se puede aplicar en  "SI"

             0   1   ....  n-1        n := cols
           +---+---+-....-+---+       m := fils
         0 |                  |
           +        NO        +
         1 |                  |
           +---+---+-....-+---+
           +                  +
           |        SI        |
           :                  :
           :                  :
           +---+---+-....-+---+
       m-2 |                  |
           +        NO        +
       m-1 |                  |
           +---+---+.....-+---+     

       el resto se deja a cero.

     --> La formula a.3) solo se puede aplicar en  "SI"

             0   1   ....  n-1        n := cols
           +---+---+-....-+---+       m := fils
         0 |        NO        |
           +   +---+-....-+   +
         1 |   |          |   |
           +   +          +   +
           | NO|    SI    | NO|
           :   :          :   :
           :   :          :   :
           +   +---+-....-+   +
       m-1 |        NO        |
           +---+---+.....-+---+     

       el resto se deja a cero.

*********************************************************************/



/* segundas diferencias centradas de L en la direccion X */

#define DFCXX \
        for(i=0;i<fils;i++,pout+=4,pl+=4) \
           for(j=2;j<cols-2;j++,pout++,pl++) \
              *pout = ( *(pl+2) + *(pl-2) - *(pl)*2  )/4


Image dfc2D_xx(Image L)
{
 int i,j,cols,fils,imtype;
 Image Out;
 register float *pout;

    fils = ImNLin(L);
    cols = ImNCol(L);
    imtype = ImType(L);
  
    Out = NewImage("dfc2D_xx",IM_FLOAT,cols,fils,1,1,GRID_RECT); 

    pout = ImageF(Out);
    INI;
    pout = ImageF(Out)+2;
  
    switch(imtype){                   
        case IM_BYTE: {               
            register Byte *pl;        
            pl = ImageB(L)+2;  
            DFCXX;
            break;                    
        }                             
        case IM_SHORT: {              
            register short *pl;       
            pl = ImageS(L)+2;  
            DFCXX;
            break;                    
        }                             
        case IM_LONG: {               
            register long *pl;        
            pl = ImageL(L)+2;  
            DFCXX;
            break;                    
        }                             
        case IM_FLOAT: {              
            register float *pl;       
            pl = ImageF(L)+2;  
            DFCXX;
            break;                    
        }                             
        default: {                    
            DelImage(Out);            
            Raise("Type image error");         
        }                             
    }

    return Out;
}


/* segundas diferencias centradas de L en la direccion Y */

#define DFCYY \
    for(i=2;i<fils-2;i++) \
       for(j=0;j<cols;j++,pout++,pl++) \
          *pout = ( *(pl+cols*2) + *(pl-cols*2) - *(pl)*2 )/4

Image dfc2D_yy(Image L)
{
 int i,j,cols,fils,imtype;
 Image Out;
 register float *pout; 

    fils = ImNLin(L);
    cols = ImNCol(L);
    imtype = ImType(L);
  
    Out = NewImage("dfc2D_yy",IM_FLOAT,cols,fils,1,1,GRID_RECT); 

    pout = ImageF(Out);
    INI;
    pout = ImageF(Out)+cols*2;

    switch(imtype){                   
        case IM_BYTE: {               
            register Byte *pl;        
            pl = ImageB(L)+cols*2;  
            DFCYY;
            break;                    
        }                             
        case IM_SHORT: {              
            register short *pl;       
            pl = ImageS(L)+cols*2;  
            DFCYY;
            break;                    
        }                             
        case IM_LONG: {               
            register long *pl;        
            pl = ImageL(L)+cols*2;  
            DFCYY;
            break;                    
        }                             
        case IM_FLOAT: {              
            register float *pl;       
            pl = ImageF(L)+cols*2;  
            DFCYY;
            break;                    
        }                             
        default: {                    
            DelImage(Out);            
            Raise("Type image error");         
        }                             
    }

    return Out;
}



/* segundas diferencias centradas de L en la direccion cruzada XY */

#define DFCXY \
    for(i=1;i<fils-1;i++,pout+=2,pl+=2) \
       for(j=1;j<cols-1;j++,pout++,pl++) \
          *pout = ( (*(pl+cols+1) + *(pl-cols-1)) - (*(pl+cols-1) + *(pl-cols+1)) )/4

Image dfc2D_xy(Image L)
{
 int i,j,cols,fils,imtype;
 Image Out;
 register float *pout; 

    fils = ImNLin(L);
    cols = ImNCol(L);
    imtype = ImType(L);
  
    Out = NewImage("dfc2D_xy",IM_FLOAT,cols,fils,1,1,GRID_RECT); 

    pout = ImageF(Out);
    INI;
    pout = ImageF(Out)+cols+1;

    switch(imtype){                   
        case IM_BYTE: {               
            register Byte *pl;        
            pl = ImageB(L)+cols+1;  
            DFCXY;
            break;                    
        }                             
        case IM_SHORT: {              
            register short *pl;       
            pl = ImageS(L)+cols+1;  
            DFCXY;
            break;                    
        }                             
        case IM_LONG: {               
            register long *pl;        
            pl = ImageL(L)+cols+1;  
            DFCXY;
            break;                    
        }                             
        case IM_FLOAT: {              
            register float *pl;       
            pl = ImageF(L)+cols+1;  
            DFCXY;
            break;                    
        }                             
        default: {                    
            DelImage(Out);            
            Raise("Type image error");         
        }                             
    }

    return Out;
}
