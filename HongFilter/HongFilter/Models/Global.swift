//
//  Global.swift
//  HongFilter
//
//  Created by KiWoong Hong on 2022/08/29.
//

import SwiftUI

enum Global {
    static var screenWidth: CGFloat {
        UIScreen.main.bounds.size.width
    }
    
    static var screenHeight: CGFloat {
        UIScreen.main.bounds.size.height
    }
    
    static var imageWidth: CGFloat {
        screenWidth
    }
    
    static var imageHeight: CGFloat {
        screenWidth * 4 / 3
    }
    
    static var filterButtonWidth: CGFloat {
        screenWidth / 9
    }
}
