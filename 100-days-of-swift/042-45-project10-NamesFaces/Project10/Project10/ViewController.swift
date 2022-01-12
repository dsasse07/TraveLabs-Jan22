//
//  ViewController.swift
//  Project10
//
//  Created by Daniel Sasse on 1/12/22.
//

import UIKit

class ViewController: UICollectionViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var people = [Person]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewPerson))
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return people.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Person", for: indexPath) as? PersonCell else {
            fatalError("Unable to dequeue a PersonCell")
        }
        
        let person = people[indexPath.item]
        
        cell.name.text = person.name
        
        let imagePath = getDocumentsDirectory().appendingPathComponent(person.imageName)
        cell.imageView.image = UIImage(contentsOfFile: imagePath.path)
        
        // Creates a custom color with zero white value (black) @ 30% transparency
        cell.imageView.layer.borderColor = UIColor.init(white: 0, alpha: 0.3).cgColor
        cell.imageView.layer.borderWidth = 2
        cell.imageView.layer.cornerRadius = 3
        cell.layer.cornerRadius = 7
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let person = people[indexPath.item]
        
        let ac = UIAlertController(title: "\(person.name)", message: nil, preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "Edit Name", style: .default){
            [weak self] action in
            self?.presentEditPerson(person: person)
        })
        ac.addAction(UIAlertAction(title: "Delete Person", style: .destructive){
            [weak self] action in
            self?.presentDeletePerson(person: person, itemNumber: indexPath.item)
        })
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        ac.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(ac, animated: true, completion: nil)
    }
    
    func presentEditPerson(person: Person){
        let ac = UIAlertController(title: "Edit Name", message: "Who is this person", preferredStyle: .alert)
        ac.addTextField()
        ac.addAction(UIAlertAction(title: "Ok", style: .default) {
            [weak self, weak ac] action in
            guard let newName = ac?.textFields?[0].text else {return}
            person.name = newName
            self?.collectionView.reloadData()
        })
        ac.addAction((UIAlertAction(title: "Cancel", style: .cancel, handler: nil)))
        present(ac, animated: true, completion: nil)
    }
    
    
    func presentDeletePerson(person: Person, itemNumber: Int){
        let ac = UIAlertController(title: "Delete \(person.name)", message: "Are you sure?", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Delete", style: .destructive) {
            [weak self] action in
            self?.people.remove(at: itemNumber)
            self?.collectionView.reloadData()
        })
        ac.addAction((UIAlertAction(title: "Cancel", style: .cancel, handler: nil)))
        present(ac, animated: true, completion: nil)
    }
    
    @objc func addNewPerson(){
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        // We want view controller to respond to messages from the picker
        // Must conform to two protocols to be a delegate: UIImagePickerControllerDelegate, UINavigationControllerDelegate
        // UIImagePickerControllerDelegate Tells us when the user chose an image or cancelled
        // UINavigationControllerDelegate Not actually used in this case, but required for conforming
        picker.delegate = self
        present(picker, animated: true, completion: nil)
    }
    
    // User selected a photo to add to the app...
    // takes in a Dictionary of data from the UIImagePickerController
    // The keys are enum values such as: originalImage, edittedImage, livePhoto, mediaMetadata, etc
    // we must typecast the value since it van vary and is set to Any by default
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else {return}
        
        // Must save image with a unique identifier to avoid data overwrite on the disk. Use a new UUID
        let imageName = UUID().uuidString
        
        // Find where we are going to save the image data for our app and append file name to create the path
        let imagePath = getDocumentsDirectory().appendingPathComponent(imageName)
        
        if let jpegData = image.jpegData(compressionQuality: 0.8) {
            try? jpegData.write(to: imagePath)
        }
        //Create a person with this new image
        let person = Person(name: "Unknown", imageName: imageName)
        people.append(person)
        collectionView.reloadData()
        
        // Dismisses whatever view controller is at the top of the stack
        dismiss(animated: true, completion: nil)
    }
    
    func getDocumentsDirectory() -> URL {
        // Returns an array of paths, but for these params it is nearly always just one item, since we only want the
        // path of the current user's document directory
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }


}

