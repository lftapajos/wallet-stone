//
//  EntradaViewController.swift
//  wallet_stone
//
//  Created by Luis Felipe Tapajos on 25/05/18.
//  Copyright © 2018 Luis Felipe Tapajos. All rights reserved.
//

import UIKit

class EntradaViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var saldoLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var dataSourceArray = [Moeda]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let cliente = listDetailCliente("jose@gmail.com")
        
        let saldoFomatado = formatMoeda("pt_BR", valor:  Double(cliente.saldo))
        saldoLabel.text = "\(saldoFomatado)"
        
        //Carrega dados de cotação das Moedas salvas no Realm
        dataSourceArray = listMoedas()

        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.reloadData()
        
    }

    @IBAction func retornar(_ sender: Any) {
        if let navigation = navigationController {
            navigation.popViewController(animated: true)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {   //delegate method
        textField.resignFirstResponder()
        return true
    }
}

extension EntradaViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSourceArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath ) as! ListCriptoTableViewCell
        
        let row = indexPath.row
        let moeda = dataSourceArray[row]
        
        cell.configuraCelulaMoeda(cripto: moeda)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let controller = storyboard.instantiateViewController(withIdentifier: "ChatViewController") as! ChatViewController
//        
//        let contatoAtual = dataSourceArray[indexPath.row]
//        controller.contatoSelecionado = contatoAtual
//        
//        self.navigationController?.pushViewController(controller, animated: true)
//        
//    }
    
}
