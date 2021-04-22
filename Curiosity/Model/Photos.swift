//
//  Photos.swift
//  Curiosity
//
//  Created by Алексей on 22.04.2021.
//

import Foundation

// MARK: - Photos
struct Photos {
    let photos: [Photo]
}

// MARK: - Photo
struct Photo {
    let id, sol: Int
    let camera: Camera
    let imgSrc: String
    let earthDate: String
    let rover: Rover
}

// MARK: - Camera
struct Camera {
    let id: Int
    let name: CameraName
    let roverID: Int
    let fullName: FullName
}

enum FullName {
    case mastCamera
}

enum CameraName {
    case mast
}

// MARK: - Rover
struct Rover {
    let id: Int
    let name: RoverName
    let landingDate, launchDate: String
    let status: Status
}

enum RoverName {
    case curiosity
}

enum Status {
    case active
}
