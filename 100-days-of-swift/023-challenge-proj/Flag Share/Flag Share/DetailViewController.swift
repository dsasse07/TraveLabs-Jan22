//
//  DetailViewController.swift
//  Flag Share
//
//  Created by Daniel Sasse on 1/5/22.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet var imageView: UIImageView!
    var flagToDisplay: String? = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = flagToDisplay
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareFlag))

        if let imageToDisplay = flagToDisplay {
            imageView.image = UIImage(named: imageToDisplay)
            imageView.layer.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.05).cgColor
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnTap = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.hidesBarsOnTap = false
    }
    
    @objc func shareFlag(){
        guard let image = imageView.image?.jpegData(compressionQuality: 1) else {
            print("No Image Found")
            return
        }
        let activityViewController = UIActivityViewController(activityItems: [image], applicationActivities: [])
        activityViewController.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(activityViewController, animated: true, completion: nil)
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
