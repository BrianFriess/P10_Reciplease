//
//  RecipeServiceAlamofire.swift
//  Reciplease
//
//  Created by Brian Friess on 20/07/2021.
//

import Foundation
import Alamofire

class RecipeServiceAlamofire{

    private var baseUrl = ""
    init(baseUrl : String){
        self.baseUrl = baseUrl
    }
    typealias recipeCallBack = (_ recipe : DataRecipeDecodable?, _ recipeNext : DataLinkDecodable?,  _ status : Bool) -> Void
    var callBack : recipeCallBack?

    
    func getRecipe(_ ingredient : String){
        
        guard let ingredientEncoded = ingredient.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else{
            return
        }
        AF.request(self.baseUrl + ingredientEncoded , method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil, interceptor: nil).response  { (responseData) in
            
            DispatchQueue.main.async {
                guard let data = responseData.data else{
                    self.callBack?(nil,nil, false)
                    return
                }
                guard let response = try? JSONDecoder().decode(DataRecipeDecodable.self, from: data), let responseNext = try? JSONDecoder().decode(DataLinkDecodable.self, from: data)  else {
                    self.callBack?(nil,nil, false)
                    return
                }
                self.callBack?(response,responseNext, true)
            }
        }
    }
    func completionHandler(callBack: @escaping recipeCallBack){
        self.callBack = callBack
    }
}


class ImageRecipeServiceAlamofire{
    
    typealias imageCallBack = (_ recipe : Data?,_ status:  Bool) -> Void
   //var callBack : imageCallBack?
    
    func getImage(urlImage : String, callBack: @escaping imageCallBack){
        AF.request(urlImage).response  { (response) in
            DispatchQueue.main.async {
                guard let data = response.data else{
                    callBack(nil, false)
                    return
                }
                callBack(data, true)
            }
        }
    }
}
struct DataRecipeDecodable : Decodable{
    var hits : [RecipeDecodable]?
}

struct RecipeDecodable : Decodable{
    
    var recipe : RecipeDetailDecodebable?
}

struct RecipeDetailDecodebable : Decodable{
    var label : String? // 1st page / 2nd page
    var image : String? // 1st page / 2nd page
    var url : String? // 2nd page
    var yield : Double? //1st page
    var ingredientLines : [String]? // 1st page
    var totalTime : Double? // 1st page
    var imageData : Data?
    
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
    var next : NextRefDecodable?
}

struct NextRefDecodable : Decodable, Equatable{
    var href : String?
}
