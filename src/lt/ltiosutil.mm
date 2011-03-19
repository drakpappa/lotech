#import <UIKit/UIKit.h>

#include "ltiosutil.h"
#include "ltutil.h"

static float scaling() {
    float scale = 1.0f;
    if([[UIScreen mainScreen] respondsToSelector: NSSelectorFromString(@"scale")]) {
        scale = [[UIScreen mainScreen] scale];
    }
    return scale;
}

bool ltIsIPad() {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        return true;
    } else {
        return false;
    }
}

bool ltIsRetinaIPhone() {
    return !ltIsIPad() && scaling() == 2.0f;
}

int ltIOSScreenWidth() {
    float scale = scaling();
    if (ltIsIPad()) {
        return (int)(768.0f * scale);
    } else {
        return (int)(320.0f * scale);
    }
}

int ltIOSScreenHeight() {
    float scale = scaling();
    if (ltIsIPad()) {
        return (int)(1024.0f * scale);
    } else {
        return (int)(480.0f * scale);
    }
}

void ltNormalizeIOSTouchCoords(float x, float y, float *nx, float *ny) {
    if (ltIsIPad()) {
        *nx = (x / 768.0f) * 2.0f - 1.0f;
        *ny = (1.0f - (y / 1024.0f)) * 2.0f - 1.0f;
    } else {
        *nx = (x / 320.0f) * 2.0f - 1.0f;
        *ny = (1.0f - (y / 480.0f)) * 2.0f - 1.0f;
    }
}

const char *ltIOSDocPath(const char *file, const char *suffix) {
    NSArray *dirs = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    const char *dir = [[dirs objectAtIndex:0] UTF8String];
    int len = strlen(dir) + strlen(file) + 2;
    if (suffix != NULL) {
        len += strlen(suffix);
    }
    char *path = new char[len];
    if (suffix == NULL) {
        snprintf(path, len, "%s/%s", dir, file);
    } else {
        snprintf(path, len, "%s/%s%s", dir, file, suffix);
    }
    return path;
}

const char *ltIOSBundlePath(const char *file, const char *suffix) {
    #ifdef LTDEVMODE
    const char *docpath = ltIOSDocPath(file, suffix);
    #endif
    const char *dir = [[[NSBundle mainBundle] bundlePath] UTF8String];
    int len = strlen(dir) + strlen(file) + 2;
    if (suffix != NULL) {
        len += strlen(suffix);
    }
    char *path = new char[len];
    if (suffix == NULL) {
        snprintf(path, len, "%s/%s", dir, file);
    } else {
        snprintf(path, len, "%s/%s%s", dir, file, suffix);
    }
    #ifdef LTDEVMODE
    if (ltFileExists(docpath) || !ltFileExists(path)) {
        delete[] path;
        path = (char*)docpath;
    } else {
        delete[] docpath;
    }
    #endif
    return path;
}
