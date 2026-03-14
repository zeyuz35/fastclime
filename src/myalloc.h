#include <stdlib.h>
#include <stdio.h>
#include <sys/types.h>
#include <string.h>

/* Rprintf is used for debugging in the FREE macro, so ensure R headers
	are available when this header is included. */
#include <R.h>

#undef MALLOC
#define	MALLOC(name,len,type) {	\
	 /* Prevent NULL return on zero-length request, mitigating a fatal error DoS */ \
	 size_t _myalloc_safe_len = (len); \
	 _myalloc_safe_len = _myalloc_safe_len > 0 ? _myalloc_safe_len : 1; \
	 (name) = (type *)malloc( _myalloc_safe_len * sizeof(type) ); \
	 if ((name) == NULL) { \
		error("Memory allocation failed"); \
	 } \
}

#undef CALLOC
#define	CALLOC(name,len,type) { \
	 /* Prevent NULL return on zero-length request, mitigating a fatal error DoS */ \
	 size_t _myalloc_safe_len = (len); \
	 _myalloc_safe_len = _myalloc_safe_len > 0 ? _myalloc_safe_len : 1; \
	 (name) = (type *)calloc( _myalloc_safe_len , sizeof(type) ); \
	 if ((name) == NULL) { \
		error("Memory allocation failed"); \
	 } \
}

#undef REALLOC
#define	REALLOC(name,len,type) { \
	 /* Prevent NULL return on zero-length request, mitigating a fatal error DoS */ \
	 size_t _myalloc_safe_len = (len); \
	 _myalloc_safe_len = _myalloc_safe_len > 0 ? _myalloc_safe_len : 1; \
	 (name) = (type *)realloc((name), _myalloc_safe_len * sizeof(type)); \
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
