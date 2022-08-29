//
//  ContentView.swift
//  HongFilter
//
//  Created by KiWoong Hong on 2022/08/28.
//

import SwiftUI

struct MainView: View {
    @EnvironmentObject var hongFilterViewModel: HongFilterViewModel
    var body: some View {
        VStack {
            Text("앨범에서 사진을 고르세요!")
            HStack {
                Button(action: {hongFilterViewModel.imagePicker.toggle()}) {
                    Image(systemName: "photo")
                        .font(.title2)
                }
            }
        }
        .sheet(isPresented: $hongFilterViewModel.imagePicker) {
            ImagePicker(picker: $hongFilterViewModel.imagePicker, imageData: $hongFilterViewModel.imageData)
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
