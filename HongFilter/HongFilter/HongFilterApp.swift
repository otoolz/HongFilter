//
//  HongFilterApp.swift
//  HongFilter
//
//  Created by KiWoong Hong on 2022/08/28.
//

import SwiftUI

@main
struct HongFilterApp: App {
    @StateObject var hongFilterViewModel = HongFilterViewModel()
    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(hongFilterViewModel)
        }
    }
}
