//
//  TransacoesViewController.swift
//  wallet_stone
//
//  Created by Luis Felipe Tapajos on 29/05/18.
//  Copyright © 2018 Luis Felipe Tapajos. All rights reserved.
//

import UIKit

class TransacoesViewController: UIViewController {

    @IBOutlet weak var saldoLabel: UILabel!
    @IBOutlet weak var nomeLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var clienteID = ""
    var dataSourceArray = [Transacoes]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let email = UserDefaults.standard.string(forKey: "emailCliente")
        
        let cliente = listDetailCliente(email!)
        
        nomeLabel.text = cliente.nome
        
        let saldoFomatado = formatMoeda("pt_BR", valor:  Double(cliente.saldo))
        saldoLabel.text = "\(saldoFomatado)"
        
        //Carrega dados das Transações do Cliente salvas no Realm
        dataSourceArray = listAllTransacoes(clienteID)
        
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
}

extension TransacoesViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSourceArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath ) as! ListTransacoesTableViewCell
        
        let row = indexPath.row
        let transacao = dataSourceArray[row]
        
        cell.configuraCelulaTransacao(transancao: transacao)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
}
