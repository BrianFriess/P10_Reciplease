//
//  ListRecipe.swift
//  Reciplease
//
//  Created by Brian Friess on 21/07/2021.
//

import UIKit

class ListRecipeViewController : UIViewController {

    
    var recipe = DataRecipeDecodable()
    var cellCustom = RecipeTableViewCell()
    var imageService = ImageRecipeServiceAlamofire(requester: ImageRecipeService())
    var recipeDetail = RecipeDecodable()
    var currentImage : UIImage?
    var ispaginating = false
    var recipeNext = DataLinkDecodable()
    var recipeFavorite : RecipeFavoriteProtocol! = RecipeFavoriteManager.shared

    
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
    }
    
    //we load the data in CoreData for give value at recipeFavorite
    override func viewWillAppear(_ animated: Bool) {
        recipeFavorite.loadFavoriteRecipe()
    }
    
    //we give the value to the segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SegueToDetailRecipeViewController"{
            let successVC = segue.destination as! DetailRecipeViewController
            successVC.recipeDetail = recipeDetail
            successVC.currentImage = currentImage
        }
    }
}

//tableView Manager
extension ListRecipeViewController : UITableViewDataSource, UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipe.hits?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //custom cell
       guard let cell = tableView.dequeueReusableCell(withIdentifier: "RecipesCell", for: indexPath) as? RecipeTableViewCell else{
        return UITableViewCell()
       }
        let recipe = recipe.hits?[indexPath.row]
        
        cell.configure(title: (recipe?.recipe?.label)!, subtitles: (recipe?.recipe?.ingredientLines)!, rate: (recipe?.recipe?.yield)!, time: (recipe?.recipe?.totalTime)!)
    
        //if we don't have an image in network Call, we give a default image
        if let imageDisplay = recipe?.recipe?.imageData {
            cell.configureImage(image: UIImage(data: imageDisplay)!)
        } else{
            cell.configureImage(image: UIImage(systemName: "questionmark.circle.fill")!)
        }

        return cell
    }
    
    // We select data when whe click on the cell
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        recipeDetail = recipe.hits![indexPath.row]
        currentImage = UIImage(data: (self.recipe.hits?[indexPath.row].recipe?.imageData)!)
        self.performSegue(withIdentifier: "SegueToDetailRecipeViewController", sender: nil)
    }
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {

        guard let recipe = recipe.hits?[indexPath.row], let image = recipe.recipe?.image else {fatalError()}
    
        //we check if we have already an image
        if self.recipe.hits?[indexPath.row].recipe?.imageData == nil{
            //if not, we use the network call
            imageService.getImage(urlImage: image) { image, status in
                if status == true{
                    guard let dataImage = image, let _image = UIImage(data: dataImage) else{return}
                    self.recipe.hits?[indexPath.row].recipe?.imageData = _image.pngData()
                    self.tableView.reloadRows(at: [indexPath], with: .fade)
                }
            }
        }
    }
}


// extension for pagination
extension ListRecipeViewController :  UIScrollViewDelegate{
    
    //create an activity controller for the pagination
    func createActivityController() -> UIView{
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 100))
        let spinner = UIActivityIndicatorView()
        spinner.center = footerView.center
        footerView.addSubview(spinner)
        spinner.startAnimating()
        return footerView
    }

    //pagination
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let nextRecipeService = RecipeServiceAlamofire(baseUrl: recipeNext._links?.next?.href ?? "", requester: AlamoFireRecipeService())
        let position = scrollView.contentOffset.y
        if position > (tableView.contentSize.height-100-scrollView.frame.size.height), ispaginating == false{
            ispaginating = true
        // use our activity controller for the pagination
        self.tableView.tableFooterView = createActivityController()
            //we call our function for the new network call
            nextRecipeService.getRecipe("")
            //we give the new value in the array
            nextRecipeService.completionHandler {response, responseNext, status in
                if status {
                    guard let nbResponse = response?.hits?.count else {return}
                    for i in 0 ..< nbResponse{
                        let newRecipe = response?.hits?[i]
                        self.recipe.hits?.append(newRecipe!)
                    }
                    //we change the url "recipeNext" with the new url
                    guard let _recipeNext = responseNext else {return}
                    self.recipeNext = _recipeNext
                    self.tableView.reloadData()
                    self.ispaginating = false
                }
            }
        }
    }
}
