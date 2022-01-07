//
//  ViewController.swift
//  JsonViewer
//
//  Created by Daniel Sasse on 1/7/22.
//

import UIKit

class ViewController: UITableViewController {
    var petitions = [Petition]()
    var filteredPetitions = [Petition]()
    var filterString: String = "" {
        didSet {
            if filterString == "" {
                filteredPetitions = petitions
            } else {
                filteredPetitions = petitions.filter {
                    petition in petition.body.lowercased().contains(filterString) || petition.title.lowercased().contains(filterString)
                    
                }
            }
            tableView.reloadData()
        }
    }
    var filterButton: UIBarButtonItem!
    var clearFilterButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        filterButton = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(filterPetitions))
        clearFilterButton = UIBarButtonItem(barButtonSystemItem: .undo, target: self, action: #selector(clearFilter))
        navigationItem.rightBarButtonItems = [filterButton, clearFilterButton]
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Credit", style: .plain, target: self, action: #selector(showCredits))
        title = "We the People"
        
        let urlString: String
        if navigationController?.tabBarItem.tag == 0 {
            urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"
        } else {
            urlString = "https://www.hackingwithswift.com/samples/petitions-2.json"
        }
        
        
        if let url = URL(string: urlString) {
            if let data = try? Data(contentsOf: url){
                parseJson(data: data)
                return
            }
        }
        
        showError()
    }
    
    @objc func showCredits() {
        let ac = UIAlertController(title: "Credit:", message: "All data froms the We The People API", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        ac.popoverPresentationController?.barButtonItem = navigationItem.leftBarButtonItem
        present(ac, animated: true, completion: nil)
    }
    
    @objc func filterPetitions(){
        let ac = UIAlertController(title: "Search", message: "Enter text to filter results", preferredStyle: .alert)
        ac.addTextField(configurationHandler: nil)
        
        let submitAction = UIAlertAction(title: "Search", style: .default) {
            [weak self, weak ac] action in
            guard let newFilterText = ac?.textFields?[0].text else { return }
            self?.updateFilter(newText: newFilterText)
        }
        
        ac.addAction(submitAction)
        ac.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItems?[0]
        present(ac, animated: true, completion: nil)
    }
    
    private func updateFilter(newText: String){
        filterString = newText.lowercased()
    }
    
    @objc func clearFilter(){
        filterString = ""
    }
    
    func showError() {
        let ac = UIAlertController(title: "Error", message: "There was a problem loading the feed; please check your connection and try again.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(ac, animated: true, completion: nil)
    }
    
    func parseJson(data: Data){
        let decoder = JSONDecoder()
        if let jsonPetitions = try? decoder.decode(Petitions.self, from: data){
            petitions = jsonPetitions.results
            filteredPetitions = petitions
            tableView.reloadData()
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredPetitions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        var cellContents = cell.defaultContentConfiguration()
        cellContents.text = filteredPetitions[indexPath.row].title
        cellContents.textProperties.numberOfLines = 1
        cellContents.secondaryText = filteredPetitions[indexPath.row].body
        cellContents.secondaryTextProperties.numberOfLines = 2
        cell.contentConfiguration = cellContents
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dvc = DetailViewController()
        dvc.detailItem = filteredPetitions[indexPath.row]
        navigationController?.pushViewController(dvc, animated: true)
    }
}

