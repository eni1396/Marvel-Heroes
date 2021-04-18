//
//  CurrentModel.swift
//  Marvel Heroes
//
//  Created by Nikita Entin on 02.04.2021.
//

import Foundation

///Модель для InfoVC
class RequiredInfo {
    
    private let networkManager = NetworkManager()
    var heroes = [Result]()
    var comics = [ResultComics]()
    var creators = [ResultCreator]()
    var searchText: String?
    var requiredURL: String?
    var requiredImageData: Data?
    var requiredAttributedURL: String?
    var requiredName: String?
    var requiredDescription: String?
    var requiredAppearances: String?
    var requiredAttibutedString: NSMutableAttributedString?
    
    ///Получение данных для персонажей
    func getCharacters(completion: @escaping () -> Void) {
        networkManager.fetchGenericData(from: .characters, searchText: searchText ?? "") { (currentHero: CurrentHero) in
            self.heroes = currentHero.data.results
            for res in self.heroes {
                self.requiredURL = "\(res.thumbnail.path).\(res.thumbnail.thumbnailExtension)"
                guard let url = URL(string: self.requiredURL ?? ""), let imageData = try? Data(contentsOf: url) else { return }
                self.requiredImageData = imageData
                self.requiredAttributedURL = res.urls[1].url
                self.requiredName = res.name
                self.requiredAppearances = "Appeared in: \(res.comics.items.first?.name ?? "")"
                guard let url1 = URL(string: self.requiredAttributedURL ?? "") else { return }
                self.requiredAttibutedString = NSMutableAttributedString(string: moreInfoAtWiki)
                self.requiredAttibutedString?.setAttributes([.link: url1], range: NSMakeRange(0, self.requiredAttibutedString?.length ?? 0))
                
                if !res.resultDescription.isEmpty {
                    self.requiredDescription = "Bio: \(res.resultDescription)"
                } else {
                    self.requiredDescription = "Bio: Not available"
                }
            }
            completion()
        }
    }
    ///Получение данных для комиксов
    func getComics(completion: @escaping () -> Void) {
        
        networkManager.fetchGenericData(from: .comics, searchText: searchText ?? "") { (currentComics: CurrentComics) in
            self.comics = currentComics.data.results
            let firstResult = self.comics.first
            self.requiredURL = "\(firstResult?.thumbnail.path ?? "").\(firstResult?.thumbnail.thumbnailExtension ?? "")"
            guard let url = URL(string: self.requiredURL ?? ""), let imageData = try? Data(contentsOf: url) else { return }
            self.requiredImageData = imageData
            self.requiredAttributedURL = firstResult?.urls.first?.url
            self.requiredName = firstResult?.title
            guard let url1 = URL(string: self.requiredAttributedURL ?? "") else { return }
            self.requiredAttibutedString = NSMutableAttributedString(string: moreInfoAtWiki)
            self.requiredAttibutedString?.setAttributes([.link: url1], range: NSMakeRange(0, self.requiredAttibutedString?.length ?? 0))
            self.requiredDescription = "Description: \(firstResult?.description ?? "Not available")"
            
            completion()
        }
    }
    ///Получение данных для создателей комиксов
    func getCreators(completion: @escaping () -> Void) {
        
        networkManager.fetchGenericData(from: .creators, searchText: searchText ?? "") { (currentCreator: CurrentCreator) in
            self.creators = currentCreator.data.results
            self.requiredURL = "\(self.creators.first?.thumbnail.path ?? "").\(self.creators.first?.thumbnail.thumbnailExtension ?? "")"
            guard let url = URL(string: self.requiredURL ?? ""), let imageData = try? Data(contentsOf: url) else { return }
            self.requiredImageData = imageData
            self.requiredName = self.creators.first?.fullName
            
            completion()
        }
    }
}
