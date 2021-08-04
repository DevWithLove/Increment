//
//  CreateView.swift
//  Increment
//
//  Created by Tony Mu on 18/07/21.
//

import SwiftUI

struct CreateView: View {
    @StateObject var viewModel = CreateChallengeViewModel()
    
    var dropdownList: some View {
        Group {
            DropdownView(viewModel: $viewModel.execriseDropdown)
            DropdownView(viewModel: $viewModel.startAmountDropdown)
            DropdownView(viewModel: $viewModel.increaseDropdown)
            DropdownView(viewModel: $viewModel.lengthDropdown)
        }
    }
    
    var body: some View {
        ScrollView {
            VStack {
                dropdownList
                Spacer()
                Button(action: {
                    viewModel.send(action: .createChallenge)
                }) {
                    Text("Create")
                        .font(.system(size: 24, weight: .medium))
                        .foregroundColor(.primary)
                }
                
            }
            .navigationBarTitle(Text("Create"))
            .navigationBarBackButtonHidden(true)
            .padding(.bottom, 15)
        }
    }
}

struct CreateView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            CreateView()
        }.environment(\.colorScheme, .light)
        
        NavigationView {
            CreateView()
        }.environment(\.colorScheme, .dark)
    }
}
