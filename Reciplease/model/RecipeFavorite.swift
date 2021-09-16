//
//  RecipeFavorite.swift
//  Reciplease
//
//  Created by Brian Friess on 29/07/2021.
//

import Foundation
import UIKit



//we  create this protocol for not use the singleton on our controler
protocol RecipeFavoriteProtocol {
    func loadFavoriteRecipe()
    func removeRecipe(at index : Int, completion : @escaping (Bool) -> Void)
    func addToFavorite(_ recipe : RecipeDecodable)
    
    func test(_ label : String, _ url : String, _ id : UUID) -> Bool
    var arrayRecipeFavorite: [RecipeDecodable] {get set}
}


class RecipeFavoriteManager : RecipeFavoriteProtocol{
    
    var storage : StorageManagerProtocol!
    //singleton
    static var shared = RecipeFavoriteManager()
    private init() {}
    
    var arrayRecipeFavorite = [RecipeDecodable]()

    //we add recipe at the array
    func loadFavoriteRecipe(){
        arrayRecipeFavorite = storage.fetchRecipe()
    }
    
    //we delete a recipe at the table level, we use the completion to wait for a response before continuing
    func removeRecipe(at index : Int, completion : @escaping (Bool) -> Void){
        storage.deleteRecipe(arrayRecipeFavorite[index]) { [weak self] statut in
            if statut == true{
                self?.arrayRecipeFavorite.remove(at: index)
            }
            completion (statut)
        }
    }
    
    func addToFavorite(_ recipe : RecipeDecodable){
        storage.persist(recipe)
    }
    
    //we test if we have already the recipe in our array
    func test(_ label : String, _ url : String, _ id : UUID) -> Bool{
        for i in 0 ..< arrayRecipeFavorite.count{
            if arrayRecipeFavorite[i].recipe?.label == label, arrayRecipeFavorite[i].recipe?.url == url{
                return true
            }
        }
        return false
    }
}










