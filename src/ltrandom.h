/* Copyright (C) 2010 Ian MacLarty */
#ifndef LTRANDOM_H
#define LTRANDOM_H

#include "ltcommon.h"

struct LTRandomGenerator : LTObject {
    
    LTRandomGenerator(int seed);
    virtual ~LTRandomGenerator();

    int nextInt(int n); // returns an int between 0 and n - 1.
    bool nextBool();
    LTdouble nextDouble(); // returns a double in the range [0.0, 1.0).
    LTfloat nextFloat(); // returns a float in the range [0.0f, 1.0f).

private:
    int *ran_x;
    int *ran_arr_buf;
    int *ran_arr_ptr;
    void ran_start(int seed);
    void ran_array(int *aa, int n);
    int ran_arr_cycle();
};

#endif
