//
//  AddIngredientTableViewCell.swift
//  Reciplease
//
//  Created by Brian Friess on 14/07/2021.
//

import UIKit

class AddIngredientTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    
    
    func configure(title : String){
        titleLabel.text = "- " + title
    }
}
