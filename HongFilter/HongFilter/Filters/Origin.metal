//
//  Origin.metal
//  HongFilter
//
//  Created by KiWoong Hong on 2022/08/29.
//

#include <metal_stdlib>
#include <CoreImage/CoreImage.h>

using namespace metal;


extern "C" {
     namespace coreimage {
         half4 origin(sample_h s) {
             return half4(s.r, s.g, s.b, s.a);
         }
     }
}


