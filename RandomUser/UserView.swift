//
//  UserView.swift
//  RandomUser
//
//  Created by Haoming Ma on 13/11/19.
//  Copyright © 2019 Haoming. All rights reserved.
//

import SwiftUI
import struct Kingfisher.KFImage

struct UserView: View {
    
    var name: String
    var email: String
    var avatarUrl: URL?
    
    init(user: UserEntity) {
        self.name = user.firstName + " " + user.lastName
        self.email = user.email ?? ""
        self.avatarUrl = user.avatarUrl
    }
    
    var body: some View {
        HStack{
            KFImage(self.avatarUrl)
                .resizable()
                .frame(width: 128, height: 128)
                .cornerRadius(20)
                .shadow(radius: 5)
            VStack(alignment: .leading) {
                Text(name).font(.headline)
                Text(email).font(.caption)
            }
        }
    }
}
