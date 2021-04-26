//
//  MainCollectionViewController.swift
//  Curiosity
//
//  Created by Алексей on 22.04.2021.
//

import UIKit
import RealmSwift

private let reuseIdentifier = "cell"

class MainCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    private var marsPhotos: Results<MarsPhoto>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        marsPhotos = StorageManager.shared.fetchData()
        
        StorageManager.shared.configureDB {
            self.marsPhotos = StorageManager.shared.fetchData()
            self.collectionView.reloadData()
        }
        
        setupLongGestureRecognizerOnCollection()
    }
    
    // MARK: UICollectionViewDataSource
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        marsPhotos.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! MainCollectionViewCell
        
        cell.configureCell(with: marsPhotos[indexPath.row].img)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = UIScreen.main.bounds.width / 2 - 20
        
        let size = CGSize(width: width, height: 150)
        return size
    }
    
    // MARK: UICollectionViewDelegate
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let data = marsPhotos[indexPath.row]
        performSegue(withIdentifier: "showImage", sender: data)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showImage" {
            if let imageVC = segue.destination as? ImageViewController {
                let data = sender as? MarsPhoto
                imageVC.data = data
            }
        }
    }
    
}

// MARK: Recognizer
extension MainCollectionViewController: UIGestureRecognizerDelegate {
    private func setupLongGestureRecognizerOnCollection() {
        let longPressedGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(gestureRecognizer:)))
        longPressedGesture.minimumPressDuration = 0.5
        longPressedGesture.delegate = self
        longPressedGesture.delaysTouchesBegan = true
        collectionView?.addGestureRecognizer(longPressedGesture)
    }
    
    @objc func handleLongPress(gestureRecognizer: UILongPressGestureRecognizer) {
        if (gestureRecognizer.state != .began) { return }
        
        let location = gestureRecognizer.location(in: collectionView)
        
        if let indexPath = collectionView?.indexPathForItem(at: location) {
            
            let alert = UIAlertController(title: "Удалить", message: "Удалить изображение?", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Yes", style: .destructive) { _ in
                StorageManager.shared.delete(image: self.marsPhotos[indexPath.row]) {
                    StorageManager.shared.configureDB {
                        self.marsPhotos = StorageManager.shared.fetchData()
                        self.collectionView.reloadData()
                    }
                }
            }
            
            let cancelAction = UIAlertAction(title: "No", style: .cancel)
            alert.addAction(okAction)
            alert.addAction(cancelAction)
            present(alert, animated: true)
            
            collectionView.reloadData()
        }
    }
    
}
