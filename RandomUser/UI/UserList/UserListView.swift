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
    
    @ObservedObject var viewModel: UserListViewModel
    
    init(viewModel: UserListViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        NavigationView {
            VStack(alignment: .center) {
                if self.viewModel.fetchedUsers.isEmpty {
                    if self.viewModel.isLoading {
                        Text("Loading ...")
                    } else {
                        List {
                            VStack(alignment: .center) {
                                UserFilterView(searchQuery: $viewModel.searchQuery, selectedGenderOptionIndex: $viewModel.selectedGenderOptionIndex)
                                .disabled(self.viewModel.isLoading)
                                Text("No user found.").padding(.init(top: 40, leading: 0, bottom: 60, trailing: 0))
                                Spacer()
                            }
                        }
                        
                    }
                } else {
                    self.listView
                }
            }
            .navigationBarTitle("Random Users")
        }
    }

    
    var listView: some View {
        List {
            UserFilterView(searchQuery: $viewModel.searchQuery, selectedGenderOptionIndex: $viewModel.selectedGenderOptionIndex)
                .disabled(self.viewModel.isLoading)
            Section {
                ForEach(self.viewModel.fetchedUsers) { user in
                    VStack(alignment: .center) {
                        NavigationLink(destination: UserDetailsView(user: user)) {
                            UserView(user: user)
                        }

                        if self.viewModel.isLoading && self.viewModel.fetchedUsers.isLastItem(user) {
                            Divider()
                            Text("Loading ...")
                        }
                        
                        if self.viewModel.filterEnabled && self.viewModel.fetchedUsers.isLastItem(user) {
                            Divider()
                            Text("Filter applied to cached users only.")
                        }
                    }.onAppear {
                        self.listItemAppears(user)
                    }
                }
            }
        }
    }
    
    private func listItemAppears(_ item: UserEntity) {
        if !self.viewModel.filterEnabled, self.viewModel.fetchedUsers.isThresholdItem(offset: 5,
                                 item: item) {
            self.viewModel.fetchAndStore()
        }
    }
}

//
//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
