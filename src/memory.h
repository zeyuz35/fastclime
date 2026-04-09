#ifndef FASTCLIME_MEMORY_H
#define FASTCLIME_MEMORY_H

#include <stdlib.h>
#include <stdint.h>
#include <R.h>

static inline void* fc_malloc_safe(size_t n, size_t size) {
    size_t _safe_n = n > 0 ? n : 1;
    size_t _safe_size = size > 0 ? size : 1;
    if (_safe_n > ((size_t)-1) / _safe_size) { error("Allocation size overflow"); }
    void* ptr = malloc(_safe_n * _safe_size);
    if (!ptr) { error("Memory allocation failed"); }
    return ptr;
}

static inline void* fc_calloc_safe(size_t n, size_t size) {
    size_t _safe_n = n > 0 ? n : 1;
    size_t _safe_size = size > 0 ? size : 1;
    if (_safe_n > ((size_t)-1) / _safe_size) { error("Allocation size overflow"); }
    void* ptr = calloc(_safe_n, _safe_size);
    if (!ptr) { error("Memory allocation failed"); }
    return ptr;
}

static inline void* fc_realloc_safe(void* old_ptr, size_t n, size_t size) {
    size_t _safe_n = n > 0 ? n : 1;
    size_t _safe_size = size > 0 ? size : 1;
    if (_safe_n > ((size_t)-1) / _safe_size) { error("Allocation size overflow"); }
    void* new_ptr = realloc(old_ptr, _safe_n * _safe_size);
    if (!new_ptr) { error("Memory allocation failed"); }
    return new_ptr;
}

#define FC_MALLOC(n, size) fc_malloc_safe((n), (size))
#define FC_CALLOC(n, size) fc_calloc_safe((n), (size))
#define FC_REALLOC(ptr, n, size) fc_realloc_safe((ptr), (n), (size))

// Free and nullify macro.
#define FC_FREE(ptr) do { \
    if ((ptr) != NULL) { \
        free((ptr)); \
        (ptr) = NULL; \
    } \
} while(0)

#endif // FASTCLIME_MEMORY_H
