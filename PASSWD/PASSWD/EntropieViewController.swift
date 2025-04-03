//
//  EntropieViewController.swift
//  PASSWD
//
//  Created by Hubert Geoffray on 01/04/2025.
//

import UIKit

class EntropieViewController: UIViewController {
    
    @IBOutlet weak var labelEntropie: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        let formulaText = "E = L * log₂(B)"
        
        // Créer un NSAttributedString pour afficher la formule (GPT)
        let attributedString = NSAttributedString(string: formulaText, attributes: [
            .font: UIFont.systemFont(ofSize: 20),
        ])
                
        // Assigner l'attributed string au label
        labelEntropie.attributedText = attributedString
    }

}
