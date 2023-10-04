//
//  MainTabBarController.swift
//  spotify_io_GSK
//
//  Created by coding on 03/10/2023.
//

import UIKit

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBarAppearance()

        // Do any additional setup after loading the view.
    }
    
    func setupTabBarAppearance() {
        let appearance = UITabBarAppearance()

        // Configuration pour l'état non sélectionné
        let normalAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.gray
        ]
        appearance.stackedLayoutAppearance.normal.iconColor = UIColor.gray
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = normalAttributes

        // Configuration pour l'état sélectionné
        let selectedAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor(hex: "#1ed760")
        ]
        appearance.stackedLayoutAppearance.selected.iconColor = UIColor(hex: "#1ed760")
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = selectedAttributes

        // Affecte l'apparence à la barre d'onglets
        tabBar.standardAppearance = appearance
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
