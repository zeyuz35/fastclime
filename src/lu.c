#include <stdlib.h>
#include <math.h>
#include <time.h>
#include "lu.h"
#include "tree.h"
#include "heap.h"
#include "linalg.h"

fc_lu_context_t* fc_lu_create(void) {
    fc_lu_context_t *ctx = (fc_lu_context_t*)FC_CALLOC(1, sizeof(fc_lu_context_t));
    ctx->currtag_bsolve = 1;
    ctx->currtag_btsolve = 1;
    ctx->currtag_geta = 1;
    ctx->currtag_getat = 1;
    fc_tree_init(&ctx->tree);
    return ctx;
}

void fc_lu_destroy(fc_lu_context_t *ctx) {
    if (!ctx) return;
    
    FC_FREE(ctx->colperm); FC_FREE(ctx->icolperm);
    FC_FREE(ctx->rowperm); FC_FREE(ctx->irowperm);
    FC_FREE(ctx->L); FC_FREE(ctx->iL); FC_FREE(ctx->kL);
    FC_FREE(ctx->U); FC_FREE(ctx->iU); FC_FREE(ctx->kU);
    FC_FREE(ctx->Lt); FC_FREE(ctx->iLt); FC_FREE(ctx->kLt);
    FC_FREE(ctx->Ut); FC_FREE(ctx->iUt); FC_FREE(ctx->kUt);
    FC_FREE(ctx->diagU);
    
    FC_FREE(ctx->E_d); FC_FREE(ctx->E); FC_FREE(ctx->iE); FC_FREE(ctx->kE);
    
    FC_FREE(ctx->y_bsolve); FC_FREE(ctx->tag_bsolve);
    FC_FREE(ctx->y_btsolve); FC_FREE(ctx->tag_btsolve);
    
    FC_FREE(ctx->a_geta); FC_FREE(ctx->tag_geta); 
    if (ctx->link_geta) { int *orig = ctx->link_geta - 1; FC_FREE(orig); ctx->link_geta = NULL; }
    
    FC_FREE(ctx->a_getat); FC_FREE(ctx->tag_getat);
    
    fc_killtree(&ctx->tree);
    FC_FREE(ctx);
}

void fc_refactor(fc_lu_context_t *ctx, int m, int *kA, int *iA, double *A, int *basics, int col_out, int v) {
    double starttime = (double)clock();
    double rffactor = 1.0;
    int from_scratch = 0;
    int k;

    if (ctx->e_iter > 0) {
        from_scratch = 1;
        for (k = ctx->kE[ctx->e_iter]; k < ctx->kE[ctx->e_iter+1]; k++) {
            if (ctx->iE[k] == col_out) {
                from_scratch = 0;
                break;
            }
        }
    } else {
        from_scratch = 0;
    }

    if ((ctx->e_iter > 2 && ctx->cumtime/(ctx->e_iter+1) >= ctx->ocumtime/ctx->e_iter) || 
        ctx->e_iter >= FC_E_N || from_scratch == 1) {
        ctx->ocumtime = 0.0;
        ctx->cumtime  = 0.0;
        fc_lufac(ctx, m, kA, iA, A, basics, v);
        ctx->cumtime *= rffactor;
        ctx->enz = 0;
        ctx->e_iter = 0;
        return;
    }
   
    ctx->ocumtime = ctx->cumtime;
    ctx->E_d[ctx->e_iter] = col_out;    
    ctx->e_iter++;
    ctx->cumtime += (double)clock() - starttime;
}

typedef struct {
    int *degB; int *degBt; int *hkey;
    int *heap; int *iheap; int *iwork; int *iwork2;
    FC_VALIND **B; FC_VALIND **Bt;
    int lnzbnd; int unzbnd;
    int heapnum; int tag;
    int lnz; int unz;
} fc_lufac_work_t;

static void fc_lufac_init_wk(fc_lu_context_t *ctx, int m, int *kA, int *iA, double *A, int *basis, fc_lufac_work_t *wk) {
    int i, j, k, row, kk, kkk;

    if (ctx->colperm == NULL)  { ctx->colperm  = (int*)FC_CALLOC(m, sizeof(int)); }
    else { ctx->colperm = (int*)FC_REALLOC(ctx->colperm, m, sizeof(int)); }
    
    if (ctx->icolperm == NULL) { ctx->icolperm = (int*)FC_CALLOC(m, sizeof(int)); }
    else { ctx->icolperm = (int*)FC_REALLOC(ctx->icolperm, m, sizeof(int)); }
    
    if (ctx->rowperm == NULL)  { ctx->rowperm  = (int*)FC_CALLOC(m, sizeof(int)); }
    else { ctx->rowperm = (int*)FC_REALLOC(ctx->rowperm, m, sizeof(int)); }
    
    if (ctx->irowperm == NULL) { ctx->irowperm = (int*)FC_CALLOC(m, sizeof(int)); }
    else { ctx->irowperm = (int*)FC_REALLOC(ctx->irowperm, m, sizeof(int)); }

    wk->degB    = (int*)FC_CALLOC(m, sizeof(int));
    wk->degBt   = (int*)FC_CALLOC(m, sizeof(int));
    wk->hkey    = (int*)FC_CALLOC(m, sizeof(int));
    wk->heap    = (int*)FC_CALLOC((size_t)m + 1, sizeof(int));
    wk->iheap   = (int*)FC_CALLOC(m, sizeof(int));
    wk->iwork   = (int*)FC_CALLOC(m, sizeof(int));
    wk->iwork2  = (int*)FC_CALLOC(m, sizeof(int));

    for (i=0; i<m; i++) { wk->degBt[i] = 0; }
    for (i=0; i<m; i++) {
        wk->degB[i] = kA[basis[i]+1] - kA[basis[i]];
        for (k=kA[basis[i]]; k<kA[basis[i]+1]; k++) {
            wk->degBt[iA[k]]++;
        }
    }

    wk->lnzbnd = 0;
    for (i=0; i<m; i++) wk->lnzbnd += wk->degB[i];
    wk->lnzbnd = wk->lnzbnd/2;
    wk->unzbnd = wk->lnzbnd;

    if (ctx->kL == NULL)   { ctx->kL    = (int*)FC_CALLOC((size_t)m + 1,  sizeof(int)); } else { ctx->kL = (int*)FC_REALLOC(ctx->kL, (size_t)m + 1, sizeof(int)); }
    if (ctx->iL == NULL)   { ctx->iL    = (int*)FC_CALLOC(wk->lnzbnd, sizeof(int)); } else { ctx->iL = (int*)FC_REALLOC(ctx->iL, wk->lnzbnd, sizeof(int)); }
    if (ctx->L ==  NULL)   { ctx->L     = (double*)FC_CALLOC(wk->lnzbnd, sizeof(double)); } else { ctx->L = (double*)FC_REALLOC(ctx->L, wk->lnzbnd, sizeof(double)); }
    if (ctx->kUt == NULL)  { ctx->kUt   = (int*)FC_CALLOC((size_t)m + 1,  sizeof(int)); } else { ctx->kUt = (int*)FC_REALLOC(ctx->kUt, (size_t)m + 1, sizeof(int)); }
    if (ctx->iUt == NULL)  { ctx->iUt   = (int*)FC_CALLOC(wk->unzbnd, sizeof(int)); } else { ctx->iUt = (int*)FC_REALLOC(ctx->iUt, wk->unzbnd, sizeof(int)); }
    if (ctx->Ut == NULL)   { ctx->Ut    = (double*)FC_CALLOC(wk->unzbnd, sizeof(double)); } else { ctx->Ut = (double*)FC_REALLOC(ctx->Ut, wk->unzbnd, sizeof(double)); }
    if (ctx->diagU == NULL){ ctx->diagU = (double*)FC_CALLOC(m, sizeof(double)); } else { ctx->diagU = (double*)FC_REALLOC(ctx->diagU, m, sizeof(double)); }

    wk->B = (FC_VALIND**)FC_CALLOC(m, sizeof(FC_VALIND*));
    wk->Bt = (FC_VALIND**)FC_CALLOC(m, sizeof(FC_VALIND*));
    for (i=0; i<m; i++) {
        wk->B[i]  = (FC_VALIND*)FC_CALLOC(wk->degB[i],  sizeof(FC_VALIND));
        wk->Bt[i] = (FC_VALIND*)FC_CALLOC(wk->degBt[i], sizeof(FC_VALIND));
    }

    for (i=0; i<m; i++) { wk->iwork[i] = 0; }
    for (j=0; j<m; j++) {
        kkk = 0;
        for (k=kA[basis[j]]; k<kA[basis[j]+1]; k++) {
            row = iA[k];
            kk  = wk->iwork[row];
            wk->B[j][kkk].i = row;
            wk->B[j][kkk].d = A[k];
            wk->Bt[row][kk].i = j;
            wk->Bt[row][kk].d = A[k];
            wk->iwork[row]++;
            kkk++;
        }
    }

    for (i=0; i<m; i++) { 
        ctx->icolperm[i] = -1;
        ctx->irowperm[i] = -1;
        wk->iwork[i] = 0; 
        wk->iwork2[i] = -1; 
    }

    ctx->rank = m; 
    wk->tag = 0; 
    wk->lnz = 0; 
    wk->unz = 0; 
    ctx->kL[0] = 0; 
    ctx->kUt[0] = 0;

    for (j=0; j<m; j++) {
        if (FC_MD == 1) wk->hkey[j] = wk->degB[j];
        else wk->hkey[j] = j;
        if (wk->hkey[j]==0) wk->hkey[j]=m+1;
    }

    wk->heapnum = m;
    for (j=m-1; j>=0; j--) {
        int cur = j+1;
        wk->iheap[j] = cur;
        wk->heap[cur] = j;
        fc_hfall(wk->heapnum, wk->hkey, wk->iheap, wk->heap, cur);
    }
}

static void fc_lufac_factorize_loop(fc_lu_context_t *ctx, int m, fc_lufac_work_t *wk) {
    int i, k, kk, cnt, deg, okey;
    int col, coldeg, row, rowdeg, col2, row2;
    FC_VALIND tempB;

    int stop_factorization = 0;

    for (i=0; i<m; i++) {
        int pivoted = 0;
        while (!pivoted) {
            col    = wk->heap[1];
            coldeg = wk->degB[col];

            if (coldeg == 0) {
                ctx->rank = i;
                stop_factorization = 1;
                break;
            }

            rowdeg = m+1;
            row = -1;
            for (k=0; k<coldeg; k++) {
                if ( wk->degBt[ wk->B[col][k].i ] < rowdeg && FC_ABS( wk->B[col][k].d ) > FC_EPSNUM ) {
                    row    = wk->B[col][k].i;
                    rowdeg = wk->degBt[row];
                }
            }

            if (rowdeg == m+1) {
                wk->hkey[col] = m+2;
                fc_hfall( wk->heapnum, wk->hkey, wk->iheap, wk->heap, wk->iheap[col] ); 
                if (wk->hkey[wk->heap[1]] == m+2) {
                    ctx->rank = i;
                    stop_factorization = 1;
                    break;
                } else {
                    continue; 
                }
            }
            pivoted = 1;
        }

        if (stop_factorization) break;

        ctx->colperm[i] = col;
        ctx->icolperm[col] = i;
        ctx->rowperm[i] = row;
        ctx->irowperm[row] = i;

        cnt = wk->lnz + coldeg-1 + coldeg*rowdeg/2;
        if (cnt > wk->lnzbnd) {
            wk->lnzbnd = cnt;
            ctx->L = (double*)FC_REALLOC(ctx->L, wk->lnzbnd, sizeof(double));
            ctx->iL = (int*)FC_REALLOC(ctx->iL, wk->lnzbnd, sizeof(int));
        }

        cnt = wk->unz + rowdeg-1 + coldeg*rowdeg/2;
        if (cnt > wk->unzbnd) {
            wk->unzbnd = cnt;
            ctx->Ut = (double*)FC_REALLOC(ctx->Ut, wk->unzbnd, sizeof(double));
            ctx->iUt = (int*)FC_REALLOC(ctx->iUt, wk->unzbnd, sizeof(int));
        }

        ctx->kL[i+1] = ctx->kL[i] + coldeg-1;
        for (k=0; k<coldeg; k++) {
            if ( wk->B[col][k].i != row ) {
                ctx->iL[wk->lnz] = wk->B[col][k].i;
                ctx->L[wk->lnz] = wk->B[col][k].d;
                wk->lnz++;
            }
        }

        ctx->kUt[i+1] = ctx->kUt[i] + rowdeg-1;
        for (k=0; k<rowdeg; k++) {
            if ( wk->Bt[row][k].i != col ) {
                ctx->iUt[wk->unz] = wk->Bt[row][k].i;
                ctx->Ut[wk->unz] = wk->Bt[row][k].d;
                wk->unz++;
            } else {
                ctx->diagU[i] = wk->Bt[row][k].d;
            }
        }

        for (k=0; k<coldeg; k++) {
            row2 = wk->B[col][k].i;
            wk->degBt[row2]--;
            for (kk=0; wk->Bt[row2][kk].i != col; kk++) ;
            tempB = wk->Bt[row2][ wk->degBt[row2] ];
            wk->Bt[row2][ wk->degBt[row2] ] = wk->Bt[row2][kk];
            wk->Bt[row2][kk] = tempB;
        }

        for (k=0; k<rowdeg; k++) {
            col2 = wk->Bt[row][k].i;
            wk->degB[col2]--;
            for (kk=0; wk->B[col2][kk].i != row; kk++) ;
            tempB = wk->B[col2][ wk->degB[col2] ];
            wk->B[col2][ wk->degB[col2] ] = wk->B[col2][kk];
            wk->B[col2][kk] = tempB;
        }
        wk->degB[col] = 0;
        wk->degBt[row] = 0;

        okey = wk->hkey[col];
        wk->heap[1] = wk->heap[wk->heapnum];
        wk->iheap[wk->heap[1]] = 1;
        wk->heapnum--;
        if (okey < wk->hkey[wk->heap[1]]) 
            fc_hfall(wk->heapnum, wk->hkey, wk->iheap, wk->heap, 1);

        for (k=ctx->kL[i]; k<ctx->kL[i+1]; k++) {
            row2 = ctx->iL[k];
            wk->tag++;
            for (kk=0; kk<wk->degBt[row2]; kk++) {
                wk->iwork[ wk->Bt[row2][kk].i] = wk->tag; 
                wk->iwork2[wk->Bt[row2][kk].i] = kk;  
            }
            for (kk=ctx->kUt[i]; kk<ctx->kUt[i+1]; kk++) {
                col2 = ctx->iUt[kk];
                if ( wk->iwork[col2] == wk->tag ) {
                    wk->Bt[row2][wk->iwork2[col2]].d -= ctx->L[k]*ctx->Ut[kk]/ctx->diagU[i];
                } else {
                    deg = wk->degBt[row2];
                    wk->Bt[row2] = (FC_VALIND*)FC_REALLOC( wk->Bt[row2], deg+1, sizeof(FC_VALIND) );
                    wk->Bt[row2][deg].i = col2;
                    wk->Bt[row2][deg].d = -ctx->L[k]*ctx->Ut[kk]/ctx->diagU[i];
                    wk->degBt[row2]++;
                }
            }
        }

        for (k=ctx->kUt[i]; k<ctx->kUt[i+1]; k++) {
            col2 = ctx->iUt[k];
            wk->tag++;
            for (kk=0; kk<wk->degB[col2]; kk++) {
                wk->iwork[ wk->B[col2][kk].i] = wk->tag; 
                wk->iwork2[wk->B[col2][kk].i] = kk;  
            }
            for (kk=ctx->kL[i]; kk<ctx->kL[i+1]; kk++) {
                row2 = ctx->iL[kk];
                if ( wk->iwork[row2] == wk->tag ) {
                    wk->B[col2][wk->iwork2[row2]].d -= ctx->L[kk]*ctx->Ut[k]/ctx->diagU[i];
                } else {
                    deg = wk->degB[col2];
                    wk->B[col2] = (FC_VALIND*)FC_REALLOC( wk->B[col2], deg+1, sizeof(FC_VALIND) );
                    wk->B[col2][deg].i = row2;
                    wk->B[col2][deg].d = -ctx->L[kk]*ctx->Ut[k]/ctx->diagU[i];
                    wk->degB[col2]++;
                }
            }
        }

        for (k=ctx->kUt[i]; k<ctx->kUt[i+1]; k++) {
            col2 = ctx->iUt[k];
            if (FC_MD == 1) { wk->hkey[col2] = wk->degB[col2]; } 
            else { wk->hkey[col2] = col2; }
            if (wk->hkey[col2]==0) wk->hkey[col2]=m+1;
            fc_hrise( wk->hkey, wk->iheap, wk->heap, wk->iheap[col2] );
            fc_hfall( wk->heapnum, wk->hkey, wk->iheap, wk->heap, wk->iheap[col2] ); 
        }
    }
}

static void fc_lufac_finalize_wk(fc_lu_context_t *ctx, int m, fc_lufac_work_t *wk) {
    int i, k, row, col;

    i = ctx->rank;
    for (col=0; col<m; col++) {
        if (ctx->icolperm[col] == -1) {
            ctx->colperm[i] = col;
            ctx->icolperm[col] = i;
            i++;
        }
    }

    i = ctx->rank;
    for (row=0; row<m; row++) {
        if (ctx->irowperm[row] == -1) {
            ctx->rowperm[i] = row;
            ctx->irowperm[row] = i;
            i++;
        }
    }

    for (i=ctx->rank; i<m; i++) {
        ctx->kL[i+1] = ctx->kL[i];
        ctx->kUt[i+1] = ctx->kUt[i];
        ctx->diagU[i] = 0.0;
    }

    for (i=0; i<m; i++) { FC_FREE(wk->B[i]); FC_FREE(wk->Bt[i]); }
    FC_FREE(wk->degB);  FC_FREE(wk->degBt); 
    FC_FREE(wk->hkey);  FC_FREE(wk->heap); FC_FREE(wk->iheap);
    FC_FREE(wk->iwork); FC_FREE(wk->iwork2); FC_FREE(wk->B); FC_FREE(wk->Bt);

    for (k=0; k<ctx->kL[m]; k++) ctx->iL[k] = ctx->irowperm[ctx->iL[k]];
    for (k=0; k<ctx->kUt[m]; k++) ctx->iUt[k] = ctx->icolperm[ctx->iUt[k]];

    for (i=0; i<m; i++) {
        for (k=ctx->kL[i]; k<ctx->kL[i+1]; k++) {
            ctx->L[k] /= ctx->diagU[i];
        }
    }

    wk->lnz = ctx->kL[m];
    wk->unz = ctx->kUt[m];

    if (ctx->Lt == NULL) { ctx->Lt = (double*)FC_CALLOC(wk->lnz, sizeof(double)); } else { ctx->Lt = (double*)FC_REALLOC(ctx->Lt, wk->lnz, sizeof(double)); }
    if (ctx->iLt == NULL){ ctx->iLt= (int*)FC_CALLOC(wk->lnz, sizeof(int)); }       else { ctx->iLt= (int*)FC_REALLOC(ctx->iLt, wk->lnz, sizeof(int)); }
    if (ctx->kLt == NULL){ ctx->kLt= (int*)FC_CALLOC((size_t)m + 1, sizeof(int)); }           else { ctx->kLt= (int*)FC_REALLOC(ctx->kLt, (size_t)m + 1, sizeof(int)); }

    if (ctx->U == NULL)  { ctx->U  = (double*)FC_CALLOC(wk->unz, sizeof(double)); } else { ctx->U  = (double*)FC_REALLOC(ctx->U, wk->unz, sizeof(double)); }
    if (ctx->iU == NULL) { ctx->iU = (int*)FC_CALLOC(wk->unz, sizeof(int)); }       else { ctx->iU = (int*)FC_REALLOC(ctx->iU, wk->unz, sizeof(int)); }
    if (ctx->kU == NULL) { ctx->kU = (int*)FC_CALLOC((size_t)m + 1, sizeof(int)); }           else { ctx->kU = (int*)FC_REALLOC(ctx->kU, (size_t)m + 1, sizeof(int)); }

    fc_atnum(m,m, ctx->kL, ctx->iL, ctx->L, ctx->kLt, ctx->iLt, ctx->Lt);
    fc_atnum(m,m, ctx->kUt,ctx->iUt,ctx->Ut,ctx->kU,  ctx->iU,  ctx->U );

    if ( ctx->E_d == NULL ) {
        ctx->E_d = (int*)FC_CALLOC( FC_E_N, sizeof(int) );
        ctx->E = (double*)FC_CALLOC( FC_E_NZ, sizeof(double) );
        ctx->iE = (int*)FC_CALLOC( FC_E_NZ, sizeof(int) );
        ctx->kE = (int*)FC_CALLOC((size_t)FC_E_N+1, sizeof(int));
    }
    ctx->kE[0] = 0;
}

void fc_lufac(fc_lu_context_t *ctx, int m, int *kA, int *iA, double *A, int *basis, int v) {
    double starttime = (double)clock();
    fc_lufac_work_t wk = {0};
    fc_lufac_init_wk(ctx, m, kA, iA, A, basis, &wk);
    fc_lufac_factorize_loop(ctx, m, &wk);
    fc_lufac_finalize_wk(ctx, m, &wk);
    ctx->cumtime += (double)clock() - starttime;
}

void fc_Gauss_Eta(fc_lu_context_t *ctx, int m, double *dx_B, int *idx_B, int *pndx_B) {
    int i, j, k, col, kcol=0, ii, ndx_B=*pndx_B;
    double temp;

    if (m==0) {  
        FC_FREE(ctx->a_geta); FC_FREE(ctx->tag_geta);
        if (ctx->link_geta != NULL) {
            int *orig = ctx->link_geta - 1;
            FC_FREE(orig);
            ctx->link_geta = NULL;
        }
        ctx->currtag_geta=1;
        return;
    }

    if (ctx->a_geta == NULL) { ctx->a_geta = (double*)FC_CALLOC(m, sizeof(double)); } else if (m > 0) { ctx->a_geta = (double*)FC_REALLOC(ctx->a_geta, m, sizeof(double)); }
    if (ctx->tag_geta == NULL) { ctx->tag_geta = (int*)FC_CALLOC(m, sizeof(int)); } else if (m > 0) { ctx->tag_geta = (int*)FC_REALLOC(ctx->tag_geta, m, sizeof(int)); }
    
    if (ctx->link_geta == NULL) {
        int *orig = (int*)FC_CALLOC((size_t)m + 2, sizeof(int));
        ctx->link_geta = orig + 1;
    } else {
        int *orig = ctx->link_geta - 1;
        FC_FREE(orig);
        orig = (int*)FC_CALLOC((size_t)m + 2, sizeof(int));
        ctx->link_geta = orig + 1;
    }

    if (ctx->e_iter <= 0) return;

    ii = -1;
    for (k=0; k<ndx_B; k++) {
        i = idx_B[k];
        ctx->a_geta[i] = dx_B[k];
        ctx->tag_geta[i] = ctx->currtag_geta;
        ctx->link_geta[ii] = i;
        ii = i;
    }
    for (j=0; j<ctx->e_iter; j++) {
        col = ctx->E_d[j];
        for (k=ctx->kE[j]; k<ctx->kE[j+1]; k++) {
            i = ctx->iE[k];
            if (ctx->tag_geta[i] != ctx->currtag_geta) {
                ctx->a_geta[i] = 0.0;
                ctx->tag_geta[i] = ctx->currtag_geta;
                ctx->link_geta[ii] = i;
                ii = i;
            }
            if (i == col) kcol = k;
        }
    
        temp = ctx->a_geta[col]/ctx->E[kcol];
        if (temp != 0.0) {
            for (k=ctx->kE[j]; k<kcol; k++) {
                i = ctx->iE[k];
                ctx->a_geta[i] -= ctx->E[k] * temp;
            }
            ctx->a_geta[col] = temp;
            for (k=kcol+1; k<ctx->kE[j+1]; k++) {
                i = ctx->iE[k];
                ctx->a_geta[i] -= ctx->E[k] * temp;    
            }
        }
    }
    ctx->link_geta[ii] = m;
    ctx->currtag_geta++;

    k = 0;
    for (i=ctx->link_geta[-1]; i<m; i=ctx->link_geta[i]) {
        if ( FC_ABS(ctx->a_geta[i]) > FC_EPS ) {
             dx_B[k] = ctx->a_geta[i];
            idx_B[k] = i;
            k++;
        }
    }
    *pndx_B = k;
}

int fc_bsolve(fc_lu_context_t *ctx, int m, double *sy, int *iy, int *pny) {
    int i, ny=*pny;
    int k, row, consistent=1;
    double beta;
    double eps=0;

    double starttime = (double)clock();

    if (m==0) { 
        FC_FREE(ctx->y_bsolve); FC_FREE(ctx->tag_bsolve); ctx->currtag_bsolve=1;
        fc_Gauss_Eta( ctx, 0, sy, iy, &ny);
        return 0;
    }

    if (ctx->y_bsolve == NULL) { ctx->y_bsolve = (double*)FC_CALLOC(m, sizeof(double)); } else if (m > 0) { ctx->y_bsolve = (double*)FC_REALLOC(ctx->y_bsolve, m, sizeof(double)); }
    if (ctx->tag_bsolve == NULL) { ctx->tag_bsolve = (int*)FC_CALLOC(m, sizeof(int)); } else if (m > 0) { ctx->tag_bsolve = (int*)FC_REALLOC(ctx->tag_bsolve, m, sizeof(int)); }

    for (k=0; k<ny; k++) {
        i = ctx->irowperm[iy[k]];
        ctx->y_bsolve[i] = sy[k];
        ctx->tag_bsolve[i] = ctx->currtag_bsolve;
        fc_addtree(&ctx->tree, i);
    }

    if (ctx->rank < m) eps = FC_EPSSOL * fc_maxv(sy,ny);

    for (i=fc_getfirst(&ctx->tree); i < ctx->rank && i != -1; i=fc_getnext(&ctx->tree)) {
        beta = ctx->y_bsolve[i];
        for (k=ctx->kL[i]; k<ctx->kL[i+1]; k++) {
            row = ctx->iL[k];
            if (ctx->tag_bsolve[row] != ctx->currtag_bsolve) {
                ctx->y_bsolve[row] = 0.0;
                ctx->tag_bsolve[row] = ctx->currtag_bsolve;
                fc_addtree(&ctx->tree, row);
            }
            ctx->y_bsolve[row] -= ctx->L[k]*beta;
        }
    }

    for (i=fc_getlast(&ctx->tree); i >= ctx->rank && i != -1; i=fc_getprev(&ctx->tree)) {
        if ( FC_ABS( ctx->y_bsolve[i] ) > eps ) consistent = 0;
        ctx->y_bsolve[i] = 0.0;
    }
    for ( ; i>=0; i=fc_getprev(&ctx->tree)) {
        beta = ctx->y_bsolve[i]/ctx->diagU[i];
        for (k=ctx->kU[i]; k<ctx->kU[i+1]; k++) {
            row = ctx->iU[k];
            if (ctx->tag_bsolve[row] != ctx->currtag_bsolve) {
                ctx->y_bsolve[row] = 0.0;
                ctx->tag_bsolve[row] = ctx->currtag_bsolve;
                fc_addtree(&ctx->tree, row);
            }
            ctx->y_bsolve[row] -= ctx->U[k]*beta;
        }
        ctx->y_bsolve[i] = beta;
    }

    ny = 0;
    for (i=fc_getfirst(&ctx->tree); i != -1; i=fc_getnext(&ctx->tree)) {
        if ( FC_ABS(ctx->y_bsolve[i]) > FC_EPS ) {
            sy[ny] = ctx->y_bsolve[i];
            iy[ny] = ctx->colperm[i];
            ny++;
        }
    }

    ctx->currtag_bsolve++;
    fc_killtree(&ctx->tree);

    fc_Gauss_Eta( ctx, m, sy, iy, &ny);

    *pny = ny;
    
    if (ctx->enz + ny > FC_E_NZ) {
        ctx->E = (double*)FC_REALLOC(ctx->E, FC_E_NZ + ctx->enz + ny, sizeof(double));
        ctx->iE = (int*)FC_REALLOC(ctx->iE, FC_E_NZ + ctx->enz + ny, sizeof(int));
    }
    
    for (i=0, k=ctx->kE[ctx->e_iter]; i<ny; i++, k++) {
        ctx->E[k] = sy[i];
        ctx->iE[k] = iy[i];
    }
    ctx->enz = k;
    ctx->kE[ctx->e_iter+1] = ctx->enz;    

    ctx->cumtime += (double)clock() - starttime;
    return consistent;
}

void fc_Gauss_Eta_T(fc_lu_context_t *ctx, int m, double *vec, int *ivec, int *pnvec) {
    int i, j, k, kk=0, kkk=0, col, nvec=*pnvec;
    double temp;

    if (m==0) {  
        FC_FREE(ctx->a_getat); FC_FREE(ctx->tag_getat); ctx->currtag_getat=1;
        return;
    }

    if (ctx->a_getat == NULL) { ctx->a_getat = (double*)FC_CALLOC(m, sizeof(double)); } else if (m > 0) { ctx->a_getat = (double*)FC_REALLOC(ctx->a_getat, m, sizeof(double)); }
    if (ctx->tag_getat == NULL) { ctx->tag_getat = (int*)FC_CALLOC(m, sizeof(int)); } else if (m > 0) { ctx->tag_getat = (int*)FC_REALLOC(ctx->tag_getat, m, sizeof(int)); }

    for (j=ctx->e_iter-1; j>=0; j--) {
        col = ctx->E_d[j];

        for (k=0; k<nvec; k++) {
            i = ivec[k];
            if (i == col) kk = k;
            ctx->a_getat[i] = vec[k];
            ctx->tag_getat[i] = ctx->currtag_getat;
        }

        if (ctx->tag_getat[col] != ctx->currtag_getat) {
            vec[nvec] = 0.0;
            ivec[nvec] = col;
            kk = nvec;
            nvec++;
            ctx->a_getat[col] = 0.0;
            ctx->tag_getat[col] = ctx->currtag_getat;
        }
        temp = vec[kk];
        for (k=ctx->kE[j]; k<ctx->kE[j+1]; k++) {
            i = ctx->iE[k];
            if (i == col) kkk = k;
            if (ctx->tag_getat[i] == ctx->currtag_getat) {
                if (i != col) { temp -= ctx->E[k]*ctx->a_getat[i]; }
            }
        }
        ctx->currtag_getat++;
        vec[kk] = temp/ctx->E[kkk];
        *pnvec = nvec;
    }
}

int fc_btsolve(fc_lu_context_t *ctx, int m, double *sy, int *iy, int *pny) {
    int i, ny=*pny;
    int k, row, consistent=1;
    double beta;
    double eps=0;

    double starttime = (double)clock();

    if (m==0) {  
        FC_FREE(ctx->y_btsolve); FC_FREE(ctx->tag_btsolve); ctx->currtag_btsolve=1;
        fc_Gauss_Eta_T( ctx, 0, sy, iy, &ny );
        return 0;
    }

    if (ctx->y_btsolve == NULL) { ctx->y_btsolve = (double*)FC_CALLOC(m, sizeof(double)); } else if (m > 0) { ctx->y_btsolve = (double*)FC_REALLOC(ctx->y_btsolve, m, sizeof(double)); }
    if (ctx->tag_btsolve == NULL) { ctx->tag_btsolve = (int*)FC_CALLOC(m, sizeof(int)); } else if (m > 0) { ctx->tag_btsolve = (int*)FC_REALLOC(ctx->tag_btsolve, m, sizeof(int)); }

    fc_Gauss_Eta_T( ctx, m, sy, iy, &ny );

    for (k=0; k<ny; k++) {
        i = ctx->icolperm[iy[k]];
        ctx->y_btsolve[i] = sy[k];
        ctx->tag_btsolve[i] = ctx->currtag_btsolve;
        fc_addtree(&ctx->tree, i);
    }

    if (ctx->rank < m) eps = FC_EPSSOL * fc_maxv(sy,ny);

    for (i=fc_getfirst(&ctx->tree); i < ctx->rank && i != -1; i=fc_getnext(&ctx->tree)) {
        beta = ctx->y_btsolve[i]/ctx->diagU[i];
        for (k=ctx->kUt[i]; k<ctx->kUt[i+1]; k++) {
            row = ctx->iUt[k];
            if (ctx->tag_btsolve[row] != ctx->currtag_btsolve) {
                ctx->y_btsolve[row] = 0.0;
                ctx->tag_btsolve[row] = ctx->currtag_btsolve;
                fc_addtree(&ctx->tree, row);
            }
            ctx->y_btsolve[row] -= ctx->Ut[k]*beta;
        }
        ctx->y_btsolve[i] = beta;
    }
    for (i=fc_getlast(&ctx->tree); i >= ctx->rank && i != -1; i=fc_getprev(&ctx->tree)) {
        if ( FC_ABS( ctx->y_btsolve[i] ) > eps ) consistent = 0;
        ctx->y_btsolve[i] = 0.0;
    }

    for ( ; i>=0; i=fc_getprev(&ctx->tree)) {
        beta = ctx->y_btsolve[i];
        for (k=ctx->kLt[i]; k<ctx->kLt[i+1]; k++) {
            row = ctx->iLt[k];
            if (ctx->tag_btsolve[row] != ctx->currtag_btsolve) {
                ctx->y_btsolve[row] = 0.0;
                ctx->tag_btsolve[row] = ctx->currtag_btsolve;
                fc_addtree(&ctx->tree, row);
            }
            ctx->y_btsolve[row] -= ctx->Lt[k]*beta;
        }
    }

    ny = 0;
    for (i=fc_getfirst(&ctx->tree); i != -1; i=fc_getnext(&ctx->tree)) {
        if ( FC_ABS(ctx->y_btsolve[i]) > FC_EPS ) {
            sy[ny] = ctx->y_btsolve[i];
            iy[ny] = ctx->rowperm[i];
            ny++;
        }
    }
    *pny = ny;

    ctx->currtag_btsolve++;
    fc_killtree(&ctx->tree);

    ctx->cumtime += (double)clock() - starttime;
    return consistent;
}

int fc_dbsolve(fc_lu_context_t *ctx, int m, double *y) {
    int i, k, row, consistent=1;
    double beta, *dwork;
    double eps=0;

    double starttime = (double)clock();

    dwork = (double*)FC_CALLOC(m, sizeof(double));

    if (ctx->rank < m) eps = FC_EPSSOL * fc_maxv(y,m);
    for (i=0; i<m; i++) dwork[i] = y[i];
    for (i=0; i<m; i++) y[ctx->irowperm[i]] = dwork[i];

    for (i=0; i<ctx->rank; i++) {
        beta = y[i];
        for (k=ctx->kL[i]; k<ctx->kL[i+1]; k++) {
            row = ctx->iL[k];
            y[row] -= ctx->L[k]*beta;
        }
    }

    for (i=m-1; i>=ctx->rank; i--) {
        if ( FC_ABS( y[i] ) > eps ) consistent = 0;
        y[i] = 0.0;
    }
    for (i=ctx->rank-1; i>=0; i--) {
        beta = y[i];
        for (k=ctx->kUt[i]; k<ctx->kUt[i+1]; k++) {
            beta -= ctx->Ut[k]*y[ctx->iUt[k]];
        }
        y[i] = beta/ctx->diagU[i];
    }

    for (i=0; i<m; i++) dwork[i] = y[i];
    for (i=0; i<m; i++) y[ctx->colperm[i]] = dwork[i];

    FC_FREE(dwork);

    ctx->cumtime += (double)clock() - starttime;
    return consistent;
}
