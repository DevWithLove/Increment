//
//  CreateView.swift
//  Increment
//
//  Created by Tony Mu on 18/07/21.
//

import SwiftUI

struct CreateView: View {
    @StateObject var viewModel = CreateChallengeViewModel()
    @State private var isActive = false
    
    var dropdownList: some View {
        ForEach(viewModel.dropdowns.indices, id: \.self) { index in
            DropdownView(viewModel: $viewModel.dropdowns[index])
        }
    }
    
    var body: some View {
        ScrollView {
            VStack {
                dropdownList
                Spacer()
                NavigationLink(
                    destination: RemindView(),
                    isActive: $isActive) {
                    Button(action: { isActive = true }) {
                        Text("Next")
                            .font(.system(size: 24, weight: .medium))
                            .foregroundColor(.primary)
                    }
                }
            }.navigationBarTitle(Text("Create"))
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
