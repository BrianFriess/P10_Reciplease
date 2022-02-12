//
//  DecodableManager.swift
//  Reciplease
//
//  Created by Brian Friess on 16/09/2021.
//

import Foundation


struct DataRecipeDecodable : Decodable, Equatable{
    var hits : [RecipeDecodable]?
}

struct RecipeDecodable : Decodable, Equatable{
    
    var recipe : RecipeDetailDecodebable?
}

struct RecipeDetailDecodebable : Decodable, Equatable{
    var label : String? // 1st page / 2nd page
    var image : String? // 1st page / 2nd page
    var url : String? // 2nd page
    var yield : Double? //1st page
    var ingredientLines : [String]? // 1st page
    var totalTime : Double? // 1st page
    var imageData : Data?
    var id : UUID? = UUID()
    
    enum CodingKeys : String, CodingKey{
        case label
        case image
        case url
        case yield
        case ingredientLines
        case totalTime
    }
}



struct DataLinkDecodable : Decodable, Equatable{
    var _links : LinkNextDecodable?
}

struct LinkNextDecodable : Decodable, Equatable{
    let next : NextRefDecodable?
}

struct NextRefDecodable : Decodable, Equatable{
    let href : String?
}
