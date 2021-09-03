//
//  DetailRecipeViewController.swift
//  Reciplease
//
//  Created by Brian Friess on 29/07/2021.
//

import UIKit
import SafariServices

class DetailRecipeViewController : UIViewController {
    
    @IBOutlet weak var imageViewRecipe: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var rateLabel: UILabel!
    var recipeDetail = RecipeDecodable()
    var currentImage : UIImage?
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var rateTimeView: UIView!
    var recipeFavorite : RecipeFavoriteProtocol! = RecipeFavoriteManager.shared

    


    //we check if the recipe is already fav
    override func viewDidLoad() {
        if recipeFavorite.test((recipeDetail.recipe?.label)!, (recipeDetail.recipe?.url)!, (recipeDetail.recipe?.id)!){
            favoriteButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
        }
        configure()
    }
    
    func configure(){
        configureImage()
        configureLabel()
        configureTimeRateLabel()
    }
    
    func configureImage(){
        imageViewRecipe.image = currentImage
        imageViewRecipe.contentMode = .scaleToFill
        imageViewRecipe.clipsToBounds = true
    }
    
    func configureLabel(){
        titleLabel.text = recipeDetail.recipe?.label
        titleLabel.layer.shadowOffset = .init(width: 4, height: 4)
        titleLabel.layer.shadowOpacity = 0.8
    }
    
    //we use this function for check if we have an value for the time or the yield
    func configureTimeRateLabel(){
        let time = (recipeDetail.recipe?.totalTime)!
        var timeDisplay = ""
        if time == 0.0{
            timeDisplay = "-"
        } else {
            timeDisplay = String(time)
        }
        timeLabel.text = timeDisplay
        
        let rate = (recipeDetail.recipe?.yield)!
        var rateDisplay = ""
        if rate == 0.0{
            rateDisplay = "-"
        } else {
            rateDisplay = String(rate)
        }
        rateLabel.text = rateDisplay
        rateTimeView.layer.shadowOffset = .init(width: 4, height: 4)
        rateTimeView.layer.shadowOpacity = 0.8
    }
    
    //when we click on the button, we call safari for display the website with the recipe
    @IBAction func getDirectionButon(_ sender: Any) {
        
        if let urlString = recipeDetail.recipe?.url, let url = URL(string: urlString){
            let config = SFSafariViewController.Configuration()
            config.entersReaderIfAvailable = true
            
            //we prepare our modal with the data
            let vc = SFSafariViewController(url: url, configuration: config)
            vc.modalPresentationStyle = .popover
            vc.modalTransitionStyle = .coverVertical
            //and we present the modal
            present(vc, animated: true)
        }
    }
    
    
    //if we click on the favButton, we give the recipe at coreData with the function persist
    @IBAction func favoriteButton(_ sender: Any) {
        favoriteButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
        recipeFavorite.addToFavorite(recipeDetail)
    }
}


//extension for our table View
extension DetailRecipeViewController : UITableViewDataSource{

    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        recipeDetail.recipe?.ingredientLines?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //we use our custom Cell
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "DetailCell", for: indexPath) as? DetailTableViewCell else{
            return UITableViewCell()
        }
        
        guard let ingredient = recipeDetail.recipe?.ingredientLines?[indexPath.row] else { fatalError() }
        
        cell.configure(detail: ingredient)
        return cell
    }
}
