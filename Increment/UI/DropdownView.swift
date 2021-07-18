//
//  DropDownView.swift
//  Increment
//
//  Created by Tony Mu on 18/07/21.
//

import SwiftUI

struct DropdownView: View {
    var body: some View {
        VStack {
            HStack {
                Text("Exercise")
                    .font(.system(size: 22, weight: .semibold))
                Spacer()
            }.padding(.vertical, 10)
            Button(action: {
                
            },
            label: {
                HStack {
                    Text("Pushups")
                        .font(.system(size: 28, weight: .semibold))
                    Spacer()
                    Image(systemName: "arrowtriangle.down.circle")
                        .font(.system(size: 24, weight: .medium))
                }
            }).buttonStyle(PrimaryButtonStyle(fillColor: .primaryButton))
        }.padding(10)
    }
}


struct DropdownView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            DropdownView()
        }.environment(\.colorScheme, .light)
       
        NavigationView {
            DropdownView()
        }.environment(\.colorScheme, .dark)
    }
}
