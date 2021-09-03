//
//  FavoritesRecipeViewController.swift
//  Reciplease
//
//  Created by Brian Friess on 13/07/2021.
//

import UIKit

class FavoritesRecipeViewController : UIViewController {
    
    @IBOutlet weak var favTableView: UITableView!
    
    var recipeDetail = RecipeDecodable()
    var currentImage : UIImage?
    var currentImageData : Data?
    var recipeFavorite : RecipeFavoriteProtocol! = RecipeFavoriteManager.shared
    var storageManager : StorageManagerProtocol! = StorageManager.shared

    //we load the data in CoreData for give value at recipeFavorite
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        recipeFavorite.loadFavoriteRecipe()
        favTableView.reloadData()
    }
    
    //we give the value to the segue for check the detail of the recipe
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SegueToDetailRecipeViewControllerViaFav"{
            let successVC = segue.destination as! DetailRecipeViewController
            successVC.recipeDetail = recipeDetail
            successVC.currentImage = currentImage
        }
    }
}

extension FavoritesRecipeViewController : UITableViewDataSource, UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        recipeFavorite.arrayRecipeFavorite.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //custom cell
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "RecipesFavCell", for: indexPath) as? RecipeTableViewCell else {
            return UITableViewCell()
        }
        let recipe = recipeFavorite.arrayRecipeFavorite[indexPath.row]

        cell.configure(title: (recipe.recipe?.label)!, subtitles:( recipe.recipe?.ingredientLines)!, rate:(recipe.recipe?.yield)!, time: (recipe.recipe?.totalTime)!)
        
        //if we don't have an image in network Call, we give a default image
        if let imageDisplay = recipe.recipe?.imageData {
            cell.configureImage(image: UIImage(data: imageDisplay)!)
        } else{
            cell.configureImage(image: UIImage(systemName: "questionmark.circle.fill")!)
        }
        return cell
    }
    
    // We select data when whe click on the cell
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        recipeDetail = recipeFavorite.arrayRecipeFavorite[indexPath.row]
        currentImage = UIImage(data: (recipeFavorite.arrayRecipeFavorite[indexPath.row].recipe?.imageData)!)
        self.performSegue(withIdentifier: "SegueToDetailRecipeViewControllerViaFav", sender: nil)
    }
    
    //we use this for remove a recipe to coreData
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            recipeFavorite.removeRecipe(at: indexPath.row) { statut in
                if statut{
                    tableView.deleteRows(at: [indexPath], with: .automatic)
                }
            }
        }
    }
}
