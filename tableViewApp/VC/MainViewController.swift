//
//  MainViewController.swift
//  tableViewApp
//
//  Created by Рустам Т on 2/8/23.
//

import UIKit
import RealmSwift

class MainViewController: UITableViewController {
    
    private var places: Results<Place>!
    private var ascendingSorting = false
    private let searchController = UISearchController(searchResultsController: nil)
    private var filtredPlaces: Results<Place>!
    private var searchBarIsEmpty: Bool{
        guard let text = searchController.searchBar.text else {return false}
        return text.isEmpty
    }
    private var isFiltering: Bool{
        return searchController.isActive && !searchBarIsEmpty
    }
    
    
    @IBOutlet weak var segmentCtrl: UISegmentedControl!
    @IBOutlet weak var barButtonSort: UIBarButtonItem!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        places = realm.objects(Place.self)
        
        //searchController
        //получателем информации должен быть наш класс
        searchController.searchResultsUpdater = self
        //что бы можно было взаимодействовать с ВК как с основным
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        //интергрируем в нав бак
        navigationItem.searchController = searchController
        //позволяет отпустить строку поиска при переходе на другой экран
        definesPresentationContext = true
        
    }
    
    
    @IBAction func barButtonPressed(_ sender: UIBarButtonItem) {
        ascendingSorting.toggle()
        if ascendingSorting{
            barButtonSort.image = UIImage(systemName: "arrow.up.to.line.compact")
        }else{
            barButtonSort.image = UIImage(systemName: "arrow.down.to.line.compact")
        }
        sort()
    }
    @IBAction func segmentedPressed(_ sender: UISegmentedControl) {
        sort()
    }
    
    private func sort(){
        if segmentCtrl.selectedSegmentIndex == 0 {
            places = places.sorted(byKeyPath: "name", ascending: ascendingSorting)
        }else {
            places = places.sorted(byKeyPath: "date", ascending: ascendingSorting)
        }
        tableView.reloadData()
    }
    
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if isFiltering{
           return filtredPlaces.count
        }
        
        return places.isEmpty ? 0 : places.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CustomTableViewCell
        var place = Place()
        
        if isFiltering{
            place = filtredPlaces[indexPath.row]
        }else{
            place = places[indexPath.row]
        }
        
        cell.nameLabel.text = place.name
        cell.typeLabel.text = place.type
        cell.locationLabel.text = place.location
        cell.imageOfPlace.image = UIImage(data: place.imageData! )
        
        
        cell.imageOfPlace.layer.cornerRadius = cell.imageOfPlace.frame.size.height / 2
        cell.imageOfPlace.clipsToBounds  = true
        return cell
        
    }
    
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        true
    }
    
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        true
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete{
            let place = places[indexPath.row]
            Storage.delete(place)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "show"{
            guard let indexPath = tableView.indexPathForSelectedRow else {return}
            let place: Place
            if isFiltering{
                place = filtredPlaces[indexPath.row]
            }else{
                place = places[indexPath.row]
            }
            
            let newPlaceVC = segue.destination as! NewPlaceViewController
            newPlaceVC.currentPlace = place
        }
    }
    
    
    @IBAction func unwindSegue(_ segue: UIStoryboardSegue){
        guard let newPlaceVC = segue.source as? NewPlaceViewController else {return}
        newPlaceVC.savePlace()
        tableView.reloadData()
    }
}


extension MainViewController: UISearchResultsUpdating{
    
    func updateSearchResults(for searchController: UISearchController) {
        filterContent(searchController.searchBar.text!)
    }
    
    private func filterContent(_ searchText: String){
        filtredPlaces = places.filter("name CONTAINS[c] %@ OR location CONTAINS[c] %@", searchText, searchText)
         
        tableView.reloadData()
    }
}
