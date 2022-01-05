//
//  ViewController.swift
//  Flag Share
//
//  Created by Daniel Sasse on 1/5/22.
//

import UIKit

class ViewController: UITableViewController {
    var countries = ["estonia", "france", "germany", "ireland", "italy", "monaco", "nigeria", "poland", "russia", "uk", "us"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Flag Share"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countries.count
    }
    //Todo: Add border to flag images
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Flag", for: indexPath)
        var cellContents = cell.defaultContentConfiguration()
        
        if let cellImage = UIImage(named: countries[indexPath.row]) {
            cellContents.image = cellImage.preparingThumbnail(of: cellImage.size.applying(CGAffineTransform(scaleX: 0.25, y: 0.25)))
        }
        
        cellContents.text = countries[indexPath.row]
        cell.contentConfiguration = cellContents
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let detailViewController = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            detailViewController.flagToDisplay = countries[indexPath.row]
            navigationController?.pushViewController(detailViewController, animated: true)
        }
    }
}

