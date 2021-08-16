//
//  RecipeTableViewCell.swift
//  Reciplease
//
//  Created by Brian Friess on 22/07/2021.
//

import UIKit


class RecipeTableViewCell: UITableViewCell {

    @IBOutlet weak var labelField: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageRecipe: UIImageView!
    @IBOutlet weak var labelRate: UILabel!
    @IBOutlet weak var labelTime: UILabel!
    @IBOutlet weak var rateTimeView: UIView!
    
    
    func configure(title: String, subtitles : [String], rate: Double, time: Double) {

        var timeDisplay = ""
        if time == 0.0{
            timeDisplay = "-"
        } else {
            timeDisplay = String(time)
        }
        labelTime.text = timeDisplay
        
        var rateDisplay = ""
        if rate == 0.0{
            rateDisplay = "-"
        } else {
            rateDisplay = String(rate)
        }
        labelRate.text = rateDisplay

        rateTimeView.layer.shadowOffset = .init(width: 4, height: 4)
        rateTimeView.layer.shadowOpacity = 0.8
        
        titleLabel.text = title
        titleLabel.layer.shadowOffset = .init(width: 4, height: 4)
        titleLabel.layer.shadowOpacity = 0.8
        
        let nbIngredient = subtitles.count
        var ingredients = ""
        for i in 0 ..< nbIngredient{
            let ingredient = subtitles[i]
            ingredients.append("\(ingredient), ")
        }
        labelField.text = ingredients
        labelField.layer.shadowOffset = .init(width: 4, height: 4)
        labelField.layer.shadowOpacity = 0.8
        
    }
    
    func configureImage(image : UIImage){
        imageRecipe.image = image.withRenderingMode(.alwaysOriginal)
        imageRecipe.contentMode = .scaleToFill
        imageRecipe.clipsToBounds = true
    }
}
