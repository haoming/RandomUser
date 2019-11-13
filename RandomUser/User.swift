//
//  User.swift
//  RandomUser
//
//  Created by Haoming Ma on 13/11/19.
//  Copyright © 2019 Haoming. All rights reserved.
//

import CoreData

class User : NSManagedObject, Identifiable {
    @NSManaged var uuid: UUID
    
    @NSManaged var firstName: String
    @NSManaged var lastName: String
    @NSManaged var title: String?

    @NSManaged var email: String?
    @NSManaged var phone: String?
    @NSManaged var cellPhone: String?
    @NSManaged var registeredTime: Date?

    @NSManaged var isMale: Bool
    @NSManaged var dateOfBirth: Date?
    @NSManaged var nationality: String?

    @NSManaged var largePictureUrl: String?
    @NSManaged var mediumPictureUrl: String?
    @NSManaged var thumbnailUrl: String?

    @NSManaged var streetNumber: String?
    @NSManaged var streetName: String?
    @NSManaged var city: String?
    @NSManaged var state: String?
    @NSManaged var country: String?
    @NSManaged var latitude: NSNumber?
    @NSManaged var longitude: NSNumber?
    @NSManaged var postcode: String?

    @NSManaged var seed: String?
    @NSManaged var index: Int64
}

extension User {
    static func getAllUsers() -> NSFetchRequest<User> {
        
        print("call getAllUsers")
        let request = User.fetchRequest() as! NSFetchRequest<User>
        
        let indexSort = NSSortDescriptor(key: "index", ascending: true)
        
        request.sortDescriptors = [indexSort]
        return request
    }
}
