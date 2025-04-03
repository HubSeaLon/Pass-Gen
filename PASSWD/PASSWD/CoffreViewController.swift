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

// extension pour masquer les mots de passe (GPT)
extension UILabel {
    func maskTextWithDots() {
        guard let originalText = self.text else { return }
        self.text = String(repeating: "•", count: originalText.count)
    }
}

class CoffreViewController: UIViewController, UITableViewDataSource, UITableViewDelegate,UISearchBarDelegate, AjouterMDPDelegate {
    
    // Recherche
    @IBOutlet weak var recherche: UISearchBar!
    
    // Opération sur le TableView
    @IBOutlet weak var supprimer: UIButton!
    @IBOutlet weak var copier: UIButton!
    @IBOutlet weak var annuler: UIButton!
    
    @IBOutlet weak var message: UILabel!
    
    @IBAction func ajouter(_ sender: Any) {
        deselectionnerLigne()
    }
    
    
    // Variables nécessaires à l'ajout de mdp
    var application: String = ""
    var login: String = ""
    var mdp: String = ""
    
    var annule: Bool = false
    
    var nbLignes = 0
    var nbCol = 0
    
    var lines: [String] = []
    
    var ligneSelectionnee: Int?
    
    // Source pour la création de la table UITableView:
    // "www.youtube.com/watch?v=C36sb5sc6lE"
    
    // Fonction qui retourne le nb de lignes dans le tableau
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rechercheActive ? lignesFiltrees.count : lines.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Récupérer la ligne
        ligneSelectionnee = indexPath.row
        
        // Récupérer la cellule
        if let cell = tableView.cellForRow(at: indexPath) as? nCell {
            // Diviser la ligne en fonction de la virgule
            let line = lines[indexPath.row].split(separator: ",")

            // Assurez-vous qu'il y a bien 3 éléments dans la ligne
            if line.count > 2 {
                // Afficher le mot de passe en clair dans label3
                cell.label3.text = String(line[2])
            }
            
            supprimer.isHidden = false
            copier.isHidden = false
            annuler.isHidden = false
        }
    }
    
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        // Récupérer la cellule
        if let cell = tableView.cellForRow(at: indexPath) as? nCell {
            // Diviser la ligne en fonction de la virgule
            let line = lines[indexPath.row].split(separator: ",")

            // S'assurer qu'il y a bien 3 éléments dans la ligne
            if line.count > 2 {
                // Masquer le mot de passe en clair dans label3
                cell.label3.text = "•••••••••••••••"
            }
        }
    }
    
    
    
    // Fonction qui definit l'action de pointer une cellule
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? nCell else {
                return UITableViewCell()
            }

        let source = rechercheActive ? lignesFiltrees : lines
        let line = source[indexPath.row].split(separator: ",")

        if line.count > 0 { cell.label1.text = String(line[0]) }
        if line.count > 1 { cell.label2.text = String(line[1]) }
        if line.count > 2 { cell.label3.text = "•••••••••••••••" }

        return cell
    }
    
    
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet var vue: UIView!
    
    
    @objc func fermerClavier() {
        view.endEditing(true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        // Recherche
        let tap = UITapGestureRecognizer(target: self, action: #selector(fermerClavier))
        tap.cancelsTouchesInView = false // important pour ne pas bloquer les actions sur les cellules
        view.addGestureRecognizer(tap)

        recherche.delegate = self

        // Ouverture du fichier
        vue.isHidden = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
            super.viewDidAppear(animated)
        
        vue.isHidden = true
        supprimer.isHidden = true
        copier.isHidden = true
        annuler.isHidden = true
        
        
        verifierBiometrie()
        
        
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        deselectionnerLigne()
        
        // Masquer la vue quand on la quitte
        vue.isHidden = true
    }

    // Bar de recherche
    
    
    var lignesFiltrees: [String] = []
    var rechercheActive: Bool = false

    // Cacher le clavier après avoir cliqué sur rechercher
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    
    // Recherche dans la bar selon le nom d'app et au changement dans la bar de recherche
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            rechercheActive = false
            lignesFiltrees = []
            deselectionnerLigne()
        } else {
            rechercheActive = true
            deselectionnerLigne()
            
            lignesFiltrees = lines.filter { line in
                // Extraction du nom de l'app avant la première virgule et prise en compte de la casse
                let appName = line.split(separator: ",").first?.lowercased() ?? ""
                // On garde les noms d'app qui correspondent à la recherche
                return appName.contains(searchText.lowercased())
            }
        }
        tableView.reloadData()
    }

    
    func deselectionnerLigne() {
        if let index = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: index, animated: true)

            if let cell = tableView.cellForRow(at: index) as? nCell {
                cell.label3.text = "•••••••••••••••"
            }

            supprimer.isHidden = true
            copier.isHidden = true
            annuler.isHidden = true
            supprimer.isHidden = true
            ligneSelectionnee = nil
        }
    }

    
    
    @IBAction func boutonSupprimer(_ sender: UIButton) {
        guard let index = ligneSelectionnee else {
            print("Aucune ligne sélectionnée.")
            return
        }
        
        // Supprimer la ligne du tableau
        lines.remove(at: index)
        nbLignes = lines.count

        // Réécrire le fichier entier
        if let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fileURL = documentsDirectory.appendingPathComponent("passwd.db")
            let nouveauContenu = lines.joined(separator: "\n") + "\n"
            
            do {
                try nouveauContenu.write(to: fileURL, atomically: true, encoding: .utf8)
                print("Ligne supprimée et fichier mis à jour.")
            } catch {
                print("Erreur lors de la mise à jour du fichier : \(error.localizedDescription)")
            }
        }

        deselectionnerLigne()
        
        // Rafraîchir la table
        tableView.reloadData()
        if lines.isEmpty {
            message.isHidden = false
        } else {
            message.isHidden = true
        }
        print("Nouvelles données : \(lines)")
    }
    
    
    
    // Copier le mot de passe
    @IBAction func boutonCopier(_ sender: UIButton) {
        guard let ligne = ligneSelectionnee else {
            return
        }
        
        let champs = lines[ligne].split(separator: ",")
        if champs.count >= 3 {
           let motDePasse = String(champs[2])
           UIPasteboard.general.string = motDePasse
           afficherToast(message: "Mot de passe copié !")
        }
        deselectionnerLigne()
    }
    
    // Toast repris dans la vue GenerateurViewController
    func afficherToast(message: String, duree: Double = 2.0) {
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 150, y: self.view.frame.size.height - 150, width: 300, height: 30))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center
        toastLabel.font = UIFont.systemFont(ofSize: 14.0)
        toastLabel.text = message
        toastLabel.alpha = 0.0
        toastLabel.layer.cornerRadius = 10
        toastLabel.clipsToBounds = true
        self.view.addSubview(toastLabel)

        UIView.animate(withDuration: 0.5, animations: {
            toastLabel.alpha = 1.0
        }) { _ in
            UIView.animate(withDuration: 0.5, delay: duree, options: .curveEaseOut, animations: {
                toastLabel.alpha = 0.0
            }) { _ in
                toastLabel.removeFromSuperview()
            }
        }
    }
    
    
    
    @IBAction func boutonAnnuler(_ sender: UIButton) {
        deselectionnerLigne()
    }
    
    
    
    // Chargement des données
    func RafraichirBase() {
        if let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fileURL = documentsDirectory.appendingPathComponent("passwd.db") // Chargement du fichier local dans Documents

            // Vérifie si le fichier existe avant d’essayer de lire
            if FileManager.default.fileExists(atPath: fileURL.path) {
                do {
                    let contenu = try String(contentsOf: fileURL, encoding: .utf8)
                    let temp = contenu.split(separator: "\n")
                    
                    // Tri par nom d'app alphabétique
                    lines = temp.map { String($0) }.sorted { ligne1, ligne2 in   // convertion en String et tri les lignes 2 à 2
                        let app1 = ligne1.split(separator: ",").first?.lowercased() ?? "" // Extraction des nom d'app
                        let app2 = ligne2.split(separator: ",").first?.lowercased() ?? ""
                        return app1 < app2 // Compare les deux noms
                    }
                    
                    nbLignes = lines.count
                    tableView.reloadData()
                    print("Contenu actuel : \(lines)")
                    
                    if lines.isEmpty {
                        message.isHidden = false
                    } else {
                        message.isHidden = true
                    }
                } catch {
                    print("Erreur lors de la lecture du fichier: \(error.localizedDescription)")
                }
            } else {
                print("⚠️ Fichier introuvable dans Documents : \(fileURL.path)")
            }
        }
    }

    
    /* Fonction pour vérifier la biométrie (FaceID, TouchID ou code de l'iPhone)
    
    Documentation : https://developer.apple.com/documentation/localauthentication/logging-a-user-into-your-app-with-face-id-or-touch-id
     
    Prérequis :
    - Avoir un apple developer ID
    - Dans le fichier Info.plist : ajouter "Privacy Face ID usage description et donner une description de l'utilisation du Face ID
    - Sur un iPhone activer le mode développeur
     */
    
    func verifierBiometrie() {
        let context = LAContext()
        var error: NSError?


        // Vérifie si l'appareil peut utiliser le Face ID ou Touch ID
        if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) {
            let raison = "Authentifiez-vous pour accéder à votre coffre"

            // Processus d'authentification aynchrone
            context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: raison) { success, authError in
                DispatchQueue.main.async {
                    if success {
                        // Authentificatino réussie
                        self.vue.isHidden = false
                        self.tabBarController?.tabBar.isHidden = false
                        self.RafraichirBase()
                    } else {
                        // Échec ou annulation retour
                        self.vue.isHidden = true
                        self.tabBarController?.tabBar.isHidden = false
                        self.fermerVueOuRetour()
                    }
                }
            }
        } else {
            // Ferme la vue
            fermerVueOuRetour()
        }
    }

    func fermerVueOuRetour() {
        if let tabBar = self.tabBarController {
            tabBar.selectedIndex = 0 // Revenir au 1er onglet
        }
    }
    

    // Delegate appelé quand un mot de passe est ajouté sur la vue AjoutMDPViewController et rafraichir l'affichage
    func didAjouterMDP() {
        RafraichirBase()
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let destination = segue.destination as? AjouterMDPViewController {
            destination.delegate = self  // on devient le delegate
        }
    }

}
