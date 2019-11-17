//
//  UserFilterView.swift
//  RandomUser
//
//  Created by Haoming Ma on 17/11/19.
//  Copyright © 2019 Haoming. All rights reserved.
//

import SwiftUI

enum GenderFilter: Int {
    case FemaleAndMale = 0
    case Female = 1
    case Male = 2
}

struct UserFilterView: View {
    
    private var genderOptions = ["♀️+ ♂️", "♀️Female", "♂️Male"]
    
    private var searchQuery: Binding<String>
    private var selectedGenderOptionIndex: Binding<Int>
    
    init(searchQuery: Binding<String>, selectedGenderOptionIndex: Binding<Int>) {
        self.searchQuery = searchQuery
        self.selectedGenderOptionIndex = selectedGenderOptionIndex
    }
    
    var body: some View {
        VStack {
            Picker("Gender", selection: self.selectedGenderOptionIndex) {
                ForEach(0 ..< genderOptions.count) { index in
                    Text(self.genderOptions[index]).tag(index)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.init(top: 8, leading: 0, bottom: 0, trailing: 0))
            
            HStack(alignment: .center) {
                Image(systemName: "magnifyingglass").foregroundColor(.secondary)
                TextField("Search name", text: searchQuery)
            }.padding(.init(top: 8, leading: 8, bottom: 8, trailing: 0))
        }
    }
}
