//
//  NetworkManager.swift
//  Marvel Heroes
//
//  Created by Nikita Entin on 03.03.2021.
//

import Foundation

///Получение данных из сети по запросу
class NetworkManager {
    private var urlString = ""
    
    enum RequestType {
        case characters, comics, creators
    }
    
    func fetchGenericData<T: Codable>(from type: RequestType, searchText: String, completion: @escaping (T) -> ()) {
            switch type {
            case .characters:
                urlString = "https://gateway.marvel.com:443/v1/public/characters?name=\(searchText)&ts=\(ts)&apikey=\(publicKey)&hash=\(hashVal)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            case .comics:
                urlString = "https://gateway.marvel.com:443/v1/public/comics?title=\(searchText)&ts=\(ts)&apikey=\(publicKey)&hash=\(hashVal)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            case .creators:
                let splitName = searchText.split(separator: " ")
                urlString = "https://gateway.marvel.com:443/v1/public/creators?firstName=\(splitName.first ?? "")&lastName=\(splitName.last ?? "")&ts=\(ts)&apikey=\(publicKey)&hash=\(hashVal)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            }
            guard let url = URL(string: urlString) else { return }
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                guard let data = data else { return }
                do {
                    let object = try JSONDecoder().decode(T.self, from: data)
                    completion(object)
                } catch let error as NSError {
                    print(error.userInfo)
                }
            }.resume()
        }
}
