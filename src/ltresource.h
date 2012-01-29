/* Copyright (C) 2012 Ian MacLarty */
#ifndef LTRESOURCE_H
#define LTRESOURCE_H

#include <stdio.h>

#ifdef LTANDROID
#include <android/asset_manager.h>
#endif

#ifdef LTANDROID
struct LTResource {
    AAsset *asset;
    char *name;
};
void ltSetAssetManager(AAssetManager* mgr);
#else
struct LTResource {
    FILE *file;
    char *name;
};
#endif

// Returns NULL on failure.
LTResource *ltOpenResource(const char* filename);

// Returns bytes read, < 0 on error.
int ltReadResource(LTResource *rsc, void* buf, int count);

void ltCloseResource(LTResource *rsc);

#endif