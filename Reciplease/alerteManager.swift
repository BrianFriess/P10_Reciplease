//
//  alerteManager.swift
//  Reciplease
//
//  Created by Brian Friess on 21/07/2021.
//

import Foundation
import UIKit

struct AlerteManager{
    
    //we create an enumeration for our message alerteVC
    enum AlerteType{
        case EmptyList

    

        
        var description : String{
            switch self{
            case .EmptyList:
                return " your list is empty"
            }
        }
    }
    

    
    func alerteVc(_ message: AlerteType, _ controller : UIViewController){
        let alertVC = UIAlertController(title: "Zéro!", message: "\(message.description)", preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        controller.present(alertVC, animated: true, completion: nil)
        }
}
