//
//  ContentCharacterViewModel.swift
//  portfolio
//
//

import Foundation
import SwiftUI

struct ContentCharacterViewModel {

    private let character: Characters?

    var characterName: String? {
        return character?.name
    }

    var characterImage: URL? {
        return character?.thumbnail?.imageURL
    }

    init(character: Characters?) {
        self.character = character
    }

}
