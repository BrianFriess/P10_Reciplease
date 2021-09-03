//
//  FakeResponseDataRecipe.swift
//  RecipleaseTests
//
//  Created by Brian Friess on 23/08/2021.
//

import Foundation


class FakeResponseDataRecipe{
    
    static let responseOK = HTTPURLResponse(
        url: URL(string: "https://api.edamam.com")!,
        statusCode: 200, httpVersion: nil, headerFields: [:])!
    
    static let responseKO = HTTPURLResponse(
        url: URL(string: "https://api.edamam.com")!,
        statusCode: 500, httpVersion: nil, headerFields: [:])!
    
    static var recipeCorrectData: Data?{
        let bundle = Bundle(for: FakeResponseDataRecipe.self)
        let url = bundle.url(forResource: "recipe", withExtension: "json")!
        return try! Data(contentsOf: url)
    }
    
    static var recipeFakeData: Data?{
        let bundle = Bundle(for: FakeResponseDataRecipe.self)
        let url = bundle.url(forResource: "recipeFakeData", withExtension: "json")!
        return try! Data(contentsOf: url)
    }
    

    class RecipesError: Error {}
    static let error = RecipesError()
 
    
    // Error data
    static let recipesIncorrectData = "error".data(using: .utf8)!
    static let recipeDataNil : Data? = nil
    static let imageData = "image".data(using: .utf8)!
}
