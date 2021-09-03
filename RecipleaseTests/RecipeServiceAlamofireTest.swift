//
//  RecipeServiceAlamofireTest.swift
//  RecipleaseTests
//
//  Created by Brian Friess on 23/08/2021.
//

import XCTest
import Alamofire
@testable import Reciplease

class RecipeServiceAlamofireTest: XCTestCase {
    
    var sut : RecipeServiceAlamofire!
    var requester : MockAlamofireServiceProtocol!
    var sutImage : ImageRecipeServiceAlamofire!
    var requesterImage : MockAlamofireImageServiceProtocol!
    
    override func setUp() {
        super.setUp()
        requester = MockAlamofireServiceProtocol()
        sut = RecipeServiceAlamofire(baseUrl: "lemon", requester: requester)
        requesterImage = MockAlamofireImageServiceProtocol()
        sutImage = ImageRecipeServiceAlamofire(requester: requesterImage)
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    
    func testTryToCallData_giveAValue_HaveAData(){
        requester.data = FakeResponseDataRecipe.recipeCorrectData
        let expectation = XCTestExpectation(description: "wait for queue change")
        
        sut.getRecipe("lemon")
        sut.completionHandler { DataRecipe, DataLink, status in
            expectation.fulfill()
            XCTAssertNotNil(DataRecipe)
            XCTAssertNotNil(DataLink)
            XCTAssertTrue(status)
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testTryToCallDataWithIncorrectData_GiveValue_HaveanError(){
        requester.data = FakeResponseDataRecipe.recipesIncorrectData
        let expectation = XCTestExpectation(description: "wait for queue change")
        
        sut.getRecipe("Ko")
        sut.completionHandler { DataRecipe, DataLink, Status in
            expectation.fulfill()
            XCTAssertNil(DataRecipe)
            XCTAssertNil(DataLink)
            XCTAssertFalse(Status)
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testTryToCallDataWithNilData_GiveValue_HaveanError(){
        requester.data = FakeResponseDataRecipe.recipeDataNil
        let expectation = XCTestExpectation(description: "wait for queue change")
        
        sut.getRecipe("Ko")
        sut.completionHandler { DataRecipe, DataLink, Status in
            expectation.fulfill()
            XCTAssertNil(DataRecipe)
            XCTAssertNil(DataLink)
            XCTAssertFalse(Status)
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testTryToCallData_giveAWrongUrl_HaveAnError(){
        
        let str = String(
            bytes: [0xD8, 0x00] as [UInt8],
            encoding: String.Encoding.utf16BigEndian)!
        
        requester.data = FakeResponseDataRecipe.recipeCorrectData
        
        sut.getRecipe(str)
        sut.completionHandler { DataRecipe, DataLink, status in
            XCTAssertNil(DataRecipe)
            XCTAssertNil(DataLink)
            XCTAssertFalse(status)
        }
    }
    
    func testTryToCallDataWithIncorrectData_GivValue_HaveNil(){
        requester.data = FakeResponseDataRecipe.recipesIncorrectData
        let expectation = XCTestExpectation(description: "wait for queue change")
        
        sut.getRecipe("Ko")
        sut.completionHandler { DataRecipe, DataLink, Status in
            expectation.fulfill()
            XCTAssertNil(DataRecipe)
            XCTAssertNil(DataLink)
            XCTAssertFalse(Status)
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testTryToCallImageDataWithCorrectData_GiveValue_HaveData(){
        
        requesterImage.data = FakeResponseDataRecipe.recipeCorrectData
        let expectation = XCTestExpectation(description: "wait for queue change")
        
        sutImage.getImage(urlImage: "image.com") { data, status in
            expectation.fulfill()
            XCTAssertTrue(status)
            XCTAssertNotNil(data)
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testTryToCallImageDataWithIncorrectData_GiveValue_HaveNil(){
        
        requesterImage.data = FakeResponseDataRecipe.recipeDataNil
        let expectation = XCTestExpectation(description: "wait for queue change")
        
        sutImage.getImage(urlImage: "lemon") { data, status in
            expectation.fulfill()
            XCTAssertFalse(status)
            XCTAssertNil(data)
        }
        wait(for: [expectation], timeout: 0.01)
    }
}


//we can create a mock with a fake requester and fake data
class MockAlamofireServiceProtocol : AlamofireServiceProtocol{
    
    var data : Data?
    
    func request(_ convertible: URLConvertible, method: HTTPMethod, parameters: Parameters?, encoding: ParameterEncoding, headers: HTTPHeaders?, interceptor: RequestInterceptor?, completion: @escaping (Data?) -> Void) {
        completion(data)
    }
}

class MockAlamofireImageServiceProtocol : ImageRecipeServiceAlamofireProtocol{
    
    var data : Data?
    
    func request(_ urlImage: String, completion: @escaping (Data?) -> Void) {
        completion(data)
    }
    
    
}
