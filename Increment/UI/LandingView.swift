//
//  ContentView.swift
//  Increment
//
//  Created by Tony Mu on 17/07/21.
//

import SwiftUI

struct LandingView: View {
    @State private var isActive = false
    var body: some View {
        NavigationView {
            GeometryReader { proxy in
                VStack {
                    Spacer().frame(height: proxy.size.height * 0.18)
                    Text("Increment")
                        .font(.system(size: 64, weight: .medium))
                        .foregroundColor(.white)
                    Spacer()
                    NavigationLink(
                        destination: CreateView(),
                        isActive: $isActive) {
                        Button(action: {
                            isActive = true
                        }, label: {
                            HStack(spacing: 15) {
                                Spacer()
                                Image(systemName: "plus.circle")
                                    .font(.system(size: 24, weight: .semibold))
                                    .foregroundColor(.white)
                                Text("Create a Challenge")
                                    .font(.system(size: 24, weight: .semibold))
                                    .foregroundColor(.white)
                                Spacer()
                            }
                        })
                        .padding(15)
                        .buttonStyle(PrimaryButtonStyle())
                    }
                }.frame(
                    maxWidth:.infinity,
                    maxHeight: .infinity
                )
                .background(
                    Image("landingImage").resizable().aspectRatio(contentMode: .fill)
                        .overlay(Color.black.opacity(0.4))
                        .frame(width:proxy.size.width)
                        .edgesIgnoringSafeArea(.all)
                )
            }
        }.accentColor(.primary) // The nav back button color
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        LandingView().previewDevice("iPhone8")
        LandingView().previewDevice("iPhone12 Pro")
        LandingView().previewDevice("iPhone12 Pro Max")
    }
}
