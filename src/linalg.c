#include "linalg.h"
#include "memory.h"
#include "config.h"

double fc_dotprod(double *x, double *y, int n) {
    int i; 
    double dot=0.0;
    for (i=0; i<n; i++) dot += x[i]*y[i];
    return dot;
}

void fc_bmx(int m, double *a, int *ka, int *ia, int *basis, double *x, double *y) {
    int i,j,k;
    for (i=0; i<m; i++) y[i] = 0.0;
    for (i=0; i<m; i++) {
        j = basis[i];
        for (k=ka[j]; k<ka[j+1]; k++)
            y[ia[k]] += a[k]*x[i];
    }
}

void fc_btmx(int m, double *a, int *ka, int *ia, int *basis, double *x, double *y) {
    int i,j,k;
    for (i=0; i<m; i++) y[i] = 0.0;
    for (i=0; i<m; i++) {
        j = basis[i];
        for (k=ka[j]; k<ka[j+1]; k++)
            y[i] += a[k]*x[ia[k]];
    }
}

void fc_smx(int m, int n, double *a, int *ka, int *ia, double *x, double *y) {
    int i,j,k;
    for (i=0; i<m; i++) y[i] = 0.0;
    for (j=0; j<n; j++) 
        for (k=ka[j]; k<ka[j+1]; k++)
            y[ia[k]] += a[k]*x[j];
}

void fc_atnum(int m, int n, int *ka, int *ia, double *a, int *kat, int *iat, double *at) {
    int i,j,k,row,addr;
    int *iwork;

    iwork = (int*)FC_CALLOC(m, sizeof(int));

    for (k=0; k<ka[n]; k++) {
        row = ia[k];
        iwork[row]++;
    }

    kat[0] = 0;
    for (i=0; i<m; i++) {
        kat[i+1] = kat[i] + iwork[i];
        iwork[i] = 0;
    }

    for (j=0; j<n; j++) {
        for (k=ka[j]; k<ka[j+1]; k++) {
            row = ia[k];
            addr = kat[row] + iwork[row];
            iwork[row]++;
            iat[addr] = j;
            at[addr]  = a[k];
        }
    }

    FC_FREE(iwork);
}

double fc_maxv(double *x, int n) {
    int i;
    double maxval=0.0;
    for (i=0; i<n; i++) maxval = FC_MAX(maxval, FC_ABS(x[i]));
    return maxval;
}

double fc_sdotprod(double *c, double *x_B, int *basics, int m) {
    int i;
    double prod = 0.0;
    for (i=0; i<m; i++) { prod += c[basics[i]]*x_B[i]; }
    return prod;
}

void fc_Nt_times_y(int n, double *at, int *iat, int *kat, int *basicflag, double *y, int *iy, int ny, double *yN, int *iyN, int *pnyN, double *a, int *tag, int *link, int *pcurrtag) {
    int i,j,jj,k,kk;

    jj = -1;
    for (k=0; k<ny; k++) {
        i = iy[k];
        for (kk=kat[i]; kk<kat[i+1]; kk++) {
            j = iat[kk];
            if (basicflag[j] < 0) {
                if (tag[j] != *pcurrtag) {
                    a[j] = 0.0;
                    tag[j] = *pcurrtag;
                    link[jj] = j;
                    jj = j;
                }
                a[j] += y[k]*at[kk];
            }
        }
    }

    link[jj] = n;
    (*pcurrtag)++;

    k = 0;
    
    for (jj=link[-1]; jj<n; jj=link[jj]) {
        if (FC_ABS(a[jj]) > 1.0e-8) { 
             yN[k] = a[jj];
            iyN[k] = -basicflag[jj]-1;
            k++;
        }
    }
    *pnyN = k;
}
