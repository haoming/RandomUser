//
//  UserEntity.swift
//  RandomUser
//
//  Created by Haoming Ma on 13/11/19.
//  Copyright © 2019 Haoming. All rights reserved.
//

import CoreData

class UserEntity : NSManagedObject, Identifiable {
    @NSManaged var uuid: UUID
    
    @NSManaged var firstName: String
    @NSManaged var lastName: String
    @NSManaged var title: String?

    @NSManaged var email: String?
    @NSManaged var phone: String?
    @NSManaged var cellPhone: String?
    @NSManaged var registeredTime: Date?

    @NSManaged var gender: String?
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
    
    static func newInstance(context: NSManagedObjectContext, user: User, apiInfo: ApiInfo, index: Int64) -> UserEntity {
        let entity = UserEntity(context: context)
        entity.cellPhone = user.cell
        entity.city = user.location?.city
        entity.country = user.location?.country
        entity.dateOfBirth = user.dateOfBirth
        entity.email = user.email
        entity.firstName = user.name?.first ?? ""
        entity.gender = user.gender
        entity.index = index
        entity.largePictureUrl = user.picture?.large
        entity.lastName = user.name?.last ?? ""
        
        if let lat = user.location?.coordinates?.latitude,
            let latFloat = Float(lat) {
            entity.latitude = NSNumber(value: latFloat)
        }
        if let lon = user.location?.coordinates?.longitude,
            let lonFloat = Float(lon) {
            entity.longitude = NSNumber(value: lonFloat)
        }
        
        entity.nationality = user.nat
        entity.mediumPictureUrl = user.picture?.medium
        entity.phone = user.phone
        entity.registeredTime = user.registeredTime
        entity.seed = apiInfo.seed
        entity.state = user.location?.state
        entity.streetName = user.location?.street?.name
        if let num = user.location?.street?.number {
            entity.streetNumber = "\(num)"
        }
        
        entity.thumbnailUrl = user.picture?.thumbnail
        entity.title = user.name?.title
        
        if let loginUuid = user.login?.uuid, let uuid = UUID(uuidString: loginUuid) {
            entity.uuid = uuid
        } else {
            entity.uuid = UUID()
        }
        
        return entity
    }
}

extension UserEntity {
    static func getAllUsers() -> NSFetchRequest<UserEntity> {
        
        print("call getAllUsers")
        let request = UserEntity.fetchRequest() as! NSFetchRequest<UserEntity>
        
        let indexSort = NSSortDescriptor(key: "index", ascending: true)
        
        request.sortDescriptors = [indexSort]
        return request
    }
    
    var fullName: String {
        get {
            return "\(self.firstName) \(self.lastName)".trimmingCharacters(in: .whitespacesAndNewlines)
        }
    }
    
    var avatarUrl: URL? {
        get {
            // the resolution of thumbnail is not good enough to use as avatars
//            if let thumbnail = self.thumbnailUrl, let thumbnailURL = URL(string: thumbnail) {
//                return thumbnailURL
//            } else
                
            if let mediumPic = self.mediumPictureUrl, let mediumPicURL = URL(string: mediumPic) {
                return mediumPicURL
            } else if let largePic = self.largePictureUrl, let largePicURL = URL(string: largePic) {
                return largePicURL
            } else {
                return nil
            }
        }
    }
}
