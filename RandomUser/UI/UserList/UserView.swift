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
                Text(self.formattedDob).font(.subheadline)
                Text(self.formattedGender).font(.subheadline)
                Text(self.formattedNationality).font(.subheadline)
            }.padding(.leading, 8)
        }.padding(.init(top: 8, leading: 0, bottom: 8, trailing: 0))
    }
}

extension UserView {
    var formattedDob: String {
        get {
            if let dob = user.dateOfBirth {
                return "DoB: " + DateUtils.formatDob(dob)
            } else {
                return "Dob: unknown"
            }
        }
    }
    
    var formattedGender: String {
        get {
            guard let gender = user.gender else {
                return "Gender: unknown"
            }
            
            if gender == "Male" || gender == "male" {
                return "Gender: ♂️"
            } else if gender == "Female" || gender == "female" {
                return "Gender: ♀️"
            } else {
                return "Gender: \(gender)"
            }
        }
    }
    
    var formattedNationality: String {
        get {
            if let nat = user.nationality, let natCode = Iso3166_1a2(rawValue: nat.uppercased()) {
                return "Nationality: \(natCode.flag)"
            } else {
                return "Nationality: unknown"
            }
        }
    }
}
