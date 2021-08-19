//
//  DropDownView.swift
//  Increment
//
//  Created by Tony Mu on 18/07/21.
//

import SwiftUI

struct DropdownView<T: DropdownItemProtocol>: View {
    @Binding var viewModel: T
    
    var actionSheet: ActionSheet {
        ActionSheet(title: Text("Selected"),
                    message: nil,
                    buttons: viewModel.options.map { option in
                        return ActionSheet.Button.default(Text(option.formatted)) {
                            viewModel.selectedOption = option
                        }
                    })
    }
    
    var body: some View {
        VStack {
            HStack {
                Text(viewModel.headerTitle)
                    .font(.system(size: 22, weight: .semibold))
                Spacer()
            }.padding(.vertical, 10)
            Button(action: {
                viewModel.isSelected = true
            },
            label: {
                HStack {
                    Text(viewModel.dropdownTitle)
                        .font(.system(size: 28, weight: .semibold))
                    Spacer()
                    Image(systemName: "arrowtriangle.down.circle")
                        .font(.system(size: 24, weight: .medium))
                }
            }).buttonStyle(PrimaryButtonStyle(fillColor: .primaryButton))
        }
        .actionSheet(isPresented: $viewModel.isSelected ){
            actionSheet
        }.padding(10)
    }
}


struct DropdownView_Previews: PreviewProvider {
   
    static var previews: some View {
        let viewModel = CreateChallengeViewModel.ChallengePartViewModel(type: .execrise)
        NavigationView {
            DropdownView(viewModel: .constant(viewModel))
        }.environment(\.colorScheme, .light)

        NavigationView {
            DropdownView(viewModel: .constant(viewModel))
        }.environment(\.colorScheme, .dark)
    }
}
