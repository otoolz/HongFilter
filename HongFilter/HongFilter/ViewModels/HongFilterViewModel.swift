//
//  HongFilterViewModel.swift
//  HongFilter
//
//  Created by KiWoong Hong on 2022/08/29.
//

import SwiftUI
import CoreImage

class HongFilterViewModel: ObservableObject {
    @Published var imagePicker = false
    @Published var imageData = Data(count: 0)
    
    let context = CIContext()
}
