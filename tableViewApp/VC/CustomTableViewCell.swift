//
//  CustomTableViewCell.swift
//  tableViewApp
//
//  Created by Рустам Т on 2/9/23.
//

import UIKit
import Cosmos
class CustomTableViewCell: UITableViewCell {

 
    @IBOutlet weak var imageOfPlace: UIImageView!{
        didSet{
            imageOfPlace.layer.cornerRadius = imageOfPlace.frame.size.height / 2
            imageOfPlace.clipsToBounds  = true
        }
    }
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
  
    
    @IBOutlet weak var cosView: CosmosView!{
        didSet{
            cosView.settings.updateOnTouch = false
        }
    }
    
}

