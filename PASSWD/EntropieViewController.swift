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

        
        let formulaText = "H = -Σ (pᵢ * log₂(pᵢ))"
        
        // Créer un NSAttributedString pour afficher la formule
        let attributedString = NSAttributedString(string: formulaText, attributes: [
            .font: UIFont.systemFont(ofSize: 20), // Choisir une taille de police
            .foregroundColor: UIColor.black // Couleur du texte
        ])
                
        // Assigner l'attributed string au label
        labelEntropie.attributedText = attributedString
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
