//
//  RecipeFavorite+CoreDataProperties.swift
//  Reciplease
//
//  Created by Brian Friess on 12/08/2021.
//
//

import Foundation
import CoreData


extension RecipeFavorite {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<RecipeFavorite> {
        return NSFetchRequest<RecipeFavorite>(entityName: "RecipeFavorite")
    }

    @NSManaged public var image: [Int : UIImage]?
    @NSManaged public var recipe: [RecipeDecodable]?

}

extension RecipeFavorite : Identifiable {

}
