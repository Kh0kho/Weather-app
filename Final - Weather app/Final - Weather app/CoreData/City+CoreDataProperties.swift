//
//  City+CoreDataProperties.swift
//  Final - Weather app
//
//  Created by Luka Khokhiashvili on 17.07.24.
//
//

import Foundation
import CoreData


extension City {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<City> {
        return NSFetchRequest<City>(entityName: "City")
    }

    @NSManaged public var name: String?

}

extension City : Identifiable {

}
