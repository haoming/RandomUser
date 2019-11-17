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
    
    let user: User
    
    init(user: User) {
        self.user =  user
    }
    
    var body: some View {
        HStack{
            KFImage(self.user.avatarUrl)
                .placeholder{
                    Image(systemName: "person")
                    .font(.largeTitle)
                    .opacity(0.3)
                }
                .resizable()
                .frame(width: 96, height: 96)
                .cornerRadius(20)
                .shadow(radius: 5)
            VStack(alignment: .leading) {
                Text(self.user.fullName).font(.headline).padding(.bottom, 4)
                
                // SwiftUI complains in function builder here if we use  if let dateOfBirth = self.user.dateOfBirth
                if self.user.dateOfBirth != nil {
                    Text("DOB: \(DateUtils.formatDob(self.user.dateOfBirth!))").font(.subheadline)
                }
                
                if self.user.genderEmoji != nil {
                    Text("Gender: \(self.user.genderEmoji!)").font(.subheadline)
                }
                
                if self.user.nationalityCountryCode != nil {
                    Text("Nationality: \(self.user.nationalityCountryCode!.flag)").font(.subheadline)
                }
                
            }.padding(.leading, 8)
        }.padding(.init(top: 8, leading: 0, bottom: 8, trailing: 0))
    }
}
