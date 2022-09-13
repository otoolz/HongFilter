//
//  HongFilterApp.swift
//  HongFilter
//
//  Created by KiWoong Hong on 2022/08/28.
//

import SwiftUI

@main
struct HongFilterApp: App {
  //  @StateObject var hongFilterViewModel = HongFilterViewModel()
    @StateObject var homeViewModel = HomeViewModel()
    var body: some Scene {
        WindowGroup {
            //MainView()
            //    .environmentObject(hongFilterViewModel)
            NavigationView {
                Home()
                    .navigationBarTitle("Filter")
                    .preferredColorScheme(.dark)
                    .environmentObject(homeViewModel)
            }
        }
    }
}
