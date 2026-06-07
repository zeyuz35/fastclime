#include <R.h>
#include <Rinternals.h>
#include <stdlib.h> // for NULL
#include <R_ext/Rdynload.h>

extern void fastlp(double *obj, double *mat, double *rhs, int *m0, int *n0, double *opt, int *status, double *lambda);
extern void paralp(double *obj, double *mat, double *rhs, int *m0, int *n0, double *opt, int *status, double *lambda, double *rhs_bar, double *obj_bar);
extern void dantzig(double *X2, double *Xy, double *BETA0, int *d0, double *lambda, int *nlambda, double *lambdalist);
extern void parametric(double *SigmaInput, int *m1, double *mu_input, double *lambdamin, int *nlambda, int *maxnlambda, double *iicov);

static const R_CMethodDef CEntries[] = {
    {"fastlp", (DL_FUNC) &fastlp, 8},
    {"paralp", (DL_FUNC) &paralp, 10},
    {"dantzig", (DL_FUNC) &dantzig, 7},
    {"parametric", (DL_FUNC) &parametric, 7},
    {NULL, NULL, 0}
};

void R_init_fastclime(DllInfo *dll)
{
    R_registerRoutines(dll, CEntries, NULL, NULL, NULL);
    R_useDynamicSymbols(dll, FALSE);
}
