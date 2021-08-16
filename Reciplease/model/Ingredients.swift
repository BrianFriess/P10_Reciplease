//
//  Ingrredients.swift
//  Reciplease
//
//  Created by Brian Friess on 14/07/2021.
//

import Foundation

class Ingredients{
    var name : [String] = [""]
    
    func addIngredient(_ ingredient : String){
        name.append(ingredient)
    }
}
