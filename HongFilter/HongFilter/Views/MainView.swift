//
//  ContentView.swift
//  HongFilter
//
//  Created by KiWoong Hong on 2022/08/28.
//

import SwiftUI

struct MainView: View {
    @EnvironmentObject var hongFilterViewModel: HongFilterViewModel
    @State var currentFilterName: String = ""
    var body: some View {
        VStack {
            if hongFilterViewModel.mainView != nil {
                Image(uiImage: hongFilterViewModel.mainView.image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: Global.imageWidth, height: Global.imageHeight)
                
                Spacer()
                
                Text(currentFilterName)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 5) {
                        Image("icon")
                            .resizable()
                            .frame(width: Global.filterButtonWidth, height: Global.filterButtonWidth)
                            .onTapGesture {
                                hongFilterViewModel.mainView = hongFilterViewModel.rmBGView
                                currentFilterName = "space background"
                            }
                        ForEach(hongFilterViewModel.allImages, id: \.self) { filtered in
                            Image(uiImage: filtered.image)
                                .resizable()
                                .frame(width: Global.filterButtonWidth, height: Global.filterButtonWidth)
                                .onTapGesture {
                                    hongFilterViewModel.mainView = filtered
                                    currentFilterName = filtered.filter.name
                                }
                                .onAppear(perform: {
                                    if currentFilterName == "" {
                                        currentFilterName = filtered.filter.name
                                    }
                                })
                        }
                    }
                    .padding()
                }
            } else {
                Spacer()
                Text("앨범에서 사진을 고르세요!")
                Spacer()
            }
            Spacer()
           
            HStack {
            
                Button(action: {hongFilterViewModel.imagePicker.toggle()}) {
                    Text("사진")
                        .font(.title3)
                }
                Spacer()
                Button(action: {UIImageWriteToSavedPhotosAlbum(hongFilterViewModel.mainView.image, nil, nil, nil)}) {
                    Text("저장")
                        .font(.title3)
                }
                .disabled(hongFilterViewModel.mainView == nil ? true : false)
            }.padding(25)
        }
        .onChange(of: hongFilterViewModel.imageData, perform: { (_) in
            hongFilterViewModel.inputImage = UIImage(data: hongFilterViewModel.imageData)!
            hongFilterViewModel.runVisionRequest()
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

