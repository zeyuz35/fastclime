#include "tree.h"
#include "memory.h"
#include "config.h"

void fc_tree_init(fc_tree_t *tree) {
    if (tree) {
        tree->root = NULL;
        tree->curnode = NULL;
    }
}

static void killnode(TNODE *node) {
    if (node->left  != NULL) killnode(node->left);
    if (node->right != NULL) killnode(node->right);
    if (node != NULL) FC_FREE(node);
}

void fc_killtree(fc_tree_t *tree) {
    if (tree->root != NULL) killnode(tree->root);
    tree->root = NULL;
    tree->curnode = NULL;
}

void fc_addtree(fc_tree_t *tree, int data) {
    TNODE *node = tree->root;
    TNODE *parent = NULL;

    if (tree->root == NULL) {
        tree->root = (TNODE*)FC_CALLOC(1, sizeof(TNODE));
        tree->root->data   = data;
        tree->root->parent = NULL;
        tree->root->left   = NULL;
        tree->root->right  = NULL;
        return;
    }
    while (node != NULL) {
        if (node->data > data) { parent = node; node = node->left; }
        else if (node->data < data) { parent = node; node = node->right; }
        else { return; }    
    }

    node = (TNODE*)FC_CALLOC(1, sizeof(TNODE));
    node->data   = data;
    node->parent = parent;
    node->left   = NULL;
    node->right  = NULL;
    if (parent->data > data) { parent->left  = node; }
    else                     { parent->right = node; }
}

void fc_deltree(fc_tree_t *tree, int data) {
    TNODE *node   = tree->root;
    TNODE *parent = NULL;
    TNODE *node1, *node2;

    while (node != NULL && node->data != data) {
        if (node->data > data) { node = node->left; }
        else if (node->data < data) { node = node->right; }
    }

    if (node == NULL) { return; }  

    parent = node->parent;

    if (node->right == NULL) {
        node1 = node->left;
        if (node1 != NULL) { node1->parent = parent; }
    } else if (node->left == NULL) {
        node1 = node->right;
        node1->parent = parent;
    } else {
        node1 = node->left;
        for (node2 = node1; node2->right != NULL; node2 = node2->right) { }
        node2->right = node->right;
        node->right->parent = node2;
        node->left->parent = parent;
    }
    
    if (parent == NULL) {
        tree->root = node1;
    } else {
        if (parent->data > data) { parent->left  = node1; }
        else                     { parent->right = node1; }
    }

    FC_FREE(node);
}

int fc_getfirst(fc_tree_t *tree) {
    TNODE *node;
    TNODE *parent = NULL;

    if (tree->root == NULL) { return -1; }

    for (node=tree->root; node!=NULL; parent=node, node=node->left) { }
    tree->curnode = parent;
    return tree->curnode->data;
}

int fc_getnext(fc_tree_t *tree) {
    TNODE *node;
    TNODE *par = NULL;

    if (tree->curnode == NULL) { return -1; }

    if (tree->curnode->right != NULL) {
        for (node=tree->curnode->right; node!=NULL; par=node, node=node->left) { }
        tree->curnode = par;
        return tree->curnode->data;
    }
    for (node=tree->curnode->parent; node!=NULL; node=node->parent) {
         if (node->data > tree->curnode->data) break;
    }
    tree->curnode = node;
    if (tree->curnode != NULL) {
        return tree->curnode->data;
    } else {
        return -1;      
    }
}

int fc_getlast(fc_tree_t *tree) {
    TNODE *node;
    TNODE *parent = NULL;

    if (tree->root == NULL) { return -1; }

    for (node=tree->root; node!=NULL; parent=node, node=node->right) { }
    tree->curnode = parent;
    return tree->curnode->data;
}

int fc_getprev(fc_tree_t *tree) {
    TNODE *node;
    TNODE *par = NULL;

    if (tree->curnode == NULL) { return -1; }

    if (tree->curnode->left != NULL) {
        for (node=tree->curnode->left; node!=NULL; par=node, node=node->right) { }
        tree->curnode = par;
        return tree->curnode->data;
    }
    for (node=tree->curnode->parent; node!=NULL; node=node->parent) {
         if (node->data < tree->curnode->data) break;
    }
    tree->curnode = node;
    if (tree->curnode != NULL) {
        return tree->curnode->data;
    } else {
        return -1;      
    }
}
