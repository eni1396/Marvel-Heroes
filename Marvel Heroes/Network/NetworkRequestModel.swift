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
    var creators = [ResultCreator]()
    var imageView: UIImageView!
    var textName: UILabel!
    var textAppear: UILabel!
    var textDescr: UILabel!
    var urlView: UITextView!
    var activityIndicator: UIActivityIndicatorView!
    private var urlString = ""
    
    func fetchCharacters(searchText: String) {
        activityIndicator.startAnimating()
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
                        self.activityIndicator.stopAnimating()
                    }
                }
            }
        }
    }
    
    func fetchComics(searchText: String) {
        activityIndicator.startAnimating()
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
                    self.activityIndicator.stopAnimating()
                }
            }
        }
    }
    
    func fetchCreators(searchText: String) {
        let splitName = searchText.split(separator: " ")
        //let linkedName = "firstName=\(creators[0].firstName)" + "&" + "lastName=\(creators[0].lastName)"
        activityIndicator.startAnimating()
        urlString = "https://gateway.marvel.com:443/v1/public/creators?firstName=\(splitName.first ?? "")&lastName=\(splitName.last ?? "")&ts=\(ts)&apikey=\(publicKey)&hash=\(hashVal)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        networkManager.fetchGenericData(stringURL: urlString) { (currentCreator: CurrentCreator) in
            self.creators = currentCreator.data.results
            DispatchQueue.global().async {
                let urlString = "\(self.creators.first?.thumbnail.path ?? "").\(self.creators.first?.thumbnail.thumbnailExtension ?? "")"
                guard let url = URL(string: urlString), let imageData = try? Data(contentsOf: url) else { return }
                DispatchQueue.main.async {
                    self.imageView.image = UIImage(data: imageData)
                    self.textName.text = self.creators.first?.fullName
                    //self.currentAppearances.text = self.comicsArray.first?.
//                    guard let url = URL(string: self.comics.first?.urls.first?.url ?? "") else { return }
//                    let attr = NSMutableAttributedString(string: "More info at Marvel Wiki")
//                    attr.setAttributes([.link: url], range: NSMakeRange(0, attr.length))
//                    self.urlView.attributedText = attr
//                    self.urlView.isUserInteractionEnabled = true
//                    self.urlView.isEditable = false
//                    self.textDescr.text = "Bio: \(self.comics.first?.description ?? "Bio: No Bio Provided")"
                    self.activityIndicator.stopAnimating()
                }
            }
        }
    }
}
