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
            if !hongFilterViewModel.allImages.isEmpty && hongFilterViewModel.mainView != nil {
                Image(uiImage: hongFilterViewModel.mainView.image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: UIScreen.main.bounds.width)
                
                Spacer()
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 20) {
                        ForEach(hongFilterViewModel.allImages) { filtered in
                            Image(uiImage: filtered.image)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 150, height: 150)
                            
                            //Updating MainView...
                            //WhenEver Button
                                .onTapGesture {
                                    hongFilterViewModel.mainView = filtered
                                }
                        }
                    }
                    .padding()
                }
            } else {
                Text("앨범에서 사진을 고르세요!")
            }
            Spacer()
            
            HStack {
                Button(action: {hongFilterViewModel.imagePicker.toggle()}) {
                    Text("Photo")
                        .font(.title2)
                }
                Spacer()
                Button(action: {UIImageWriteToSavedPhotosAlbum(hongFilterViewModel.mainView.image, nil, nil, nil)}) {
                    Text("Save")
                        .font(.title2)
                }
            }.padding(25)
        }
        .onChange(of: hongFilterViewModel.imageData, perform: { (_) in
            // when ever image is changed firing loadImage...
            
            // clearing exisiting data...
            hongFilterViewModel.allImages.removeAll()
            hongFilterViewModel.mainView = nil
            hongFilterViewModel.loadFilter()
        })
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
