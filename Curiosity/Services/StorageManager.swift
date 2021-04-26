//
//  StorageManager.swift
//  Curiosity
//
//  Created by Алексей on 25.04.2021.
//

import RealmSwift
import Kingfisher

class StorageManager {
    static let shared = StorageManager()
    
    let base = try! Realm()
    let deleted = try! Realm()
    
    private init() {}
    
    func save(image: MarsPhoto) {
        write {
            base.add(image)
        }
    }
    
    func save(deleted: DeletedMarsPhoto) {
        write {
            base.add(deleted)
        }
    }
    
    func fetchData() -> Results<MarsPhoto> {
        return base.objects(MarsPhoto.self)
    }
    
    func fetchDeleted() -> Results<DeletedMarsPhoto> {
        return deleted.objects(DeletedMarsPhoto.self)
    }
    
    func delete(image: MarsPhoto, completion: () -> Void) {
        write {
            
            let marsPhoto = DeletedMarsPhoto()
            marsPhoto.id = image.id
            self.save(deleted: marsPhoto)
            
            base.delete(image)
            
            completion()
        }
    }
    
    private func write(_ completion: () -> Void) {
        do {
            try base.safeWrite {
                completion()
            }
        } catch let error {
            print(error)
        }
    }
    
    func configureDB(completion: (() -> Void)? = nil) {
        let data = fetchData()
        let deleted = fetchDeleted()
        
        var counter = data.count
        
        DispatchQueue.main.async {
            NetworkManager.shared.getJSONData(with: Photos.self) { result, isSuccess, error in
                if isSuccess, let result = result {
                    result.photos.forEach { photoData in
                        
                        if counter < 25 {
                            guard !data.contains(where: {$0.id == photoData.id }),
                                  !deleted.contains(where: { $0.id == photoData.id }),
                                  let url = URL(string: photoData.imgSrc) else { return }
                            counter += 1
                            
                            KingfisherManager.shared.retrieveImage(with: url,
                                                                   options: nil,
                                                                   progressBlock: nil) { result in
                                
                                switch result {
                                case .success(let value):
                                    guard let data = value.image.jpegData(compressionQuality: 1) else { return }
                                    
                                    let photo = MarsPhoto()
                                    photo.id = photoData.id
                                    photo.img = data
                                    
                                    self.save(image: photo)
                                    
                                    completion?()
                                    
                                    
                                case .failure(let error):
                                    print("Error: \(error)")
                                }
                            }
                        } else {
                            return
                        }
                    }
                }
            }
        }
    }
}

extension Realm {
    public func safeWrite(_ block: (() throws -> Void)) throws {
        if isInWriteTransaction {
            try block()
        } else {
            try write(block)
        }
    }
}
