//
//  InfoVC.swift
//  Marvel Heroes
//
//  Created by Nikita Entin on 04.03.2021.
//

import UIKit

class InfoVC: UIViewController {
    
    let networkManager = NetworkManager()
    var charArray = [Result]()
    var comicsArray = [ResultComics]()
    
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var searchField: UISearchBar!
    @IBOutlet weak var currentImage: UIImageView!
    @IBOutlet weak var currentName: UILabel!
    @IBOutlet weak var currentDescription: UILabel!
    @IBOutlet weak var currentAppearances: UILabel!
    @IBOutlet weak var currentURL: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currentDescription.lineBreakMode = .byTruncatingTail
        currentAppearances.lineBreakMode = .byTruncatingTail
        currentDescription.numberOfLines = 8
        currentAppearances.numberOfLines = 3
        tapToHideKeyBoard()
        searchField.placeholder = "Search for \(title?.lowercased() ?? "")"
        loadingIndicator.hidesWhenStopped = true
    }
    func tapToHideKeyBoard() {
        let tap = UITapGestureRecognizer(target: view, action: #selector(view.endEditing))
        view.addGestureRecognizer(tap)
    }
    
    func refreshElements() {
        currentImage.image = nil
        currentName.text = nil
        currentDescription.text = nil
        currentAppearances.text = nil
        currentURL.text = nil
    }
}


extension InfoVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchField.text = searchBar.text
        self.loadingIndicator.startAnimating()
        //MARK:- Characters Setup
        if navigationItem.title == MainVC.cellNames[0] {
            networkManager.fetchGenericData(stringURL: "https://gateway.marvel.com:443/v1/public/characters?name=\(searchText)&ts=\(ts)&apikey=\(publicKey)&hash=\(hashVal)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!) { (currentHero: CurrentHero) in
                self.charArray = currentHero.data.results
                DispatchQueue.global().async {
                    for res in self.charArray {
                        let urlString = "\(res.thumbnail.path).\(res.thumbnail.thumbnailExtension)"
                        guard let url = URL(string: urlString), let imageData = try? Data(contentsOf: url) else { return }
                        DispatchQueue.main.async {
                            self.currentImage.image = UIImage(data: imageData)
                            self.currentName.text = res.name
                            self.currentAppearances.text = "Appeared in: \(res.comics.items.randomElement()?.name ?? "")"
                            let url = URL(string: res.urls[1].url)!
                            let attr = NSMutableAttributedString(string: "More info at Marvel Wiki")
                            attr.setAttributes([.link: url], range: NSMakeRange(0, attr.length))
                            self.currentURL.attributedText = attr
                            self.currentURL.isUserInteractionEnabled = true
                            self.currentURL.isEditable = false
                            
                            if !res.resultDescription.isEmpty {
                                self.currentDescription.text = "Bio: \(res.resultDescription)"
                            } else {
                                self.currentDescription.text = "Bio: No Bio Provided"
                            }
                            self.loadingIndicator.stopAnimating()
                        }
                    }
                }
            }
            
            //MARK:- Comics Setup
        } else if navigationItem.title == MainVC.cellNames[1] {
            networkManager.fetchGenericData(stringURL: "https://gateway.marvel.com:443/v1/public/comics?title=\(searchText)&ts=\(ts)&apikey=\(publicKey)&hash=\(hashVal)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!) { (currentComics: CurrentComics) in
                self.comicsArray = currentComics.data.results
                DispatchQueue.global().async {
                    let urlString = "\(self.comicsArray.first?.thumbnail.path ?? "").\(self.comicsArray.first?.thumbnail.thumbnailExtension ?? "")"
                    guard let url = URL(string: urlString), let imageData = try? Data(contentsOf: url) else { return }
                    DispatchQueue.main.async {
                        self.currentImage.image = UIImage(data: imageData)
                        self.currentName.text = self.comicsArray.first?.title
                        //self.currentAppearances.text = self.comicsArray.first?.
                        guard let url = URL(string: self.comicsArray.first?.events.collectionURI ?? "") else { return }
                        let attr = NSMutableAttributedString(string: "More info at Marvel Wiki")
                        attr.setAttributes([.link: url], range: NSMakeRange(0, attr.length))
                        self.currentURL.attributedText = attr
                        self.currentURL.isUserInteractionEnabled = true
                        self.currentURL.isEditable = false
                        self.currentDescription.text = "Bio: \(self.comicsArray.first?.description ?? "Bio: No Bio Provided")"
                        self.loadingIndicator.stopAnimating()
                    }
                }
            }
        } // Тут аналогичный запрос для 3й структуры
        //else if navigationItem.title == MainVC.cellNames[2] {
//            networkManager.fetchGenericData(stringURL: "https://gateway.marvel.com:443/v1/public/creators?title=\(searchText)&ts=\(ts)&apikey=\(publicKey)&hash=\(hashVal)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!, completion: <#T##(Decodable & Encodable) -> ()#>)
//        }
        if searchBar.text?.isEmpty == true {
            loadingIndicator.stopAnimating()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text? = ""
        refreshElements()
        loadingIndicator.stopAnimating()
        searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
    }
}

extension InfoVC: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        if URL.absoluteString == charArray.first?.comics.items[1].name {
            UIApplication.shared.open(URL)
        }
        return false
    }
}
