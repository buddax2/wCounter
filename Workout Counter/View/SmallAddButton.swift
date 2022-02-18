//
//  SmallAddButton.swift
//  Workout Counter
//
//  Created by Oleksandr Yakubchyk on 12.02.2022.
//

import SwiftUI

struct SmallAddButton: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25)
                .frame(width: 200, height: 50)
                .foregroundColor(.green)

            Image(systemName: "plus")
                .foregroundColor(Color.white)
                .frame(width: 50)
        }
        .frame(height: 60)
    }
}

struct SmallAddButton_Previews: PreviewProvider {
    static var previews: some View {
        SmallAddButton()
    }
}
