//
//  Alert.swift
//  wallet_stone
//
//  Created by Luis Felipe Tapajos on 31/05/18.
//  Copyright © 2018 Luis Felipe Tapajos. All rights reserved.
//

import UIKit

class Alert: NSObject {
    
    // MARK: Declarations
    let controller: UIViewController
    
    // MARK: Constructor
    init(controller: UIViewController) {
        self.controller = controller
    }
    
    // MARK: Methods
    //Alerta de Erro
    func show(_ title: String = "Desculpe", message: String = "Ocorreu um erro!") {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
        alert.addAction(ok)
        controller.present(alert, animated: true, completion: nil)
    }
    
    func showError(_ title: String = "ATENÇÃO", message: String = "Error", handler: @escaping (UIAlertAction) -> Void) {
        let details = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        let cancel = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: handler)
        details.addAction(cancel)
        controller.present(details, animated: true, completion: nil)
    }
}