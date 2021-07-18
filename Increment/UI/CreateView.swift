//
//  CreateView.swift
//  Increment
//
//  Created by Tony Mu on 18/07/21.
//

import SwiftUI

struct CreateView: View {
    @State private var isActive = false
    var body: some View {
        ScrollView {
            VStack {
                DropdownView()
                DropdownView()
                DropdownView()
                DropdownView()
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
