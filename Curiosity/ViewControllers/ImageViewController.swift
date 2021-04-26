//
//  ImageViewController.swift
//  Curiosity
//
//  Created by Алексей on 25.04.2021.
//

import UIKit

class ImageViewController: UIViewController {

    var imageScrollView: ImageScrollView!
    var data: MarsPhoto!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageScrollView = ImageScrollView(frame: view.bounds)
        view.addSubview(imageScrollView)
        setupImageScrollView()

        if let image = UIImage(data: data.img) {
            self.imageScrollView.set(image: image)
        } else {
            self.imageScrollView.set(image: UIImage(systemName: "photo")!)
        }

    }

    private func setupImageScrollView() {
        imageScrollView.translatesAutoresizingMaskIntoConstraints = false
        imageScrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        imageScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        imageScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        imageScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
    }

}
