//
//  HongFilterModel.swift
//  HongFilter
//
//  Created by KiWoong Hong on 2022/08/29.
//

import SwiftUI
import CoreImage
import CoreImage.CIFilterBuiltins

enum HongFilter: CaseIterable {
    case origin
    case gaussianBlur
    case bloom
    
    var name: String {
        switch self {
        case .origin : return "origin"
        case .gaussianBlur : return "gaussianBlur"
        case .bloom : return "bloom"
        }
    }
    
    var filter: CIFilter {
        switch self {
        case .origin : return Origin()
        case .bloom : return CIFilter.bloom()
        case .gaussianBlur : return CIFilter.gaussianBlur()
        }
    }
}

struct HongFilterImage: Identifiable {
    var id = UUID().uuidString
    var image: UIImage
    var filter: CIFilter
}
