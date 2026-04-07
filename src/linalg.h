#ifndef FASTCLIME_LINALG_H
#define FASTCLIME_LINALG_H

double fc_dotprod(double *x, double *y, int n);
void   fc_bmx(int m, double *a, int *ka, int *ia, int *basis, double *x, double *y);
void   fc_btmx(int m, double *a, int *ka, int *ia, int *basis, double *x, double *y);
void   fc_smx(int m, int n, double *a, int *ka, int *ia, double *x, double *y);
void   fc_atnum(int m, int n, int *ka, int *ia, double *a, int *kat, int *iat, double *at);
double fc_maxv(double *x, int n);
double fc_sdotprod(double *c, double *x_B, int *basics, int m);
void   fc_Nt_times_y(int n, double *at, int *iat, int *kat, int *basicflag, double *y, int *iy, int ny, double *yN, int *iyN, int *pnyN, double *a, int *tag, int *link, int *pcurrtag);

#endif // FASTCLIME_LINALG_H
