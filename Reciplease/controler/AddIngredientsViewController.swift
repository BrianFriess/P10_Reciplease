//
//  ViewController.swift
//  Reciplease
//
//  Created by Brian Friess on 13/07/2021.
//

import UIKit

class AddIngredientsViewController : UIViewController {
    
    @IBOutlet weak var indicatorActivity: UIActivityIndicatorView!
    @IBOutlet weak var buttonValidate: UIButton!
    var ingredient = Ingredients()
    var recipeServiceAF = RecipeServiceAlamofire(baseUrl: "https://api.edamam.com/api/recipes/v2?type=public&app_id=28b3c087&app_key=6da79e23ea992e395202ad13e064b1e7&=&=&q=")
    let alerte = AlerteManager()
    var recipe = DataRecipeDecodable()
    var recipeNext = DataLinkDecodable()
    var tabUrlImage : [String]?
    var recipeFavorite : RecipeFavoriteProtocol! = RecipeFavoriteTest.shared
    var storageManager : StorageManagerProtocol! = StorageManager.shared
    
    @IBOutlet weak var textFieldIngredient: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    // we load the data in CoreData for give value at recipeFavorite
    override func viewDidLoad() {
        super.viewDidLoad()
        recipeFavorite.addRecipe(storageManager.loadRecipe())
    }
    
    enum ButtonHidden{
        case buttonIsHidden
        case buttonIsVisible
    }
    
    //we use this function for hide the button or not
    func setButton(_ style : ButtonHidden){
        switch style{
        case .buttonIsHidden:
            buttonValidate.isHidden = true
            indicatorActivity.isHidden = false
        case .buttonIsVisible:
            buttonValidate.isHidden = false
            indicatorActivity.isHidden=true
        }
    }
    
    //we call the function to clear all the ingredients
    @IBAction func clearButton(_ sender: Any) {
        ingredient.clearIngredient()
        tableView.reloadData()
    }
    
    //we call the function to add one ingredient
    @IBAction func AddButton(_ sender: Any) {
       guard let name = textFieldIngredient.text else{
            return
        }
        ingredient.addIngredient(name)
        tableView.reloadData()
        textFieldIngredient.text = ""
    }
    
    
    //we give the value to the segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SegueToListRecipeViewController"{
            let successVC = segue.destination as! ListRecipeViewController
            successVC.recipe = recipe
            successVC.recipeNext = recipeNext
        }
    }
    
    
    //When we click on the validateButton, we use the network call and we give the value at the segue
    @IBAction func validateButton(_ sender: Any) {
        self.setButton(.buttonIsHidden)
        let numberOfCount = ingredient.name.count
        //
        var stringIngredient = ""
        if numberOfCount != 0{
            for i in 0 ... numberOfCount - 1{
                stringIngredient.append("\(ingredient.name[i]) ")
            }
            recipeServiceAF.getRecipe(stringIngredient)
            
            recipeServiceAF.completionHandler { response, responsNext, status in
                if status{
                    
                    guard let _recipe  = response else {return}
                    guard let _recipeNext = responsNext else{return}
                    self.recipe = _recipe
                    self.recipeNext = _recipeNext
                    self.performSegue(withIdentifier: "SegueToListRecipeViewController", sender: nil)
                    self.setButton(.buttonIsVisible)
                }
            }
        }
        else{
            alerte.alerteVc(.EmptyList, self)
            self.setButton(.buttonIsVisible)
        }
    }
}

// keyboard management
extension AddIngredientsViewController : UITextFieldDelegate {
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        textFieldIngredient.resignFirstResponder()
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textFieldIngredient.resignFirstResponder()
    }
}



extension AddIngredientsViewController : UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        ingredient.name.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "IngredientsCell", for: indexPath) as? AddIngredientTableViewCell else{
            return UITableViewCell()
        }
        
        let ingredient = ingredient.name[indexPath.row]
        cell.configure(title: ingredient)
        return cell
    }
}



// delete data in tableView
extension AddIngredientsViewController : UITableViewDelegate{
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            ingredient.removeIngredient(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}

