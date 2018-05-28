//
//  PerfilViewController.swift
//  wallet_stone
//
//  Created by Luis Felipe Tapajos on 27/05/18.
//  Copyright © 2018 Luis Felipe Tapajos. All rights reserved.
//

import UIKit

class PerfilViewController: UIViewController {

    @IBOutlet weak var saldoLabel: UILabel!
    @IBOutlet weak var nomeLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var dataSourceArray = [Moeda]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let cliente = listDetailCliente("jose@gmail.com")
        saldoLabel.text = "R$ \(cliente.saldo),00"
        nomeLabel.text = cliente.nome
        
        //Carrega Moedas salvas no Realm
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
    
    //Chama a View que lista dados das moedas para salvar compras do cliente
    @IBAction func comprarMoedas(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "EntradaViewController") as! EntradaViewController
        self.navigationController?.pushViewController(controller, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension PerfilViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSourceArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath ) as! ListMoedasTableViewCell
        
        let row = indexPath.row
        let moeda = dataSourceArray[row]
        
        cell.configuraCelulaMoeda(moeda: moeda)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}
