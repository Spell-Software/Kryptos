//
//  mathProccessing.metal
//  Kryptos
//
//  Created by Craig Spell on 8/29/19.
//  Copyright © 2019 Spell Software Inc. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;

kernel void add_arrays(device const int32_t* inA,
                       device const int32_t* inB,
                       device const int32_t* alphabetLength,
                       device int32_t* result,
                       uint index [[thread_position_in_grid]])
{
    // the for-loop is replaced with a collection of threads, each of which
    // calls this function.
    int32_t i = inA[index] + inB[index];

    if (i > *alphabetLength) {
        i -= *alphabetLength;
    }
    result[index] = i;
}

kernel void subtract_arrays(device const int32_t* inA,
                            device const int32_t* inB,
                            device const int32_t* alphabetLength,
                            device int32_t* result,
                            uint index [[thread_position_in_grid]])
{
        // the for-loop is replaced with a collection of threads, each of which
        // calls this function.
    int32_t i = inA[index] - inB[index];

    if (i < 0) {
        i += *alphabetLength;
    }
    result[index] = i;
}

