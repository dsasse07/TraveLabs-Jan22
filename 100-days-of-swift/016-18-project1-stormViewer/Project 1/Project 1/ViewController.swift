//
//  ViewController.swift
//  Project 1
//
//  Created by Daniel Sasse on 1/4/22.
//

import UIKit

class ViewController: UITableViewController {
    var pictures = [String]() // Initialize images as an empty array

    override func viewDidLoad() {
        super.viewDidLoad() // run UIViewController.viewDidLoad before my code is run
        
        //Sets Title in the navigation bar
        title = "Storm Viewer"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let fm = FileManager.default // Get the file manager
        let path = Bundle.main.resourcePath! // Find the path to the files for this bundle
        let items = try! fm.contentsOfDirectory(atPath: path) // get all of the contents of the path from earlier

        // Loop through the items in the path, finding the files that all start with "nssl"
        for item in items {
            if item.hasPrefix("nssl"){
                pictures.append(item)
            }
        }
        print(pictures)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pictures.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Picture", for: indexPath)
        cell.textLabel?.text = pictures[indexPath.row]
        return cell
    }
    
    // When we pick a picture...
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // If we select a row, we are going to go to the storyBoard where the current viewController lives, and
        // Instantiate a new view Controller with a specific identifier.
        // We know that the view controller we are picking has a specific class, to typecast it to that class.
        // Optional chaining is here bc Swift doesnt know if we used a storyboard
        if let detailViewController = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            
            // Set selectedImage string with the value from the row we selected
            detailViewController.selectedImage = pictures[indexPath.row]
            
            // Tell the navigation controller to load the new view
            navigationController?.pushViewController(detailViewController, animated: true)
        }
    }

}

