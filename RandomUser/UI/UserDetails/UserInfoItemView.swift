//
//  UserInfoItemView.swift
//  RandomUser
//
//  Created by Haoming Ma on 16/11/19.
//  Copyright © 2019 Haoming. All rights reserved.
//

import SwiftUI

struct UserInfoItemView: View {
    private let label: String
    private let value: String?
    
    init(label: String, value: String?) {
        self.label = label
        self.value = value
    }
    
    var body: some View {
        HStack(alignment: .firstTextBaseline) {
            Text(label).font(.headline).fontWeight(.bold)
            Spacer()
            Text(value ?? "").font(.subheadline)
        }.padding(.init(top: 16, leading: 8, bottom: 16, trailing: 8))
    }
}
