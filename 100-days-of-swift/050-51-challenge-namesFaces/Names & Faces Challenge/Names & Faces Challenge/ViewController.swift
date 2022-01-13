//
//  ViewController.swift
//  Names & Faces Challenge
//
//  Created by Daniel Sasse on 1/13/22.
//

import UIKit

class ViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var items = [Item]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addEntry))
        title = "My Items"
        
        DispatchQueue.global(qos: .userInitiated).async {
            [weak self] in
            self?.loadItems()
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "Item", for: indexPath) as? ItemCell {
            let item = items[indexPath.row]
            
            cell.itemLabel.text = item.itemName
            let imagePath = getDocumentsDirectory().appendingPathComponent(item.imageName).path
            cell.itemImageView.image = UIImage(contentsOfFile: imagePath)
            return cell
        } else {
            fatalError("Unable to get useable cell")
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = items[indexPath.row]
        let imagePath = getDocumentsDirectory().appendingPathComponent(item.imageName).path
        
        if let detailViewController = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            detailViewController.detailImageView.image = UIImage(contentsOfFile: imagePath)
            detailViewController.detailLabel.text = item.itemName
            navigationController?.pushViewController(detailViewController, animated: true)
        }
    }
    
    @objc func addEntry(){
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        picker.sourceType = .camera
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else {return}
        let imageName = UUID().uuidString
        
        let imagePath = getDocumentsDirectory().appendingPathComponent(imageName)
        
        if let jpegData = image.jpegData(compressionQuality: 0.8){
            try? jpegData.write(to: imagePath)
        }
        
        let item = Item(itemName: "Unknown", imageName: imageName)
        items.append(item)
        save()
        tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
        
        dismiss(animated: true, completion: nil)
    }
    
    func save(){
        let jsonEncoder = JSONEncoder()
        if let itemsData = try? jsonEncoder.encode(items) as Data {
            let defaults = UserDefaults.standard
            defaults.set(itemsData, forKey: "items")
        } else {
            print("Failed to save data")
        }
    }
    
    func loadItems(){
        let defaults = UserDefaults.standard
        if let itemsData = defaults.object(forKey: "items") as? Data {
            let jsonDecoder = JSONDecoder()
            do {
                items = try jsonDecoder.decode([Item].self, from: itemsData)
            } catch {
                print("Failed to load data")
            }
        }
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}

