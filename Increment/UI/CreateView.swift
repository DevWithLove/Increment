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
        ForEach(viewModel.dropdowns.indices, id: \.self) { index in
            DropdownView(viewModel: $viewModel.dropdowns[index])
        }
    }
    
    var actionSheet: ActionSheet {
        ActionSheet(title: Text("Selected"),
                    message: nil,
                    buttons: viewModel.displayedOptions.indices.map { index in
                        let option = viewModel.displayedOptions[index]
                        return ActionSheet.Button.default(Text(option.formatted)) {
                            viewModel.send(action: .selectOption(index: index))
                        }
                    })
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
            .actionSheet(
                isPresented: Binding<Bool> (
                    get: {
                        viewModel.hasSelectedDropdown
                    }, set: { _ in })
            ) {
                actionSheet
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
