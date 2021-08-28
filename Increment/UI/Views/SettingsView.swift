//
//  SettingsView.swift
//  Increment
//
//  Created by Tony Mu on 24/08/21.
//

import SwiftUI

struct SettingsView: View {
    @StateObject private var viewMdoel = SettingsViewModel()
    var body: some View {
        List(viewMdoel.itemViewModels.indices, id:\.self) { index in
            Button {
                viewMdoel.tappedItem(at: index)
            } label : {
                HStack {
                    let item = viewMdoel.item(at: index)
                    Image(systemName: item.iconName)
                    Text(item.title)
                }
            }
        }.background(
            NavigationLink(
                destination: LoginSignupView(viewModel: .init(mode: .singup)),
                isActive: $viewMdoel.loginSignupPushed
            ) {
                
            }
        )
        .navigationTitle(viewMdoel.title)
        .onAppear {
            viewMdoel.onAppear()
        }
    }
}
