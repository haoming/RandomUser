//
//  ContentView.swift
//  RandomUser
//
//  Created by Haoming Ma on 12/11/19.
//  Copyright © 2019 Haoming. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(fetchRequest: User.getAllUsers()) var allUsers: FetchedResults<User>
    
    @State private var isLoading: Bool = false
    
    var body: some View {
        
        NavigationView {
            self.contentOrEmptyView
            .navigationBarTitle("Random Users")
        }
    }
    
    private var contentOrEmptyView: some View {
        VStack(alignment: .leading) {
            if self.allUsers.isEmpty {
                Text("No user found")
            } else {
                List {
                    ForEach(self.allUsers) { user in
                        VStack(alignment: .leading) {
                            UserView(user: user)
                        }
                    }
                }
            }
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
