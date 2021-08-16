//
//  RecipeFavorite.swift
//  Reciplease
//
//  Created by Brian Friess on 29/07/2021.
//

import Foundation
import UIKit
import CoreData



class RecipeFavoriteTest{
    
    static var shared = RecipeFavoriteTest()
    private init() {}
    
    var arrayRecipeFavorite = [RecipeDecodable]()

    func addRecipe(_ recipe : [RecipeDecodable]){
        arrayRecipeFavorite = recipe
    }
    func removeRecipe(at index : Int){
        arrayRecipeFavorite.remove(at: index)
    }
    
    func test(_ label : String, _ url : String) -> Bool{
        for i in 0 ..< arrayRecipeFavorite.count{
            if arrayRecipeFavorite[i].recipe?.label == label, arrayRecipeFavorite[i].recipe?.url == url {
                return true
            }
        }
        return false
    }
}

class StorageManager{
    
    static var shared = StorageManager()
    private init() {}
    var currentContext : NSManagedObjectContext?
    
    func setUp(_ container : NSPersistentContainer){
        currentContext = container.viewContext
    }
    
    func persist(_ data : RecipeDecodable){
        let fetchRequest : NSFetchRequest<RecipeFavorite> = RecipeFavorite.fetchRequest()
        guard let currentContext = currentContext, let entityName = fetchRequest.entityName else {return}
        
        let recipeObject : NSManagedObject? = NSEntityDescription.insertNewObject(forEntityName: entityName, into: currentContext)
        
        guard let recipeObject = recipeObject as? RecipeFavorite else {return}
        
        recipeObject.imageData = data.recipe?.imageData
        recipeObject.ingredientLines = data.recipe?.ingredientLines
        recipeObject.label = data.recipe?.label
        recipeObject.totalTime = data.recipe?.totalTime ?? 0.0
        recipeObject.url = data.recipe?.url
        recipeObject.yield = data.recipe?.yield ?? 0.0
        recipeObject.image = data.recipe?.image
        
        currentContext.perform {
            do{
                try currentContext.save()
            }catch{
               print("error save")
            }
        }
    }
    
    func loadRecipe() -> [RecipeDecodable]{
        
        let fetchRequest : NSFetchRequest<RecipeFavorite> = RecipeFavorite.fetchRequest()
        guard let currentContext = currentContext else {return []}
        
        var recipes = [RecipeFavorite]()
        
        do{
            recipes = try currentContext.fetch(fetchRequest)
        }catch{
            print("error load")
        }
        
        return recipes.map { favorite in
            return RecipeDecodable(recipe: RecipeDetailDecodebable(label: favorite.label, image: favorite.image, url: favorite.url, yield: favorite.yield, ingredientLines: favorite.ingredientLines, totalTime: favorite.totalTime, imageData: favorite.imageData))
        }
    }
}





