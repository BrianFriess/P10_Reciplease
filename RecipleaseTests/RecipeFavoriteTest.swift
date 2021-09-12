//
//  RecipeFavoriteTest.swift
//  RecipleaseTests
//
//  Created by Brian Friess on 19/08/2021.
//

import XCTest
@testable import Reciplease
import CoreData

class RecipeFavoriteTest: XCTestCase {

    var recipeFavoriteManager : RecipeFavoriteManager!
    var recipe : RecipeDecodable!
    var storage : MockStorageManager!

    
    
    override func setUp() {
        super.setUp()
        storage = MockStorageManager()
        recipe = RecipeDecodable()
        recipeFavoriteManager = RecipeFavoriteManager.shared
        recipeFavoriteManager.storage = storage
        //recipe.recipe = some(RecipeDetailDecodebable())
        recipe.recipe = .some(RecipeDetailDecodebable())
        recipe.recipe?.label = "Lemon"
        recipe.recipe?.image = "image.jpg"
        recipe.recipe?.url = "urlRecipe.com"
        recipe.recipe?.yield = 5.5
        recipe.recipe?.ingredientLines = ["lemon","sugar"]
        recipe.recipe?.totalTime = 10.5
        recipe.recipe?.imageData = FakeResponseDataRecipe.recipeCorrectData
        
    }
    
    override func tearDown() {
        super.tearDown()

    }
    
    func testAdd_Succeed(){
        
        recipeFavoriteManager.arrayRecipeFavorite = [recipe]
    
        recipeFavoriteManager.addToFavorite(recipe)
        XCTAssert(storage.persistCount == 1)
        XCTAssertEqual(storage.persistData?.recipe?.id, recipe.recipe?.id)
    }

    
    func testDelete_Succeed(){
        
        recipeFavoriteManager.arrayRecipeFavorite = [recipe]
        let expectation = XCTestExpectation(description: "wait for queue change")
        storage.deleteRecipeCompletion = { completion in
            completion(true)
        }
        recipeFavoriteManager.removeRecipe(at: 0) { statut in
             if statut{
                 expectation.fulfill()
                 XCTAssert(self.recipeFavoriteManager.arrayRecipeFavorite == [])
                XCTAssertEqual(self.storage.deleteRecipeCount, 1)
                XCTAssertEqual(self.storage.deleteRecipeData?.recipe?.id, self.recipe.recipe?.id)
             }
         }
         wait(for: [expectation], timeout: 5)
    }
    
    func testLoad_Succeed(){
        recipeFavoriteManager.arrayRecipeFavorite = [recipe]
        
        storage.fetchRecipeReturn = [recipe]
        
        let testRecipe: () = recipeFavoriteManager.loadFavoriteRecipe()
      
        XCTAssert(storage.fetchRecipeCount == 1)
        XCTAssertNotNil(testRecipe)
    }
    
    func testTestIfIsAleradyFav_IsIt_ReturnTrue(){
        recipeFavoriteManager.arrayRecipeFavorite = [recipe]
        let testArray = [recipe]
        
        
        XCTAssertTrue(recipeFavoriteManager.test((testArray[0]?.recipe?.label)!, (testArray[0]?.recipe?.url)!, (testArray[0]?.recipe?.id)!))
    }
    
    
    func testTestIfIsAleradyFav_IsNot_ReturnFalse(){
        recipeFavoriteManager.arrayRecipeFavorite = [recipe]
        var testArray = [recipe]
        testArray[0]?.recipe?.label = "cheese"
        
        XCTAssertFalse(recipeFavoriteManager.test((testArray[0]?.recipe?.label)!, (testArray[0]?.recipe?.url)!, (testArray[0]?.recipe?.id)!))
    }
}

class MockStorageManager : StorageManagerProtocol{
    
    func setUp(_ container: NSPersistentContainer) {
    }
    
    var persistCount = 0
    var persistData : RecipeDecodable?
    func persist(_ data: RecipeDecodable) {
        persistCount += 1
        persistData = data
    }
    
    var fetchRecipeCount = 0
    var fetchRecipeReturn = [RecipeDecodable]()
    func fetchRecipe() -> [RecipeDecodable] {
        fetchRecipeCount += 1
        return fetchRecipeReturn
    }
    
    var deleteRecipeCount = 0
    var deleteRecipeData : RecipeDecodable?
    var deleteRecipeCompletion : ((_ completion: @escaping (Bool) -> Void) -> Void)?
    func deleteRecipe(_ recipe: RecipeDecodable, completion: @escaping (Bool) -> Void) {
        deleteRecipeCount += 1
        deleteRecipeData = recipe
        deleteRecipeCompletion?(completion)
    }
    
    
}
