//
//  constants.swift
//  Marvel Heroes
//
//  Created by Nikita Entin on 04.03.2021.
//

import Foundation
import CryptoKit

func md5(string: String) -> String {
    let digest = Insecure.MD5.hash(data: string.data(using: .utf8) ?? Data())
    return digest.map {
        String(format: "%02hhx", $0)
    }.joined()
}
let publicKey = "fbbd3b6902d02262ea1f308b98bf953e"
let privateKey = "f88e68bda662ef9f70e7fde623e84b4249094a0f"
let mainCell = "cell"
let ts = String(Date().toMillis())
let hashVal = md5(string: ts + privateKey + publicKey)
let segueID = "to InfoVC"
let cellNames = ["Characters", "Comics", "Creators"]
let moreInfoAtWiki = "More info at Marvel Wiki"
