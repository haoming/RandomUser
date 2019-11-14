//
//  UserView.swift
//  RandomUser
//
//  Created by Haoming Ma on 13/11/19.
//  Copyright © 2019 Haoming. All rights reserved.
//

import SwiftUI

struct UserView: View {
    var name: String
    var email: String
    
    init(user: UserEntity) {
        self.name = user.firstName + " " + user.lastName
        self.email = user.email ?? ""
    }
    
    var body: some View {
        HStack{
            VStack(alignment: .leading) {
                Text(name).font(.headline)
                Text(email).font(.caption)
            }
        }
    }
}
