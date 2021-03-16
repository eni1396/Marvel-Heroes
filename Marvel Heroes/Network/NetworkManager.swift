//
//  NetworkManager.swift
//  Marvel Heroes
//
//  Created by Nikita Entin on 03.03.2021.
//

import Foundation

class NetworkManager {
    private let ts = String(Date().toMillis())
    
//    enum Cheto: Decodable {
//        init(from decoder: Decoder) throws {
//            let container = try? decoder.singleValueContainer()
//
//            switch self {
//            case .single:
//                let data = try? container?.decode(Result.self)
//                self = .single(data)
//            default:
//                break
//            }
//        }
        
//        case single(Result?)
//    }
    
    
    enum RequestType {
        case characters(name: String)
        case charactersAll
        
        case comics(name: String)
        //        case comicsAll
        
        //        case events(name :String)
        //        case eventsAll
        
        //        case series(name: String)
        //        case seriesAll
        
        //        case creators(name: String)
        //        case creatorsAll
        
    }
    func fetchGenericData<T: Codable>(stringURL: String, completion: @escaping (T) -> ()) {
        guard let url = URL(string: stringURL) else { return }
        print(url)
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
    
//    func parseData(type: RequestType) {
//        switch type {
//        case .characters(let name):
//            urlString = "https://gateway.marvel.com:443/v1/public/characters?name=\(name.description)&ts=\(ts)&apikey=\(publicKey)&hash=\(hash)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
//        case .charactersAll:
//            urlString = "https://gateway.marvel.com:443/v1/public/characters?limit=50&ts=\(ts)&apikey=\(publicKey)&hash=\(hash)"
//        default:
//            break
//        }
//        guard let url = URL(string: urlString) else { return }
//        let dataTask = URLSession.shared.dataTask(with: url) { (data, response, error) in
//            if let data = data {
//                if let currentHero = self.parseJSON(withData: data) {
//                    self.onCompletion?(currentHero)
//                }
//            }
//        }
//        dataTask.resume()
//    }
//    func parseJSON(withData data: Data) -> CurrentHero? {
//        let decoder = JSONDecoder()
//        do {
//            let currentHeroData = try decoder.decode(CurrentHero.self, from: data)
//            return currentHeroData
//        } catch let error as NSError {
//            print(error.userInfo)
//        }
//
//        return nil
//    }
//
    
}
