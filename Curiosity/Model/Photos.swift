//
//  Photos.swift
//  Curiosity
//
//  Created by Алексей on 22.04.2021.
//

// MARK: - Photos
struct Photos: Codable {
    let photos: [Photo]
}

// MARK: - Photo
struct Photo: Codable {
    let id: Int
    let imgSrc: String
    let earthDate: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case earthDate = "earth_date"
        case imgSrc = "img_src"
    }
}
