#ifndef FASTCLIME_MEMORY_H
#define FASTCLIME_MEMORY_H

#include <stdlib.h>
#include <stdint.h>
#include <R.h>

static inline void* fc_malloc_safe(size_t n, size_t size) {
    if (n == 0) n = 1;
    if (size == 0) size = 1;
    if (n > ((size_t)-1) / size) { error("Allocation size overflow"); }
    void* ptr = malloc(n * size);
    if (!ptr) { error("Memory allocation failed"); }
    return ptr;
}

static inline void* fc_calloc_safe(size_t n, size_t size) {
    if (n == 0) n = 1;
    if (size == 0) size = 1;
    if (n > ((size_t)-1) / size) { error("Allocation size overflow"); }
    void* ptr = calloc(n, size);
    if (!ptr) { error("Memory allocation failed"); }
    return ptr;
}

static inline void* fc_realloc_safe(void* old_ptr, size_t n, size_t size) {
    if (n == 0) n = 1;
    if (size == 0) size = 1;
    if (n > ((size_t)-1) / size) { error("Allocation size overflow"); }
    void* new_ptr = realloc(old_ptr, n * size);
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
