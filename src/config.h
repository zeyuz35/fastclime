#ifndef FASTCLIME_CONFIG_H
#define FASTCLIME_CONFIG_H

#define FC_MAX(x,y)  ((x) > (y) ? (x) : (y))
#define FC_MIN(x,y)  ((x) > (y) ? (y) : (x))
#define FC_ABS(x)    ((x) > 0   ? (x) : -(x))
#define FC_SGN(x)    ((x) > 0   ? (1.0) : (-1.0))

#define FC_TRUE 1
#define FC_FALSE 0

#define FC_EPS1 1.0e-8
#define FC_EPS2 1.0e-12
#define FC_EPS3 1.0e-5

#endif // FASTCLIME_CONFIG_H
