//
//  RecipeServiceAlamofire.swift
//  Reciplease
//
//  Created by Brian Friess on 20/07/2021.
//

import Foundation
import Alamofire

//we use the protocol for create a request for our UItest
protocol AlamofireServiceProtocol{
    func request(_ convertible: URLConvertible, method: HTTPMethod, parameters: Parameters? , encoding: ParameterEncoding , headers: HTTPHeaders? , interceptor: RequestInterceptor?, completion : @escaping (Data?) -> Void)
}

//we create this class for create a requester for not use AF in our principal class but we use the requester.
class AlamoFireRecipeService : AlamofireServiceProtocol{
    func request(_ convertible: URLConvertible, method: HTTPMethod, parameters: Parameters?, encoding: ParameterEncoding, headers: HTTPHeaders?, interceptor: RequestInterceptor?, completion: @escaping (Data?) -> Void) {
        
        //if we use this class, our requester is this
        AF.request(convertible , method: method, parameters: parameters, encoding: encoding, headers: headers, interceptor: interceptor).response  { (responseData) in
            completion(responseData.data)
        }
    }
}

//this class is for call the network call with alamofire
class RecipeServiceAlamofire{

    private var baseUrl = ""
    init(baseUrl : String, requester : AlamofireServiceProtocol){
        self.baseUrl = baseUrl
        self.requester = requester
    }
    typealias recipeCallBack = (_ recipe : DataRecipeDecodable?, _ recipeNext : DataLinkDecodable?,  _ status : Bool) -> Void
    var callBack : recipeCallBack?
    
    //we give a type to our requester
    var requester : AlamofireServiceProtocol

    //this function is our network call
    func getRecipe(_ ingredient : String){
        
        guard let ingredientEncoded = ingredient.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else{
            return
        }
        requester.request(self.baseUrl + ingredientEncoded , method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil, interceptor: nil) { (responseData) in
            
            DispatchQueue.main.async {
                //we create data with the response of the network call
                guard let data = responseData else{
                    self.callBack?(nil,nil, false)
                    return
                }
                // we create response for decode the data and response next for create an new network call in case we use the pagination
                guard let response = try? JSONDecoder().decode(DataRecipeDecodable.self, from: data), let responseNext = try? JSONDecoder().decode(DataLinkDecodable.self, from: data)  else {
                    self.callBack?(nil,nil, false)
                    return
                }
                //if everything is ok, we give the value to the callback
                self.callBack?(response,responseNext, true)
            }
        }
    }
    
    func completionHandler(callBack: @escaping recipeCallBack){
        self.callBack = callBack
    }
}

//we use the protocol for create a request for our UItest
protocol ImageRecipeServiceAlamofireProtocol{
    func request(_ urlImage : String, completion : @escaping (Data?) -> Void)
}

//we create this class for create a requester for not use AF in our principal class but we use the requester.
class ImageRecipeService : ImageRecipeServiceAlamofireProtocol{
    func request(_ urlImage: String, completion: @escaping (Data?) -> Void) {
        AF.request(urlImage).response { (response) in
            completion(response.data)
        }
    }
}

//this class is for call the network call with alamofire
class ImageRecipeServiceAlamofire{
    init(requester : ImageRecipeServiceAlamofireProtocol){
        self.requester = requester
    }
    typealias imageCallBack = (_ recipe : Data?,_ status:  Bool) -> Void

    var requester : ImageRecipeServiceAlamofireProtocol
    
    func getImage(urlImage : String, callBack: @escaping imageCallBack){
        requester.request(urlImage) { (response) in
            DispatchQueue.main.async {
                guard let data = response else{
                    callBack(nil, false)
                    return
                }
                callBack(data, true)
            }
        }
    }
}

struct BaseUrlService{
     static let baseUrl = "https://api.edamam.com/api/recipes/v2?type=public&app_id=28b3c087&app_key=6da79e23ea992e395202ad13e064b1e7&=&=&q="
}
