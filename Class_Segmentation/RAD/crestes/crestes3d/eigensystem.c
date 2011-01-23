 #include <math.h>

#define SIGN(a,b) ((b)<0 ? -fabs(a) : fabs(a))

void tqli(d,e,n,z)
float d[],e[],**z;
int n;
{
	int m,l,iter,i,k;
	float s,r,p,g,f,dd,c,b;
	void nrerror();

	for (i=2;i<=n;i++) e[i-1]=e[i];
	e[n]=0.0;
	for (l=1;l<=n;l++) {
		iter=0;
		do {
			for (m=l;m<=n-1;m++) {
				dd=fabs(d[m])+fabs(d[m+1]);
				if ((float)(fabs(e[m])+dd) == dd) break;
			}
			if (m != l) {
				if (iter++ == 30) nrerror("Too many iterations in TQLI");
				g=(d[l+1]-d[l])/(2.0*e[l]);
				r=sqrt((g*g)+1.0);
				g=d[m]-d[l]+e[l]/(g+SIGN(r,g));
				s=c=1.0;
				p=0.0;
				for (i=m-1;i>=l;i--) {
					f=s*e[i];
					b=c*e[i];
					if (fabs(f) >= fabs(g)) {
						c=g/f;
						r=sqrt((c*c)+1.0);
						e[i+1]=f*r;
						c *= (s=1.0/r);
					} else {
						s=f/g;
						r=sqrt((s*s)+1.0);
						e[i+1]=g*r;
						s *= (c=1.0/r);
					}
					g=d[i+1]-p;
					r=(d[i]-g)*s+2.0*c*b;
					p=s*r;
					d[i+1]=g+p;
					g=c*r-b;
					/* Next loop can be omitted if eigenvectors not wanted */
					for (k=1;k<=n;k++) {
						f=z[k][i+1];
						z[k][i+1]=s*z[k][i]+c*f;
						z[k][i]=c*z[k][i]-s*f;
					}
				}
				d[l]=d[l]-p;
				e[l]=g;
				e[m]=0.0;
			}
		} while (m != l);
	}
}

void tred2(a,n,d,e)
float **a,d[],e[];
int n;
{
	int l,k,j,i;
	float scale,hh,h,g,f;

	for (i=n;i>=2;i--) {
		l=i-1;
		h=scale=0.0;
		if (l > 1) {
			for (k=1;k<=l;k++)
				scale += fabs(a[i][k]);
			if (scale == 0.0)
				e[i]=a[i][l];
			else {
				for (k=1;k<=l;k++) {
					a[i][k] /= scale;
					h += a[i][k]*a[i][k];
				}
				f=a[i][l];
				g = f>0 ? -sqrt(h) : sqrt(h);
				e[i]=scale*g;
				h -= f*g;
				a[i][l]=f-g;
				f=0.0;
				for (j=1;j<=l;j++) {
				/* Next statement can be omitted if eigenvectors not wanted */
					a[j][i]=a[i][j]/h;
					g=0.0;
					for (k=1;k<=j;k++)
						g += a[j][k]*a[i][k];
					for (k=j+1;k<=l;k++)
						g += a[k][j]*a[i][k];
					e[j]=g/h;
					f += e[j]*a[i][j];
				}
				hh=f/(h+h);
				for (j=1;j<=l;j++) {
					f=a[i][j];
					e[j]=g=e[j]-hh*f;
					for (k=1;k<=j;k++)
						a[j][k] -= (f*e[k]+g*a[i][k]);
				}
			}
		} else
			e[i]=a[i][l];
		d[i]=h;
	}
	/* Next statement can be omitted if eigenvectors not wanted */
	d[1]=0.0;
	e[1]=0.0;
	/* Contents of this loop can be omitted if eigenvectors not
			wanted except for statement d[i]=a[i][i]; */
	for (i=1;i<=n;i++) {
		l=i-1;
		if (d[i]) {
			for (j=1;j<=l;j++) {
				g=0.0;
				for (k=1;k<=l;k++)
					g += a[i][k]*a[k][j];
				for (k=1;k<=l;k++)
					a[k][j] -= g*a[k][i];
			}
		}
		d[i]=a[i][i];
		a[i][i]=1.0;
		for (j=1;j<=l;j++) a[j][i]=a[i][j]=0.0;
	}
}


/* ************************** Mi propio tred para matrices 3x3 ************************************ */


void mitred(a,d,e)
float **a,*d,*e;
{
  float l,u,v,q,vq;

  if(a[1][3]==0){

    d[1]=a[1][1];
    d[2]=a[2][2];
    d[3]=a[3][3];

    e[1]=0;
    e[2]=a[1][2];
    e[3]=a[2][3];


    a[1][1]=1;       a[1][2]=0; /* a[1][3]=0; */ 
    a[2][1]=0;       a[2][2]=1; a[2][3]=0;  
    /* a[3][1]=0; */ a[3][2]=0; a[3][3]=1;  


  }
  else{
       
    l=sqrt(a[1][2]*a[1][2] + a[1][3]*a[1][3]);

    u=a[1][2]/l;  
    v=a[1][3]/l; 

    q=2*u*a[2][3] + v*(a[3][3]-a[2][2]);

    vq=v*q;

    d[1]=a[1][1];
    d[2]=a[2][2]+vq;
    d[3]=a[3][3]-vq;

    e[1]=0;
    e[2]=l;
    e[3]=a[2][3]-u*q;

    a[1][1]=1; a[1][2]=0; a[1][3]=0; 
    a[2][1]=0; a[2][2]=u; a[2][3]=v;  
    a[3][1]=0; a[3][2]=v; a[3][3]=-u;  
     
  }

}

/* ************************** POWER METHOD ************************************ */


#define EPSILONZERO 1.0e-7
#define DIFERENCIA  1.0e-7
#define MAXSTEPS    2

void powermethod(grad,vaps,vects,deter,traza)
float *grad,*vaps,**vects,deter,traza;
{
 float qq[3],zz[3],*q,*z,lambda,lambda_anterior,magnitud,aux,dif;
 /*float deter,traza;*/
 int parar,nsteps;


 magnitud=sqrt(grad[1]*grad[1]+grad[2]*grad[2]+grad[3]*grad[3]);

 if(magnitud<EPSILONZERO) parar=2;
 else{
      lambda_anterior=0; 
      parar=0;
 
      q=qq-1;
      z=zz-1;

      q[1]=grad[1]/magnitud;
      q[2]=grad[2]/magnitud;
      q[3]=grad[3]/magnitud;

      nsteps=0;
 }

 while(parar==0){

      z[1] = vects[1][1]*q[1] + vects[1][2]*q[2] + vects[1][3]*q[3];
      z[2] = vects[2][1]*q[1] + vects[2][2]*q[2] + vects[2][3]*q[3];
      z[3] = vects[3][1]*q[1] + vects[3][2]*q[2] + vects[3][3]*q[3];

      magnitud=sqrt(z[1]*z[1]+z[2]*z[2]+z[3]*z[3]);

      if(magnitud<EPSILONZERO) parar=2;
      else{

           q[1]=z[1]/magnitud;      
           q[2]=z[2]/magnitud;      
           q[3]=z[3]/magnitud;      

           lambda=q[1]*(vects[1][1]*q[1] + vects[1][2]*q[2] + vects[1][3]*q[3])+
                  q[2]*(vects[2][1]*q[1] + vects[2][2]*q[2] + vects[2][3]*q[3])+
                  q[3]*(vects[3][1]*q[1] + vects[3][2]*q[2] + vects[3][3]*q[3]);

           dif=lambda-lambda_anterior;

           if(dif<0.0){
             parar=1;
             lambda=lambda_anterior;
           }
           else if(dif<DIFERENCIA) parar=1; 
                else if(nsteps==MAXSTEPS) parar=1;
                     else nsteps++; 
      }
 }

 if(parar==1){

               
    if(lambda!=0.0){
/*
       deter=(vects[1][1]*vects[2][2]*vects[3][3] + 2*vects[1][2]*vects[1][3]*vects[2][3]) -
             (vects[1][1]*vects[2][3]*vects[2][3] + vects[2][2]*vects[1][3]*vects[1][3] + vects[3][3]*vects[1][2]*vects[1][2]);

       traza=vects[1][1]+vects[2][2]+vects[3][3];
*/
       aux = traza - lambda;

       vaps[1] = lambda;
       vaps[2] = 0.5*(aux + sqrt(aux*aux-4*(deter/vaps[1])));
       vaps[3] = traza-(vaps[1]+vaps[2]);

       q[1]=vects[1][1]-vaps[1];
       q[2]=vects[2][2]-vaps[1];
       q[3]=vects[3][3]-vaps[1];

       z[3]=1.0;
       z[2]=(vects[1][2]*vects[1][3]-vects[2][3]*q[1])/(q[1]*q[2]-vects[1][2]*vects[1][2]);
       z[1]=-(vects[1][2]*z[2]+vects[1][3])/q[1];

       vects[1][1]=z[1];
       vects[2][1]=z[2];
       vects[3][1]=z[3];

    }
    else{
         vaps[1]=0.0;
         vaps[2]=0.0;
         vaps[3]=0.0;
     
         vects[1][1]=0.0;     
         vects[2][1]=0.0;     
         vects[3][1]=0.0;     
    }


 }
 else{

      vaps[1]=0.0;
      vaps[2]=0.0;
      vaps[3]=0.0;

      vects[1][1]=0.0;     
      vects[2][1]=0.0;     
      vects[3][1]=0.0;     
 }

}

#undef EPSILONZERO
#undef DIFERENCIA
#undef MAXSTEPS
