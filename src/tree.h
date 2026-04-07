#ifndef FASTCLIME_TREE_H
#define FASTCLIME_TREE_H

typedef struct tnode {
    int           data;
    struct tnode *parent;
    struct tnode *left;
    struct tnode *right;
} TNODE;

typedef struct {
    TNODE *root;
    TNODE *curnode;
} fc_tree_t;

void fc_tree_init(fc_tree_t *tree);
void fc_killtree(fc_tree_t *tree);
void fc_addtree(fc_tree_t *tree, int data);
void fc_deltree(fc_tree_t *tree, int data);

int fc_getfirst(fc_tree_t *tree);
int fc_getnext(fc_tree_t *tree);
int fc_getlast(fc_tree_t *tree);
int fc_getprev(fc_tree_t *tree);

#endif // FASTCLIME_TREE_H
