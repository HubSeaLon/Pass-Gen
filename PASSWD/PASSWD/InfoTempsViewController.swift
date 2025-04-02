//
//  InfoTempsViewController.swift
//  PASSWD
//
//  Created by Hubert Geoffray on 02/04/2025.
//

import UIKit


class cellTemps: UITableViewCell {
    @IBOutlet weak var labelEntropie: UILabel!
    @IBOutlet weak var labelTemps: UILabel!
}

class InfoTempsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    let tableTemps: [(String, String)] = [
        ("20", "Instantané"),
        ("40", "18 minutes"),
        ("44", "5 heures"),
        ("48", "3,3 jours"),
        ("52", "1,7 mois"),
        ("56", "2,3 ans"),
        ("60", "37 ans"),
        ("64", "584 ans"),
        ("68", "9,4 milliénaires"),
        ("72", "150 millénaires"),
        ("76", "2,4M années"),
        ("80", "38M années"),
        ("84", "613M années"),
        ("88", "9,8MM années"),
        ("92", "157MM années"),
        ("96", "2,5T années"),
        ("100", "40T années"),
        ("110", "41 Quadrillons années"),
        ("120", "∞")
    ]
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableTemps.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? cellTemps else {
            return UITableViewCell()
        }

        let ligne = tableTemps[indexPath.row]
        cell.labelEntropie.text = ligne.0
        cell.labelTemps.text = ligne.1

        return cell
    }

    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    

    
    
    
    

}
