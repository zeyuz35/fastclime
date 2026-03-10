#include <stdlib.h>
#include <stdio.h>
#include <sys/types.h>
#include <string.h>

/* Rprintf is used for debugging in the FREE macro, so ensure R headers
	are available when this header is included. */
#include <R.h>

#undef MALLOC
#define	MALLOC(name,len,type) {	\
	 size_t _safe_len = (len); \
	 (name) = (type *)malloc( (_safe_len > 0 ? _safe_len : 1) * sizeof(type) ); \
	 if ((name) == NULL) { \
		error("Memory allocation failed"); \
	 } \
}

#undef CALLOC
#define	CALLOC(name,len,type) { \
	 size_t _safe_len = (len); \
	 (name) = (type *)calloc( (_safe_len > 0 ? _safe_len : 1) , sizeof(type) ); \
	 if ((name) == NULL) { \
		error("Memory allocation failed"); \
	 } \
}

#undef REALLOC
#define	REALLOC(name,len,type) { \
	 size_t _safe_len = (len); \
	(name) = (type *)realloc((name), (_safe_len > 0 ? _safe_len : 1) * sizeof(type)); \
	if ((name) == NULL) { \
		error("Memory allocation failed"); \
	} \
}

#undef FREE
#define	FREE(name) { \
	if ((name) != NULL) { \
		free((name)); \
	} \
	(name) = NULL; \
}
