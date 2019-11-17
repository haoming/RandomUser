//
//  UserDetailsView.swift
//  RandomUser
//
//  Created by Haoming Ma on 16/11/19.
//  Copyright © 2019 Haoming. All rights reserved.
//

import SwiftUI
import struct Kingfisher.KFImage

struct UserDetailsView: View {
    var user: User
    
    init(user: User) {
        self.user = user
    }
    
    var body: some View {
        self.content()
            .navigationBarTitle(Text(user.fullName), displayMode: .large)
            .listStyle(GroupedListStyle())
    }
    
    func content() -> some View {
        return
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    KFImage(self.user.largeAvatarUrl)
                            .placeholder{
                                Image(systemName: "person")
                                .font(.largeTitle)
                                .opacity(0.3)
                            }
                            .resizable()
                            .scaledToFill()
                            .cornerRadius(20)
                            .shadow(radius: 5)
                    
                    UserInfoItemView(label: "First name", value: user.firstName)
                    Divider()
                    UserInfoItemView(label: "Last name", value: user.lastName)
                    Divider()
                    UserInfoItemView(label: "Email", value: user.email)
                    if user.coordinate != nil {
                        MapView(coordinate: user.coordinate!)
                                       .frame(height: 300)
                                       .disabled(false)
                    }
                }.padding(.init(top: 0, leading: 16, bottom: 0, trailing: 16))
        }
    }

}

