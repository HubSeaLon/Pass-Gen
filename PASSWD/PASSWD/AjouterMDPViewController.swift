//
//  AjouterMDPViewController.swift
//  PASSWD
//
//  Created by Elias Baroudi on 31/03/2025.
//

import UIKit

// Protocol permet de communiquer entre deux vues.
// Ici nous voulons utiliser la fonction RafraichirMdp() après avoir rajouter des données à la BD


// Protocol créé pour pouvoir utiliser la fonction RafraichirBase() dans la ue CoffreViewController
protocol AjouterMDPDelegate: AnyObject {
    func didAjouterMDP()
}



class AjouterMDPViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var application: UITextField!
    @IBOutlet weak var login: UITextField!
    @IBOutlet weak var mdp: UITextField!
    
    // Création Delegate
    weak var delegate: AjouterMDPDelegate?
    
    var annule = false
    var ajout = false
    
    
    @IBOutlet weak var enregistrer: UIButton!
    @IBOutlet weak var message: UILabel!
    
    @IBOutlet var champTexte: [UITextField]!
    
    @IBAction func verifText2(_ sender: UITextField) {
        message.isHidden = true
        if application.text != "" && login.text != "" && mdp.text != "" {
            enregistrer.isEnabled = true
        } else {
            enregistrer.isEnabled = false
        }
    }
    
    
    @IBAction func verifText(_ sender: Any) {
//        if application.text != "" && login.text != "" && mdp.text != "" {
//            enregistrer.isEnabled = true
//        } else {
//            enregistrer.isEnabled = false
//        }
    }
    
    
    // Cacher le clavier quand on tape autre part
    @objc func cacherClavier() {
        view.endEditing(true)
    }
    
    override func viewDidLoad() {
        annule = false
        super.viewDidLoad()

        application.delegate = self
        login.delegate = self
        mdp.delegate = self
        
        // QUand on tape autre part pour cacher le clavier (GPT)
        let tap = UITapGestureRecognizer(target: self, action: #selector(cacherClavier))
        view.addGestureRecognizer(tap)
        
        enregistrer.isEnabled = false
        message.isHidden = true
        
        // enlever l'autocorrection
        for champ in champTexte {
            champ.autocorrectionType = .no
            champ.spellCheckingType = .no
        }
        
    }
    
    
    func AjoutMDP() {
        let texte = "\(application.text ?? ""),\(login.text ?? ""),\(mdp.text ?? "")\n"
        
        // Récupération du chemin vers le dossier Documents
        if let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fileURL = documentsDirectory.appendingPathComponent("passwd.db")
            
            do {
                // Vérifie si le fichier existe déjà
                if FileManager.default.fileExists(atPath: fileURL.path) {
                    let fileHandle = try FileHandle(forWritingTo: fileURL)
                    fileHandle.seekToEndOfFile()
                    if let data = texte.data(using: .utf8) {
                        fileHandle.write(data)
                    }
                    fileHandle.closeFile()
                } else {
                    // Sinon, créer un nouveau fichier
                    try texte.write(to: fileURL, atomically: true, encoding: .utf8)
                }
                print("Données écrites avec succès dans : \(fileURL.path)")
                print("Ajouté au fichier : \(texte)")
                
                // Appel du delegate qui rafraichit l'affichage
                delegate?.didAjouterMDP()
            } catch {
                print("Erreur lors de l'écriture du fichier : \(error)")
            }
        }
    }

    
    @IBAction func fermer(_ sender: UIButton) {
        if sender.tag == 0 {
            if application.text != "" && login.text != "" && mdp.text != "" {
                AjoutMDP()
            } else {
                message.isHidden = false
                return
            }
        }
        
        // Ferme la vue actuelle
        self.dismiss(animated: true, completion: nil)
        
    }
}
