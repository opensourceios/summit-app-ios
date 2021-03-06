//
//  VenueRoomManagedObject.swift
//  OpenStack Summit
//
//  Created by Alsey Coleman Miller on 11/1/16.
//  Copyright © 2016 OpenStack. All rights reserved.
//

import Foundation
import CoreData

public final class VenueRoomManagedObject: LocationManagedObject {
    
    @NSManaged public var capacity: NSNumber?
    
    @NSManaged public var venue: VenueManagedObject
    
    @NSManaged public var floor: VenueFloorManagedObject?
}

extension VenueRoom: CoreDataDecodable {
    
    public init(managedObject: VenueRoomManagedObject) {
        
        self.identifier = managedObject.id
        self.name = managedObject.name
        self.capacity = managedObject.capacity?.intValue
        self.descriptionText = managedObject.descriptionText
        self.venue = managedObject.venue.id
        self.floor = managedObject.floor?.id
    }
}

extension VenueRoom: CoreDataEncodable {
    
    public func save(_ context: NSManagedObjectContext) throws -> VenueRoomManagedObject {
        
        let managedObject = try cached(context)
        
        managedObject.name = name
        managedObject.descriptionText = descriptionText
        managedObject.capacity = capacity != nil ? NSNumber(value: Int32(capacity!) as Int32) : nil
        managedObject.venue = try context.relationshipFault(venue)
        managedObject.floor = try context.relationshipFault(floor)
        
        managedObject.didCache()
        
        return managedObject
    }
}
