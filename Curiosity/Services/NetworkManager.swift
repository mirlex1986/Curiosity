//
//  NetworkManager.swift
//  Curiosity
//
//  Created by Алексей on 22.04.2021.
//

import Foundation
import Alamofire

class NetworkManager {
    static let shared = NetworkManager()

    func getJSONData<T: Codable>(from url: String = "https://api.nasa.gov/mars-photos/api/v1/rovers/curiosity/photos?sol=3070&api_key=DEMO_KEY",
                                 with codableStruct: T.Type,
                                 complition: @escaping (T?, Bool, String) -> Void) {
        DispatchQueue.main.async {
            AF.request(url,
                       method: .get,
                       parameters: nil,
                       encoding: URLEncoding.default,
                       headers: nil,
                       interceptor: nil).response { responseData in
                        
                        guard let data = responseData.data else {
                            complition(nil, false, "Data not received")
                            return
                        }
                        
                        let jsonData = JSONDecoderService.shared.decodeData(fron: data,
                                                                            with: codableStruct.self)
                        complition(jsonData, true, "")
            }
        }
    }
}

final class JSONDecoderService {
    static let shared = JSONDecoderService()

    func decodeData<T: Codable>(fron jsonData: Data,
                                with codableStruct: T.Type) -> T? {
        do {
            let resultData = try JSONDecoder().decode(codableStruct.self, from: jsonData)
            return resultData
        } catch {
            print("Error: \(error.localizedDescription)")
        }
        
        return nil
    }
}
