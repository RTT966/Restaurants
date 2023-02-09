//
//  MainViewController.swift
//  tableViewApp
//
//  Created by Рустам Т on 2/8/23.
//

import UIKit

class MainViewController: UITableViewController {

    
    var restaurant = ["Restaurant Voyage", "Nikala",
                      "Wine House Kobuleti", "Sunset Kobuleti",
                      "Chkimarte", "Restaurant Sakalmakhe",
                      "Daviti", "Shua Qalaqshi",
                      "Restaurant Kent Beach", "Shua Kalaki", "restaurant ADMIRAL"]
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return restaurant.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        cell.textLabel?.text = restaurant[indexPath.row]
        cell.imageView?.image = UIImage(named: restaurant[indexPath.row])
        cell.imageView?.layer.cornerRadius = cell.frame.size.height / 2
        cell.imageView?.clipsToBounds  = true
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
