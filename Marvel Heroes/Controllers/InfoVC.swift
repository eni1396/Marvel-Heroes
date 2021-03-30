//
//  InfoVC.swift
//  Marvel Heroes
//
//  Created by Nikita Entin on 04.03.2021.
//

import UIKit
import SafariServices

class InfoVC: UIViewController {
    
    private let networkManager = NetworkManager()
    private var charactersResult = [Result]()
    private var comicsResult = [ResultComics]()
    private var creatorsResult = [ResultCreator]()
    
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var searchField: UISearchBar!
    @IBOutlet weak var currentImage: UIImageView!
    @IBOutlet weak var currentName: UILabel!
    @IBOutlet weak var currentDescription: UILabel!
    @IBOutlet weak var currentAppearances: UILabel!
    @IBOutlet weak var currentURL: UITextView!
    @IBOutlet weak var shortInfoLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        tapToHideKeyBoard()
    }
    
    private func setupUI() {
        currentDescription.lineBreakMode = .byTruncatingTail
        currentAppearances.lineBreakMode = .byTruncatingTail
        currentDescription.numberOfLines = 0
        currentAppearances.numberOfLines = 0
        searchField.placeholder = "Search for \(title?.lowercased() ?? "")"
        loadingIndicator.hidesWhenStopped = true
        shortInfoLabel.isHidden = true
        currentURL.font = UIFont.preferredFont(forTextStyle: .subheadline)
        currentURL.tintColor = .systemPurple
        currentURL.delegate = self
        searchField.delegate = self
    }
    
    private func refreshElements() {
        currentImage.image = nil
        currentName.text = nil
        currentDescription.text = nil
        currentAppearances.text = nil
        currentURL.text = nil
    }
    
    
    private func tapToHideKeyBoard() {
        let tap = UITapGestureRecognizer(target: view, action: #selector(view.endEditing))
        view.addGestureRecognizer(tap)
    }
}

extension InfoVC: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchField.text = searchBar.text
        loadingIndicator.startAnimating()
        if navigationItem.title == cellNames[0] {
            networkManager.fetchGenericData(from: .characters, searchText: searchText) { (currentHero: CurrentHero) in
                self.charactersResult = currentHero.data.results
                DispatchQueue.global().async {
                    for res in self.charactersResult {
                        let stringURL = "\(res.thumbnail.path).\(res.thumbnail.thumbnailExtension)"
                        guard let url = URL(string: stringURL), let imageData = try? Data(contentsOf: url) else { return }
                        DispatchQueue.main.async {
                            self.currentImage.image = UIImage(data: imageData)
                            self.currentName.text = res.name
                            self.currentAppearances.text = "Appeared in: \(res.comics.items.randomElement()?.name ?? "")"
                            let attrStringURL = res.urls[1].url
                            guard let url1 = URL(string: attrStringURL) else { return }
                            let attr = NSMutableAttributedString(string: moreInfoAtWiki)
                            attr.setAttributes([.link: url1], range: NSMakeRange(0, attr.length))
                            self.currentURL.attributedText = attr
                            self.currentURL.isUserInteractionEnabled = true
                            self.currentURL.isEditable = false
                            self.shortInfoLabel.isHidden = false
                            
                            if !res.resultDescription.isEmpty {
                                self.currentDescription.text = "Bio: \(res.resultDescription)"
                            } else {
                                self.currentDescription.text = "Bio: Not available"
                            }
                            self.loadingIndicator.stopAnimating()
                        }
                    }
                }
            }
        } else if navigationItem.title == cellNames[1] {
            networkManager.fetchGenericData(from: .comics, searchText: searchText) { (currentComics: CurrentComics) in
                self.comicsResult = currentComics.data.results
                DispatchQueue.global().async {
                    let urlString = "\(self.comicsResult.first?.thumbnail.path ?? "").\(self.comicsResult.first?.thumbnail.thumbnailExtension ?? "")"
                    guard let url = URL(string: urlString), let imageData = try? Data(contentsOf: url) else { return }
                    DispatchQueue.main.async {
                        self.currentImage.image = UIImage(data: imageData)
                        self.currentName.text = self.comicsResult.first?.title
                        guard let url2 = self.comicsResult.first?.urls.first?.url else { return }
                        let attributed = NSMutableAttributedString(string: moreInfoAtWiki)
                        attributed.setAttributes([.link: url2], range: NSMakeRange(0, attributed.length))
                        self.currentURL.attributedText = attributed
                        self.currentURL.isUserInteractionEnabled = true
                        self.currentURL.isEditable = false
                        self.currentDescription.text = "Bio: \(self.comicsResult.first?.description ?? "Bio: No description provided")"
                        self.shortInfoLabel.isHidden = false
                        self.loadingIndicator.stopAnimating()
                    }
                }
            }
        } else if navigationItem.title == cellNames[2] {
            networkManager.fetchGenericData(from: .creators, searchText: searchText) { (currentCreator: CurrentCreator) in
                self.creatorsResult = currentCreator.data.results
                DispatchQueue.global().async {
                    let urlString = "\(self.creatorsResult.first?.thumbnail.path ?? "").\(self.creatorsResult.first?.thumbnail.thumbnailExtension ?? "")"
                    guard let url = URL(string: urlString), let imageData = try? Data(contentsOf: url) else { return }
                    DispatchQueue.main.async {
                        self.currentImage.image = UIImage(data: imageData)
                        self.currentName.text = self.creatorsResult.first?.fullName
                        self.shortInfoLabel.isHidden = false
                        self.loadingIndicator.stopAnimating()
                    }
                }
            }
        }
        
        if searchBar.text?.isEmpty == true {
            refreshElements()
            shortInfoLabel.isHidden = true
            loadingIndicator.stopAnimating()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text? = String()
        refreshElements()
        shortInfoLabel.isHidden = true
        loadingIndicator.stopAnimating()
        searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
    }
}

extension InfoVC: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        let vc = SFSafariViewController(url: URL)
        present(vc, animated: true)
        return false
    }
}

