float *vector(int nl,int nh);
/*float **matrix();*/
float **matrix(int nrl,int nrh,int ncl,int nch);
float **convert_matrix(float *a,int nrl,int nrh,int ncl,int nch);
double *dvector();
double **dmatrix();
int *ivector(int nl,int nh);
int **imatrix();
float **submatrix();
void free_vector(float *v,int nl, int nh);
void free_dvector();
void free_ivector(int *v,int nl,int nh);
/*void free_matrix();*/
void free_matrix(float **m,int nrl,int nrh,int ncl,int nch);
void free_dmatrix();
void free_imatrix();
void free_submatrix();
void free_convert_matrix(float **b, int nrl, int nrh, int ncl,int nch);
void nrerror();
