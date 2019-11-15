//
//  UserListViewModel.swift
//  RandomUser
//
//  Created by Haoming Ma on 14/11/19.
//  Copyright © 2019 Haoming. All rights reserved.
//

import SwiftUI
import Combine
import CoreData

class UserListViewModel: ObservableObject {
    @Published var isLoading: Bool

    private weak var managedObjectContext: NSManagedObjectContext!
    private weak var fetcher: RandomUserFetcher!
    
    private var page: Int
    private var countPerPage: Int
    private var seed: String

    private var disposables = Set<AnyCancellable>()
    
    init() {
        self.isLoading = false
        
        self.page = 1
        self.countPerPage = 30
        self.seed = UUID().uuidString
    }
    
    func setUpAndRun(fetcher: RandomUserFetcher, managedObjectContext: NSManagedObjectContext) {
        self.fetcher = fetcher
        self.managedObjectContext = managedObjectContext
        
        self.fetchAndStore()
    }

    private func store(response: RandomUserApiResponse, currentPage: Int) {
        guard let users = response.results, let apiInfo = response.info else {
            return
        }
        
        print("store users")
        var userEntities: [UserEntity] = []
        for i in 0..<users.count {
            let index = (currentPage - 1) * self.countPerPage + i
            
            let userEntity = UserEntity.newInstance(context: self.managedObjectContext, user: users[i], apiInfo: apiInfo, index: Int64(index))
            
            userEntities.append(userEntity)
        }
        do {
            try self.managedObjectContext.save()
        } catch {
            print(error)
        }
    }
    
    func fetchAndStore() {
        print("fetchAndStore")
        // fire the async HTTP call in the main thread so that self.page and self.isLoading will always be modified in the main thread thus avoiding race conditions
        DispatchQueue.main.async {
            if self.isLoading {
                return
            }
            self.isLoading = true
            
            let page = self.page
            self.fetcher.getUsers(page: page, count: self.countPerPage, seed: self.seed)
            .receive(on: DispatchQueue.main)
            .sink(
              receiveCompletion: { [weak self] value in
                guard let self = self else { return }
                
                print("receiveCompletion: \(value)")
                switch value {
                case .failure:
                                        
                    self.isLoading = false
                case .finished:
                  break
                }
              },
              receiveValue: { [weak self] response in
                guard let self = self else { return }
                
                if let _ = response.error {

                } else {
                    self.store(response: response, currentPage: self.page)
                    self.page = self.page + 1
                }
                self.isLoading = false
            }).store(in: &self.disposables)
        }
    }
}
