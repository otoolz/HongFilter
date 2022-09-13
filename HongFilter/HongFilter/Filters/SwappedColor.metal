//
//  SwappedColor.metal
//  HongFilter
//
//  Created by KiWoong Hong on 2022/08/31.
//

#include <metal_stdlib>
#include <CoreImage/CoreImage.h>

using namespace metal;


extern "C" {
     namespace coreimage {
         half4 swappedRG(sample_h s) {
             half4 swappedRG;
             swappedRG.r = s.g;
             swappedRG.g = s.r;
             swappedRG.b = s.b;
             swappedRG.a = s.a;
             return swappedRG;
         }
         
         half4 swappedRB(sample_h s) {
             half4 swappedRB;
             swappedRB.r = s.b;
             swappedRB.g = s.g;
             swappedRB.b = s.r;
             swappedRB.a = s.a;
             return swappedRB;
         }
         
         half4 swappedGB(sample_h s) {
             half4 swappedGB;
             swappedGB.r = s.r;
             swappedGB.g = s.b;
             swappedGB.b = s.g;
             swappedGB.a = s.a;
             return swappedGB;
         }
     }
}
