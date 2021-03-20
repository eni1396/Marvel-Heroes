//
//  NetworkManager.swift
//  Marvel Heroes
//
//  Created by Nikita Entin on 03.03.2021.
//

import Foundation

class NetworkManager {
    let ts = String(Date().toMillis())
    
    func fetchGenericData<T: Codable>(stringURL: String, completion: @escaping (T) -> ()) {
        guard let url = URL(string: stringURL) else { return }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else { return }
            do {
                let object = try JSONDecoder().decode(T.self, from: data)
                completion(object)
            } catch let error as NSError{
                print(error.userInfo)
            }
        }.resume()
    }
}
