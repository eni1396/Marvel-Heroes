//
//  InfoVC.swift
//  Marvel Heroes
//
//  Created by Nikita Entin on 04.03.2021.
//

import UIKit

class InfoVC: UIViewController {
    
    private var requestModel = NetworkRequestModel()
    
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var searchField: UISearchBar!
    @IBOutlet weak var currentImage: UIImageView!
    @IBOutlet weak var currentName: UILabel!
    @IBOutlet weak var currentDescription: UILabel!
    @IBOutlet weak var currentAppearances: UILabel!
    @IBOutlet weak var currentURL: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        currentDescription.lineBreakMode = .byTruncatingTail
        currentAppearances.lineBreakMode = .byTruncatingTail
        currentDescription.numberOfLines = 9
        currentAppearances.numberOfLines = 4
        searchField.placeholder = "Search for \(title?.lowercased() ?? "")"
        loadingIndicator.hidesWhenStopped = true
    }
    private func refreshElements() {
        currentImage.image = nil
        currentName.text = nil
        currentDescription.text = nil
        currentAppearances.text = nil
        currentURL.text = nil
    }
    
    private func equalParameters() {
        requestModel.imageView = currentImage
        requestModel.textName = currentName
        requestModel.textAppear = currentAppearances
        requestModel.textDescr = currentDescription
        requestModel.urlView = currentURL
    }
}

extension InfoVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchField.text = searchBar.text
        equalParameters()
        self.loadingIndicator.startAnimating()
        //MARK:- Characters Setup
        if navigationItem.title == cellNames[0] {
            requestModel.fetchCharacters(searchText: searchText)
            self.loadingIndicator.stopAnimating()
            //MARK:- Comics Setup
        } else if navigationItem.title == cellNames[1] {
            requestModel.fetchComics(searchText: searchText)
            self.loadingIndicator.stopAnimating()
        }
        
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
    
    func tapToHideKeyBoard() {
        let tap = UITapGestureRecognizer(target: view, action: #selector(view.endEditing))
        view.addGestureRecognizer(tap)
    }
}

extension InfoVC: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        if URL.absoluteString == requestModel.characters.first?.comics.items[1].name || URL.absoluteString == requestModel.comics.first?.events.collectionURI {
            UIApplication.shared.open(URL)
        }
        return false
    }
}

// TODO:
// как не делать запрос по одной букве
