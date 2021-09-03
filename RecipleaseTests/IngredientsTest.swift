//
//  IngredientsTest.swift
//  RecipleaseTests
//
//  Created by Brian Friess on 19/08/2021.
//

import XCTest
@testable import Reciplease

class IngredientsTest: XCTestCase {


    var ingredients : Ingredients!
    
    override func setUp() {
        super.setUp()
        ingredients = Ingredients()
    }
    
    func testifNameIsEmpty_AddName_NameNotEmpty(){
        
        ingredients.addIngredient("apple")
        ingredients.addIngredient("cheese")
        
        XCTAssert(ingredients.name == ["apple","cheese"])
    }
    
    func testIfNameIsNotEmpty_ClearIngredients_NameIsEmpty(){
        ingredients.addIngredient("apple")
        ingredients.addIngredient("cheese")
        
        XCTAssert(ingredients.name == ["apple","cheese"])
        
        ingredients.clearIngredient()
        
        XCTAssert(ingredients.name == [])
    }
    
    func testIfNameIsNotEmpty_RemoveIngredient_IngredientIsRemove(){
        ingredients.addIngredient("apple")
        ingredients.addIngredient("cheese")
        
        XCTAssert(ingredients.name == ["apple","cheese"])
        
        ingredients.removeIngredient(at: 0)
        
        XCTAssert(ingredients.name == ["cheese"])
        
    }
    
    
    

}
