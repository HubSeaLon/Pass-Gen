//
//  CoffreViewController.swift
//  PASSWD
//
//  Created by Hubert Geoffray on 30/03/2025.
//

import UIKit
import LocalAuthentication  // Pour utiliser Face ID ou empreinte


// Avoir plusieurs cellules sur un meme ligne
// SOurce : stackoverflow.com/questions/59001569/make-tableview-with-multiple-columns

class nCell: UITableViewCell {

    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var label3: UILabel!
    
}

extension UILabel {
    func maskTextWithDots() {
        guard let originalText = self.text else { return }
        self.text = String(repeating: "•", count: originalText.count)
    }
}

class CoffreViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    // Variables nécessaires à l'ajout de mdp
    var application: String = ""
    var login: String = ""
    var mdp: String = ""
    
    var annule: Bool = false
    
    var nbLignes = 0
    var nbCol = 0
    
    var lines: [String] = []
    
    // Source pour la création de la table UITableView:
    // "www.youtube.com/watch?v=C36sb5sc6lE"
    
    // Fonction qui retourne le nb de lignes dans le tableau
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nbLignes
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Récupérer la cellule
        if let cell = tableView.cellForRow(at: indexPath) as? nCell {
            // Diviser la ligne en fonction de la virgule
            let line = lines[indexPath.row].split(separator: ",") // Exemple de séparation par ","

            // Assurez-vous qu'il y a bien 3 éléments dans la ligne
            if line.count > 2 {
                // Afficher le mot de passe en clair dans label3
                cell.label3.text = String(line[2]) // Affiche le mot de passe en clair
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        // Récupérer la cellule
        if let cell = tableView.cellForRow(at: indexPath) as? nCell {
            // Diviser la ligne en fonction de la virgule
            let line = lines[indexPath.row].split(separator: ",") // Exemple de séparation par ","

            // Assurez-vous qu'il y a bien 3 éléments dans la ligne
            if line.count > 2 {
                // Afficher le mot de passe en clair dans label3
                cell.label3.text = "•••••••••••••••"
            }
        }
    }
    
    
    
    // Fonction qui definit l'action de pointer une cellule
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        print("test")
        // Permet d'acceder au type personalisé (GPT)
        if let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? nCell {

                    // On divise chaque ligne en fonction du séparateur (ex. ",")
                    let line = lines[indexPath.row].split(separator: ",") // Exemple de séparation par ","

                    // Assurez-vous qu'il y a assez de valeurs dans la ligne
                    if line.count > 0 {
                        cell.label1.text = String(line[0]) // Premier élément de la ligne
                    }
                    if line.count > 1 {
                        cell.label2.text = String(line[1]) // Deuxième élément de la ligne
                    }
                    if line.count > 2 {
                        cell.label3.text = "•••••••••••••••"
                    }

                    return cell
                }
        
        return cell
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet var vue: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        // Ouverture du fichier
        RafraichirBase()
        
        // Do any additional setup after loading the view.
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
            super.viewDidAppear(animated)
                
            verifierBiometrie()
        }
    
    
    func AjoutMDP() {
        
        // Lecture du fichier
        if let fileURL = Bundle.main.url(forResource: "passwd", withExtension: "db") {
            do {
                
                // Generation de la ligne à inserer
                let text = "\(application),\(login),\(mdp)" //just a text
                try text.write(to: fileURL, atomically: false, encoding: .utf8)
                tableView.reloadData()
                
            } catch {
                // Gérer les erreurs de lecture du fichier
                print("Erreur lors de la lecture du fichier: \(error.localizedDescription)")
            }
        } else {
            print("Le fichier n'a pas été trouvé dans le bundle.")
        }
        
    }
    
    func RafraichirBase(){
        if let fileURL = Bundle.main.url(forResource: "passwd", withExtension: "db") {
            do {
                // Lire le contenu du fichier avec l'encodage isoLatin1
                let contenu = try String(contentsOf: fileURL, encoding: .isoLatin1)
                
                // Diviser le contenu en lignes et itérer sur chaque ligne
                let temp = contenu.split(separator: "\n") // On charge le contenu dans une valeur temp
                lines = temp.map { String($0) } // On tranforme temp en un tableau de String
                nbLignes = lines.count
                tableView.reloadData()
                
            } catch {
                // Gérer les erreurs de lecture du fichier
                print("Erreur lors de la lecture du fichier: \(error.localizedDescription)")
            }
        } else {
            print("Le fichier n'a pas été trouvé dans le bundle.")
        }
    }
    
    
    func verifierBiometrie() {
        let context = LAContext()
        var error: NSError?

        // ✅ Autorise Face ID, Touch ID ou code de l'appareil
        if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) {
            let raison = "Authentifiez-vous pour accéder à cette section."

            context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: raison) { success, authError in
                DispatchQueue.main.async {
                    if success {
                        // Authentification réussie 🎉
                        self.vue.isHidden = false
                    } else {
                        // ❌ Échec ou annulation → retour
                        self.fermerVueOuRetour()
                    }
                }
            }
        } else {
            // Pas de Face ID / Touch ID / code activé
            fermerVueOuRetour()
        }
    }

    func fermerVueOuRetour() {
        // Option 1 : revenir à un autre onglet
        if let tabBar = self.tabBarController {
            tabBar.selectedIndex = 0 // Revenir au 1er onglet
        }

        // Option 2 : ou masquer le contenu / afficher un écran bloqué
        // self.view.isHidden = true
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
