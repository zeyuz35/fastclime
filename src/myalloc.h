#include <stdlib.h>
#include <stdio.h>
#include <sys/types.h>
#include <string.h>

/* Rprintf is used for debugging in the FREE macro, so ensure R headers
	are available when this header is included. */
#include <R.h>

#undef MALLOC
#define	MALLOC(name,len,type) do {	\
	 size_t _safe_len = (size_t)(len); \
	 _safe_len = _safe_len > 0 ? _safe_len : 1; \
	 if (_safe_len > ((size_t)-1) / sizeof(type)) { \
		error("Memory allocation failed due to integer overflow"); \
	 } \
	 (name) = (type *)malloc( _safe_len * sizeof(type) ); \
	 if ((name) == NULL) { \
		error("Memory allocation failed"); \
	 } \
} while (0)

#undef CALLOC
#define	CALLOC(name,len,type) do { \
	 size_t _safe_len = (size_t)(len); \
	 _safe_len = _safe_len > 0 ? _safe_len : 1; \
	 if (_safe_len > ((size_t)-1) / sizeof(type)) { \
		error("Memory allocation failed due to integer overflow"); \
	 } \
	 (name) = (type *)calloc( _safe_len , sizeof(type) ); \
	 if ((name) == NULL) { \
		error("Memory allocation failed"); \
	 } \
} while (0)

#undef REALLOC
#define	REALLOC(name,len,type) do { \
	 size_t _safe_len = (size_t)(len); \
	 _safe_len = _safe_len > 0 ? _safe_len : 1; \
	 if (_safe_len > ((size_t)-1) / sizeof(type)) { \
		error("Memory allocation failed due to integer overflow"); \
	 } \
	 void *_new_ptr = realloc((name), _safe_len * sizeof(type)); \
	 if (_new_ptr == NULL) { \
		error("Memory allocation failed"); \
	 } \
	 (name) = (type *)_new_ptr; \
} while (0)

#undef FREE
#define	FREE(name) { \
	if ((name) != NULL) { \
		free((name)); \
	} \
	(name) = NULL; \
}
