//
//  HongFilterModel.swift
//  HongFilter
//
//  Created by KiWoong Hong on 2022/08/29.
//

import SwiftUI
import CoreImage
import CoreImage.CIFilterBuiltins

struct HongFilterImage: Identifiable, Hashable {
    var id = UUID().uuidString
    var image: UIImage
    var filter: CIFilter
}
