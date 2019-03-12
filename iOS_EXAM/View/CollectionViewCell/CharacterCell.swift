//
//  CharacterCell.swift
//  iOS_EXAM
//
//  Created by 700023 on 20/11/2018.
// 
//

import UIKit

class CharacterCell: UICollectionViewCell {
    
    @IBOutlet weak var characterImage: UIImageView!
    @IBOutlet weak var characterName: UILabel!
    
    func setValueToOutlet(character: Character) {
        self.characterName.text = character.characterName
        if character.didSelect {
            self.characterImage.backgroundColor = UIColor.orange
        } else {
            self.characterImage.backgroundColor = UIColor.black
        }
    }
    
}
