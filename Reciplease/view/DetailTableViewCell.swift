//
//  DetailTableViewCell.swift
//  Reciplease
//
//  Created by Brian Friess on 29/07/2021.
//

import UIKit

class DetailTableViewCell: UITableViewCell {

   
    @IBOutlet weak var labelDetail: UILabel!
    

    func configure(detail : String){
        labelDetail.text = "- " + detail
    }
}
