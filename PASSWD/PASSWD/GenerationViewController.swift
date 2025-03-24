//
//  GenerationViewController.swift
//  PASSWD
//
//  Created by Elias Baroudi on 19/03/2025.
//

import UIKit

class GenerationViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    // Données et initialisation des PickerView
    @IBOutlet weak var pickerLongueur: UIPickerView!
    @IBOutlet weak var pickerSeparateur: UIPickerView!
    @IBOutlet weak var pickerEspacement: UIPickerView!
    
    let nombreLongueur = Array(1...128)
    let typeSeparateur = ["-",";","|","!","?","/","*"]

    var longueurSelectionnee: Int = 1
    var nombreEspacement: [Int] = []
    var separateurSelectionnee: String = ""
    var espacementSelectionnee: Int = 0
    
    
    // Switchs
    @IBOutlet weak var switchSeparateur: UISwitch!
    @IBOutlet weak var switchPhonetique: UISwitch!
    
    @IBOutlet weak var sousVue1: UIView!
    
    @IBOutlet weak var sousVue2: UIView!
    
    @IBOutlet weak var barMdpVue: UIView! // Changer la couleur selon la robustesse du mdp
    
    // Complexité du mdp en nombre
    @IBOutlet weak var complexiteMdp: UILabel!
    
    @IBOutlet weak var mdpVue: UIView!
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // UI etat de base
        pickerSeparateur.isHidden = true
        pickerEspacement.isHidden = true
        
        
        
        // PickerView
        // Assigner les pickerView au delegate et dataSource

        pickerLongueur.delegate = self
        pickerLongueur.dataSource = self
        
        pickerSeparateur.delegate = self
        pickerSeparateur.dataSource = self
        
        pickerEspacement.delegate = self
        pickerEspacement.dataSource = self
        
        
        // Switch
        // Etat actuel
        switchSeparateur.isOn = false
        updateUISwitchSeparateur(isSwitchOn: false)
        switchSeparateur.addTarget(self, action: #selector(switchChanged(_:)), for: .valueChanged)
        
        switchPhonetique.isOn = false
        updateUISwitchPhonetique(isSwitchOn: false)
        switchPhonetique.addTarget(self, action: #selector(switchChanged(_:)), for: .valueChanged)
        
        
    }
    
    override func viewDidLayoutSubviews() { // Aryaa SK Coding - YouTube
        sousVue1.layer.cornerRadius = 10
        sousVue1.translatesAutoresizingMaskIntoConstraints = true
        
        sousVue2.layer.cornerRadius = 10
        sousVue2.translatesAutoresizingMaskIntoConstraints = true
    }
    
    
    
    

    // Picker View
    // Nombre de colonnes
    func numberOfComponents(in pickerLongueur: UIPickerView) -> Int {
        return 1 // 1 seule colonne par picker
    }
    
    // Nombre de ligne selon le picker
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == pickerLongueur {
            return nombreLongueur.count
        } else if pickerView == pickerSeparateur {
            return typeSeparateur.count
        } else if pickerView == pickerEspacement {
            print("📌 pickerEspacement a \(nombreEspacement.count) lignes disponibles")
        
            return pickerView == pickerEspacement ? nombreEspacement.count : 0
        }
        return 0
    }
    
    // Affichage des valeurs dans picker
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == pickerLongueur {
            return "\(nombreLongueur[row])"
        } else if pickerView == pickerSeparateur {
            return "\(typeSeparateur[row])"
        } else if pickerView == pickerEspacement {
            print("🔍 Affichage pickerEspacement : \(nombreEspacement[row])")
            return "\(nombreEspacement[row])"
        }
        return nil
    }
    
    // Action quand un élément est sélectionné
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == pickerLongueur {
            longueurSelectionnee = nombreLongueur[row]
            if longueurSelectionnee == 1 {
                updateUISwitchSeparateur(isSwitchOn: false)
                switchSeparateur.isOn = false
                switchSeparateur.isHidden = true
            } else {
                switchSeparateur.isHidden = false
                majEspacement(longueur: longueurSelectionnee)
            }
            
            print("Longueur sélectionnée : \(longueurSelectionnee)")
            
        } else if pickerView == pickerSeparateur {
            separateurSelectionnee = typeSeparateur[row]
            print("Sépérateur choisi : \(separateurSelectionnee)")
            
        } else if pickerView == pickerEspacement {
            espacementSelectionnee = nombreEspacement[row]
            print("Nombre séparateur choisi : \(espacementSelectionnee)")
        }
    }
    
    func majEspacement(longueur: Int) {
        let nouvelEspacement = Array(1..<longueur)

           if nouvelEspacement == nombreEspacement {
               print("⚠️ Pas de changement dans nombreEspacement, pas de reload.")
               return
           }

           nombreEspacement = nouvelEspacement.isEmpty ? [1] : nouvelEspacement
           print("✅ Nouveau espacement : \(nombreEspacement)")

           pickerEspacement.reloadAllComponents()
           pickerEspacement.setNeedsLayout()
    }
    
    
    
    
    // Switch
    
    
    // Fonction appelée quand l'utilisateur change l'état du switch
    
    @objc func switchChanged(_ sender: UISwitch) {
        switch sender {
            case switchSeparateur:
                updateUISwitchSeparateur(isSwitchOn: sender.isOn)
            case switchPhonetique:  // 🔥 Manquait ici
                updateUISwitchPhonetique(isSwitchOn: sender.isOn)
            default:
                break
            }
        
    }
    // MAJ des éléments en fonction du switch
    
    func updateUISwitchSeparateur(isSwitchOn: Bool){
     
        
        pickerEspacement.isHidden = !isSwitchOn
        pickerSeparateur.isHidden = !isSwitchOn
        if isSwitchOn {
            pickerEspacement.reloadAllComponents()
        }
        
    }
    
    func updateUISwitchPhonetique(isSwitchOn: Bool) {
        sousVue1.alpha = isSwitchOn ? 0.5 : 1.0 // Change l'opacité pour montrer la désactivation
        sousVue2.alpha = isSwitchOn ? 0.5 : 1.0
        sousVue1.isUserInteractionEnabled = !isSwitchOn // Désactive l'interaction si activé
        sousVue2.isUserInteractionEnabled = !isSwitchOn
    }

    
}
