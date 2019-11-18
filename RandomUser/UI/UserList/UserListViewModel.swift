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
import UIKit

class UserListViewModel: ObservableObject {
    internal var objectWillChange = PassthroughSubject<Void, Never>()
        
    @Published var isLoading: Bool
    
    @Published var fetchedUsers: [UserEntity] = [] {
        willSet {
          objectWillChange.send()
        }
    }
    
    @Published var filterEnabled: Bool = false
    @Published var searchQuery: String = ""
    @Published var selectedGenderOptionIndex: Int = GenderFilter.FemaleAndMale.rawValue {
        didSet {
            print("selectedGenderOptionIndex did set: \(selectedGenderOptionIndex)")
            self.filterUpdated(searchQuery: self.currentDebouncedSearchQuery, genderFilter: self.currentGenderFilter)
        }
    }
    
    private var currentDebouncedSearchQuery: String = ""

    private weak var managedObjectContext: NSManagedObjectContext!
    private weak var fetcher: UserFetcher!
    private var coreDataFetcher: CoreDataUserFetcher!
    
    private var page: Int
    private let countPerPage: Int
    private var seed: String

    private var disposables = Set<AnyCancellable>()
    
    init() {
        self.isLoading = false
        self.page = 1
        self.countPerPage = 30
        
        self.seed = UUID().uuidString
        
        _ = $searchQuery
        .dropFirst(1)
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
        .sink(receiveValue: searchQueryUpdated(search:))
    }
    
    func setUpAndRun(fetcher: UserFetcher, managedObjectContext: NSManagedObjectContext) {
        self.fetcher = fetcher
        self.managedObjectContext = managedObjectContext
        self.coreDataFetcher = CoreDataUserFetcher(managedObjectContext: managedObjectContext)
        self.fetchedUsers = self.coreDataFetcher.fetch()
        self.fetchAndStore()
    }
    
    func refreshRandomUsers() {
        guard !self.isLoading else {
            return
        }
        self.searchQuery = ""
        self.selectedGenderOptionIndex = GenderFilter.FemaleAndMale.rawValue
        self.seed = UUID().uuidString
        self.page = 1
        self.fetchAndStore()
    }
    
    private func clearUserEntityData() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: UserEntity.coreDataEntityName)
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try managedObjectContext.execute(batchDeleteRequest)
            self.managedObjectContext.reset()
            print("Existing data cleared")
        } catch {
            // unlikely to happen
            print("Failed to delete existing data for UserEntity")
        }
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
            self.fetcher.fetchUsers(page: page, count: self.countPerPage, seed: self.seed)
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
                    if self.page == 1 {
                        // the first page response for a new seed
                        // clear the old data for a different seed
                        self.clearUserEntityData()
                    }
                    self.store(response: response, currentPage: self.page)
                    self.fetchedUsers = self.coreDataFetcher.fetch()
                    self.page = self.page + 1
                }
                self.isLoading = false
            }).store(in: &self.disposables)
        }
    }
}

// MARK: - filters
extension UserListViewModel {
    private var currentGenderFilter: GenderFilter {
        get {
            return GenderFilter(rawValue: self.selectedGenderOptionIndex)!
        }
    }
    
    private func searchQueryUpdated(search: String) {
        self.currentDebouncedSearchQuery = search
        self.filterUpdated(searchQuery: self.currentDebouncedSearchQuery, genderFilter: self.currentGenderFilter)
    }

    private func filterUpdated(searchQuery: String, genderFilter: GenderFilter) {
        let nameQuery = searchQuery.trimmingCharacters(in: .whitespacesAndNewlines)
        if nameQuery == "", genderFilter == .FemaleAndMale {
            self.filterEnabled = false
        } else {
            self.filterEnabled = true
        }
        
        print("filterUpdated - filterEnabled: \(filterEnabled), gender: \(genderFilter), search: \(nameQuery)")
        
        self.fetchedUsers = self.coreDataFetcher.fetch(nameSearchQuery: nameQuery, genderFilter: genderFilter)
    }
}
