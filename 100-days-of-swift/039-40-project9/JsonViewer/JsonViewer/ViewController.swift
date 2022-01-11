//
//  ViewController.swift
//  JsonViewer
//
//  Created by Daniel Sasse on 1/7/22.
//

import UIKit

/**
 We are going to add Threading and async actions. Caveats about threading:
 1. Threads will not automatically activate. Threads will only execute the code we give them. By default only one thread is created/used
 2. All UI work must be done on the primary thread that the App is launched on. Otherwise it may work, work wrong, or blow up
 3. There is no control over when a thread will run, or in what order
 4. Because we cannot control thread execution order, we must check to ensure that only one thread is updating the data to avoid duplicate actions or overwriting
 
 Use Examples:
 1. Getting data from remote resource.
 2. Any slow code
 3. Any code that can run in parallel (bulk edit, ex: adding filter to 100 photos)
 
 GCD:
 - Works with queues, and places tasks in them based on assigned priority
    - Priority is determined by Quality of Service property (QoS)
            - 5 background queues:
                - Does not care about battery life:
                    - User Interactive (nearly all cpu time available to get it done asap
                    - User Initiated (work that a user must wait for in order to continue, not blocking of User Interactive)
 
                - Default Queue -> Exists between User Initiated and Utility
 
                - Will balance battery life and performance:
                    - Utility (long running tasks the user is aware of, but not immediately needed, ex: processing lots of photos)
                - Executed with battery life as a priority:
                    - Background (long running tasks that the user isnt necessarily aware of or care about. They get done when they can)
 - Threads grab jobs from the queue and they become available for work
 
 */

class ViewController: UITableViewController {
    var petitions = [Petition]()
    var filteredPetitions = [Petition]()
    var filterString: String = "" {
        didSet {
            if filterString == "" {
                filteredPetitions = petitions
                tableView.reloadData()
            } else {
                DispatchQueue.global(qos: .userInitiated).async {
                    [weak self] in
                        guard let filterString = self?.filterString else {return}
                        guard let petitions = self?.petitions else {return}
                        self?.filteredPetitions = petitions.filter {
                            petition in
                                petition.body.lowercased().contains(filterString) ||
                                petition.title.lowercased().contains(filterString)
                        }
                    self?.performSelector(onMainThread: #selector(self?.reloadUI), with: nil, waitUntilDone: false)
                }
            }
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
        /** Using DispatchQueue
        DispatchQueue.global(qos: .userInitiated).async {
            [weak self] in
            self?.fetchData(url: urlString)
        }
         */
        performSelector(inBackground: #selector(fetchData), with: urlString)
    }
    
    @objc func fetchData(url: String){
        if let url = URL(string: url) {
            if let data = try? Data(contentsOf: url){
                parseJson(data: data)
                return
            }
        }
        
        performSelector(onMainThread: #selector(showError), with: nil, waitUntilDone: false)
        /**
        DispatchQueue.main.async {
            [weak self] in
            self?.showError()
        }
         */
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
    
    @objc func showError() {
        let ac = UIAlertController(title: "Error", message: "There was a problem loading the feed; please check your connection and try again.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(ac, animated: true, completion: nil)
    }
    
    func parseJson(data: Data){
        let decoder = JSONDecoder()
        if let jsonPetitions = try? decoder.decode(Petitions.self, from: data){
            petitions = jsonPetitions.results
            filteredPetitions = petitions
            
            performSelector(onMainThread: #selector(reloadUI), with: nil, waitUntilDone: false)
            /**
            DispatchQueue.main.async {
                [weak self] in
                self?.tableView.reloadData()
            }
             */
        } else {
            performSelector(inBackground: #selector(showError), with: nil)
        }
    }
    
    @objc func reloadUI(){
        tableView.reloadData()
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

