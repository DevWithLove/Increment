//
//  ContentView.swift
//  Increment
//
//  Created by Tony Mu on 17/07/21.
//

import SwiftUI

struct LandingView: View {
    @StateObject private var viewModel = LandingViewModel()
    
    var title: some View {
        Text("Increment")// todo: move to vm
            .font(.system(size: 64, weight: .medium))
            .foregroundColor(.white)
    }
    
    var createButton: some View {
        Button(action: {
            viewModel.createPushed = true
        }, label: {
            HStack(spacing: 15) {
                Spacer()
                Image(systemName: "plus.circle") // move to vm
                    .font(.system(size: 24, weight: .semibold))
                    .foregroundColor(.white)
                Text("Create a Challenge")// move to vm
                    .font(.system(size: 24, weight: .semibold))
                    .foregroundColor(.white)
                Spacer()
            }
        })
        .padding(15)
        .buttonStyle(PrimaryButtonStyle())
    }
    
    var alreadyButton: some View {
        Button("I already have an account") { //move to vm
            // trigger push
            viewModel.loginSignupPushed = true
        }.foregroundColor(.white)
    }
    
    var backgroundImage: some View {
        Image("landingImage").resizable().aspectRatio(contentMode: .fill)
            .overlay(Color.black.opacity(0.4))
    }
    
    var body: some View {
        NavigationView {
            GeometryReader { proxy in
                VStack {
                    Spacer().frame(height: proxy.size.height * 0.18)
                    title
                    Spacer()
                    NavigationLink(
                        destination: CreateView(),
                        isActive: $viewModel.createPushed) {}
                    createButton
                    NavigationLink( destination: LoginSignupView(viewModel: .init(mode: .login, isPushed: $viewModel.loginSignupPushed)),
                                    isActive: $viewModel.loginSignupPushed) {
                    }
                    alreadyButton
                }
                .padding(.bottom, 15)
                .frame(
                    maxWidth:.infinity,
                    maxHeight: .infinity
                )
                .background(
                        backgroundImage
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
