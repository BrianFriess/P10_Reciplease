//
//  StorageManager.swift
//  Reciplease
//
//  Created by Brian Friess on 09/09/2021.
//

import Foundation
import CoreData


//we  create this protocol for not use the singleton
protocol StorageManagerProtocol {
    func setUp(_ container : NSPersistentContainer)
    func persist(_ data : RecipeDecodable)
    func fetchRecipe() -> [RecipeDecodable]
    func deleteRecipe(_ recipe : RecipeDecodable, completion : @escaping (Bool) -> Void)
}


// ecrire les commentaires
class StorageManager : StorageManagerProtocol{
    
    init() {}
    var currentContext : NSManagedObjectContext?
    
    //the function is use in AppDelegate
    func setUp(_ container : NSPersistentContainer){
        currentContext = container.viewContext
    }
    
    
    //we call this function to save data in coredata
    func persist(_ data : RecipeDecodable){
        
        //we create a request
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
        recipeObject.id = data.recipe?.id
        
        currentContext.perform {
            do{
                try currentContext.save()
            }catch{
               print("error save")
            }
        }
    }
    
    //we call this function to load data to coredata
    func fetchRecipe() -> [RecipeDecodable]{
        
        let fetchRequest : NSFetchRequest<RecipeFavorite> = RecipeFavorite.fetchRequest()
        guard let currentContext = currentContext else {return []}
        
        var recipes = [RecipeFavorite]()
        
        do{
            recipes = try currentContext.fetch(fetchRequest)
        }catch{
            print("error load")
        }
        
        return recipes.map { favorite in
            return RecipeDecodable(recipe: RecipeDetailDecodebable(label: favorite.label, image: favorite.image, url: favorite.url, yield: favorite.yield, ingredientLines: favorite.ingredientLines, totalTime: favorite.totalTime, imageData: favorite.imageData, id: favorite.id))
        }
    }
    
    func deleteRecipe(_ recipe : RecipeDecodable, completion : @escaping (Bool) -> Void) {
        
        guard let managedContext = currentContext,
              let recipeId = recipe.recipe?.id,
              let recipe = self.recipes("id", recipeId.uuidString).first else {
            return
        }
        managedContext.delete(recipe)

        managedContext.perform {
            do {
                completion(true)
                try managedContext.save()
            } catch let error {
                print("Error removing Recipe with name : \(recipeId) from CoreData : \(error.localizedDescription)")
                completion(false)
            }
        }
    }
    
    func recipes(_ key: String?, _ value: String?) -> [RecipeFavorite] {
            guard let managedContext = currentContext,
                  let key = key,
                  let value = value else {
                return []
            }
            // Fetch Projects by Key Value
            let fetchRequest: NSFetchRequest<RecipeFavorite> = RecipeFavorite.fetchRequest()
            let predicate = NSPredicate(format: "%K == %@", key, value)
            fetchRequest.predicate = predicate

            var recipes = [RecipeFavorite]()
            do {
                recipes = try (managedContext.fetch(fetchRequest))
            } catch let error {
                print("No Project found with \(key): \(value) in CoreData : \(error.localizedDescription)")
                return []
            }
            return recipes
        }
}
