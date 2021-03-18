//
//  Model.swift
//  Marvel Heroes
//
//  Created by Nikita Entin on 18.03.2021.
//

import Foundation
import UIKit

class NetworkRequestModel {
    
    private let networkManager = NetworkManager()
    var characters = [Result]()
    var comics = [ResultComics]()
    var imageView: UIImageView!
    var textName: UILabel!
    var textAppear: UILabel!
    var textDescr: UILabel!
    var urlView: UITextView!
    private var urlString = ""
    
    func fetchCharacters(searchText: String) {
        
        urlString = "https://gateway.marvel.com:443/v1/public/characters?name=\(searchText)&ts=\(ts)&apikey=\(publicKey)&hash=\(hashVal)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        networkManager.fetchGenericData(stringURL: urlString) { (currentHero: CurrentHero) in
            self.characters = currentHero.data.results
            DispatchQueue.global().async {
                for res in self.characters {
                    let stringURL = "\(res.thumbnail.path).\(res.thumbnail.thumbnailExtension)"
                    guard let url = URL(string: stringURL), let imageData = try? Data(contentsOf: url) else { return }
                    DispatchQueue.main.async {
                        self.imageView.image = UIImage(data: imageData)
                        self.textName.text = res.name
                        self.textAppear.text = "Appeared in: \(res.comics.items.randomElement()?.name ?? "")"
                        let url = URL(string: res.urls[1].url)!
                        let attr = NSMutableAttributedString(string: "More info at Marvel Wiki")
                        attr.setAttributes([.link: url], range: NSMakeRange(0, attr.length))
                        self.urlView.attributedText = attr
                        self.urlView.isUserInteractionEnabled = true
                        self.urlView.isEditable = false
                        
                        if !res.resultDescription.isEmpty {
                            self.textDescr.text = "Bio: \(res.resultDescription)"
                        } else {
                            self.textDescr.text = "Bio: No Bio Provided"
                        }
                    }
                }
            }
        }
    }
    
    func fetchComics(searchText: String) {
        
        urlString = "https://gateway.marvel.com:443/v1/public/comics?title=\(searchText)&ts=\(ts)&apikey=\(publicKey)&hash=\(hashVal)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        networkManager.fetchGenericData(stringURL: urlString) { (currentComics: CurrentComics) in
            self.comics = currentComics.data.results
            DispatchQueue.global().async {
                let urlString = "\(self.comics.first?.thumbnail.path ?? "").\(self.comics.first?.thumbnail.thumbnailExtension ?? "")"
                guard let url = URL(string: urlString), let imageData = try? Data(contentsOf: url) else { return }
                DispatchQueue.main.async {
                    self.imageView.image = UIImage(data: imageData)
                    self.textName.text = self.comics.first?.title
                    //self.currentAppearances.text = self.comicsArray.first?.
                    guard let url = URL(string: self.comics.first?.urls.first?.url ?? "") else { return }
                    let attr = NSMutableAttributedString(string: "More info at Marvel Wiki")
                    attr.setAttributes([.link: url], range: NSMakeRange(0, attr.length))
                    self.urlView.attributedText = attr
                    self.urlView.isUserInteractionEnabled = true
                    self.urlView.isEditable = false
                    self.textDescr.text = "Bio: \(self.comics.first?.description ?? "Bio: No Bio Provided")"
                }
            }
        }
    }
}
