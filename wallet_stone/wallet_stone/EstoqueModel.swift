//
//  EstoqueModel.swift
//  wallet_stone
//
//  Created by Luis Felipe Tapajos on 02/06/18.
//  Copyright © 2018 Luis Felipe Tapajos. All rights reserved.
//

import Foundation
import RealmSwift

class EstoqueModel {
    
    //Adiciona um novo cliente ao Realm
    func addEstoque(_ clienteID: String, moedaNome: String, quantidade: Double, saldo: Double) {
        
        let estoque = Estoque()
        
        estoque.estoqueID = UUID().uuidString
        estoque.clienteID = clienteID
        estoque.moedaNome = moedaNome
        estoque.quantidade = quantidade
        estoque.saldo = saldo
        
        let realm = try! Realm()
        
        try! realm.write {
            realm.add(estoque)
            print("Foi adicionada a quantidade \(estoque.quantidade) e o saldo de \(estoque.saldo) para o cliente \(estoque.clienteID) no Realm.")
        }
    }
    
    //Atualiza saldo do cliente
    func updateSaldoCliente(_ clienteID: String, moedaNome: String, novaQuantidade: Double, novoSaldo: Double) {
        
        let realm = try! Realm()
        
        let detailEstoque = realm.objects(Estoque.self).filter("clienteID = %@ AND moedaNome = %@", clienteID, moedaNome)
        
        if let estoque = detailEstoque.first {
            try! realm.write {
                estoque.quantidade = estoque.quantidade + novaQuantidade
                estoque.saldo = estoque.saldo + novoSaldo
            }
        } else {
            let estoque = Estoque()
            
            estoque.estoqueID = UUID().uuidString
            estoque.clienteID = clienteID
            estoque.moedaNome = moedaNome
            estoque.quantidade = novaQuantidade
            estoque.saldo = novoSaldo
            
            try! realm.write {
                realm.add(estoque)
                print("Novo estoque \(estoque.estoqueID) adicionado no Realm.")
            }
        }
    }
    
    //Atualiza saldo do cliente
    func zeraSaldoClienteByCoin(_ clienteID: String, moedaNome: String) {
        
        let realm = try! Realm()
        
        let detailEstoque = realm.objects(Estoque.self).filter("clienteID = %@ AND moedaNome = %@", clienteID, moedaNome)
        
        if let estoque = detailEstoque.first {
            try! realm.write {
                estoque.quantidade = 0
                estoque.saldo = 0.0
            }
        }
    }
    
    //Verifica se o cliente já possui saldo para a moeda
    func getSaldoClienteByCoin(_ clienteID: String, moedaNome: String) -> Bool {
        
        let realm = try! Realm()
        
        let detailEstoque = realm.objects(Estoque.self).filter("clienteID = %@ AND moedaNome = %@", clienteID, moedaNome)
        
        if (detailEstoque.count > 0) {
            return true
        } else {
            return false
        }
    }
    
    //Lista estoque por cliente e moeda
    func listAllEstoqueByClienteCoin(_ clienteID: String, moedaNome: String) -> Estoque {
        
        let realm = try! Realm()
        let estoque = Estoque()
        
        let detailEstoques = realm.objects(Estoque.self).filter("clienteID = %@ AND moedaNome = %@", clienteID, moedaNome)
        
        if (detailEstoques.count > 0) {
            estoque.estoqueID = (detailEstoques.first?.estoqueID)!
            estoque.clienteID = clienteID
            estoque.moedaNome = moedaNome
            estoque.quantidade = (detailEstoques.first?.quantidade)!
            estoque.saldo = (detailEstoques.first?.saldo)!
        }
        
        return estoque
    }
    
}
