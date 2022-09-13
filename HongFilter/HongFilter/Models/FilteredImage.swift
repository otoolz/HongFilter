//
//  FilteredImage.swift
//  FilterTest
//
//  Created by KiWoong Hong on 2022/08/24.
//

import SwiftUI
import CoreImage

struct FilterdImage: Identifiable {
    var id = UUID().uuidString  // id 가 왜 필요하지?
    var image: UIImage
    var filter: CIFilter
}
