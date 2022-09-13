//
//  Home.swift
//  FilterTest
//
//  Created by KiWoong Hong on 2022/08/23.
//

import SwiftUI

struct Home: View {
    @EnvironmentObject var homeData: HomeViewModel
    
    @State var currentFilterName: String = ""
    var body: some View {
        VStack {
            
            if !homeData.allImages.isEmpty && homeData.mainView != nil {
                
                Image(uiImage: homeData.mainView.image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: UIScreen.main.bounds.width)
                    
                Spacer()
                
                Text(currentFilterName)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 5) {
                        Rectangle()
                            .frame(width: 100, height: 100)
                            .onTapGesture {
                                homeData.mainView = homeData.rmBGView
                                currentFilterName = "space bg"
                            }
                        ForEach(homeData.allImages) { filtered in
                            Image(uiImage: filtered.image)
                                .resizable()
                                .frame(width: 100, height: 100)
                                .onTapGesture {
                                    homeData.mainView = filtered
                                    currentFilterName = filtered.filter.name
                                }
                        }
                    }
                    .padding()
                }
            }
            if homeData.imageData.count == 0 {
                Text("앨범에서 사진을 고르세요 !!!")
            }
            /*
            spacer()
             hstack {}
             
             */
        }
      //  .onChange(of: homeData.value, perform: { (_) in
     //       homeData.updateEffect()
     //   })
        .onChange(of: homeData.imageData, perform: { (_) in
            // when ever image is changed firing loadImage...
            
            // clearing exisiting data...
            homeData.inputImage = UIImage(data: homeData.imageData)!
            homeData.runVisionRequest()
            homeData.allImages.removeAll()
            homeData.mainView = nil
            homeData.loadFilter()
        })
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {homeData.imagePicker.toggle()}) {
                    Image(systemName: "photo")
                        .font(.title2)
                }
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {UIImageWriteToSavedPhotosAlbum(homeData.mainView.image, nil, nil, nil)}) {
                    Image(systemName: "square.and.arrow.up.fill")
                        .font(.title2)
                }
                .disabled(homeData.mainView == nil ? true : false)
            }
        }
        .sheet(isPresented: $homeData.imagePicker) {
            ImagePicker(picker: $homeData.imagePicker, imageData: $homeData.imageData)
        }
    }
}
