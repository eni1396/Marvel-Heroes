//
//  InfoVC.swift
//  Marvel Heroes
//
//  Created by Nikita Entin on 04.03.2021.
//

import UIKit
import SafariServices

class InfoVC: UIViewController {
    ///модель для VC
    private var requiredInfo = RequiredInfo()
    
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
        requiredInfo = RequiredInfo()
    }
    
    
    private func tapToHideKeyBoard() {
        let tap = UITapGestureRecognizer(target: view, action: #selector(view.endEditing))
        view.addGestureRecognizer(tap)
    }
}

extension InfoVC: UISearchBarDelegate {
    ///взаимодействие с поисковой строкой
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.requiredInfo.searchText = searchText
        loadingIndicator.startAnimating()
        
        if navigationItem.title == cellNames[0] {
            DispatchQueue.global().async {
                self.requiredInfo.getCharacters {
                    let safeData = self.requiredInfo.requiredImageData
                    DispatchQueue.main.async {
                        self.currentImage.image = UIImage(data: safeData ?? Data())
                        self.currentName.text = self.requiredInfo.requiredName
                        self.currentDescription.text = self.requiredInfo.requiredDescription
                        self.currentAppearances.text = self.requiredInfo.requiredAppearances
                        self.currentURL.attributedText = self.requiredInfo.requiredAttibutedString
                        self.currentURL.isUserInteractionEnabled = true
                        self.currentURL.isEditable = false
                        if self.currentImage.image != nil {
                            self.shortInfoLabel.isHidden = false
                        }
                        self.loadingIndicator.stopAnimating()
                    }
                }
            }
            
        } else if navigationItem.title == cellNames[1] {
            DispatchQueue.global().async {
                self.requiredInfo.getComics {
                    let safeData = self.requiredInfo.requiredImageData
                    DispatchQueue.main.async {
                        self.currentImage.image = UIImage(data: safeData ?? Data())
                        self.currentName.text = self.requiredInfo.requiredName
                        self.currentDescription.text = self.requiredInfo.requiredDescription
                        self.currentURL.attributedText = self.requiredInfo.requiredAttibutedString
                        self.currentURL.isUserInteractionEnabled = true
                        self.currentURL.isEditable = false
                        if self.currentImage.image != nil {
                            self.shortInfoLabel.isHidden = false
                        }
                        self.loadingIndicator.stopAnimating()
                    }
                }
            }
            
        } else if navigationItem.title == cellNames[2] {
            DispatchQueue.global().async {
                self.requiredInfo.getCreators {
                    let safeData = self.requiredInfo.requiredImageData
                    DispatchQueue.main.async {
                        self.currentImage.image = UIImage(data: safeData ?? Data())
                        self.currentName.text = self.requiredInfo.requiredName
                        if self.currentImage.image != nil {
                            self.shortInfoLabel.isHidden = false
                        }
                        self.loadingIndicator.stopAnimating()
                    }
                }
            }
        }
        /// очищение интерфейса при полном удалении текста
        if searchBar.text == "" {
            refreshElements()
            shortInfoLabel.isHidden = true
            loadingIndicator.stopAnimating()
        }
    }
    /// очищение интерфейса при нажатии кнопки Cancel
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text? = ""
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
    ///осуществление перехода по гиперссылке
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        let vc = SFSafariViewController(url: URL)
        present(vc, animated: true)
        return false
    }
}

