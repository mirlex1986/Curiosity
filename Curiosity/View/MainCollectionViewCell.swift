//
//  MainCollectionViewCell.swift
//  Curiosity
//
//  Created by Алексей on 22.04.2021.
//

import UIKit

class MainCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var photo: UIImageView!
    
    func configureCell(with data: Data) {
        photo.image = UIImage(data: data)
        backgroundColor = .systemGray3
    }
    
}
