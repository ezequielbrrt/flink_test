//
//  CharactersViewModel.swift
//  flink
//
//  Created by beTech CAPITAL on 06/03/20.
//  Copyright © 2020 Ezequiel Barreto. All rights reserved.
//

import Foundation

class CharacterListViewModel{
    var charactersViewModel: [CharacterViewModel]
    var filteredCharactersVM: [CharacterViewModel]
    var auxCharacters:  [CharacterViewModel]
    
    init() {
        self.charactersViewModel = [CharacterViewModel]()
        self.filteredCharactersVM = [CharacterViewModel]()
        self.auxCharacters = [CharacterViewModel]()
    }
    
    
    
}

extension CharacterListViewModel{
    
    func restoreCharacters(){
        self.charactersViewModel = [CharacterViewModel]()
    }
    
    func characterViewModel(at index: Int)-> CharacterViewModel{
        return self.charactersViewModel[index]
    }
    
    func getNilObject() -> CharacterViewModel{
        return CharacterViewModel(character: ResultCharacter(id: nil, name: nil, status: nil, species: nil, type: nil, gender: nil, origin: nil, location: nil, image: nil, episode: nil, url: nil, created: nil))
    }

}

struct CharacterViewModel {
    let character: ResultCharacter
}
