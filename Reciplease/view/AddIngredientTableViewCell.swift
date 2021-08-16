//
//  AddIngredientTableViewCell.swift
//  Reciplease
//
//  Created by Brian Friess on 14/07/2021.
//

import UIKit

class AddIngredientTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(title : String){
        titleLabel.text = "- " + title
    }

}
