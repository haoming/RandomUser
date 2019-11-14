//
//  UserListView.swift
//  RandomUser
//
//  Created by Haoming Ma on 12/11/19.
//  Copyright © 2019 Haoming. All rights reserved.
//

import SwiftUI
import CoreData

struct UserListView: View {
    
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @FetchRequest(fetchRequest: UserEntity.getAllUsers()) var allUsers: FetchedResults<UserEntity>
    
    @ObservedObject var viewModel: UserListViewModel
    
    init(viewModel: UserListViewModel) {
        self.viewModel = viewModel
    }
    
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
//
//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
