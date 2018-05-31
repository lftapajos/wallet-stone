//
//  Transacao.swift
//  wallet_stone
//
//  Created by Luis Felipe Tapajos on 29/05/18.
//  Copyright © 2018 Luis Felipe Tapajos. All rights reserved.
//

import Foundation
import RealmSwift

func saveTransacation(_ clienteID: String, moedaNome: String, valor: Double, tipo: String, quantidade: Double) {
    
    let realm = try! Realm()
    
    //Filtra moeda pelo nome
    let detailMoeda = realm.objects(Moeda.self).filter("nome = %@", moedaNome)
    
    //Cria dados da Transação de compra
    let transacao = Transacoes()
    transacao.transacaoID = UUID().uuidString
    transacao.clienteID = clienteID
    transacao.moedaID = (detailMoeda.first?.moedaID)!
    transacao.moedaNome = moedaNome
    transacao.tipo = tipo
    transacao.quantidade = quantidade
    transacao.valorTransacao = valor
    transacao.dataHoraTransacao = ""
    
    try! realm.write {
        realm.add(transacao)
        print("Transação \(transacao.transacaoID) adicionado no Realm.")
    }
}

//Lista todas as transacoes de um cliente
func listAllTransactions(_ clienteID: String) -> [Transacoes] {
    
    let realm = try! Realm()
    
    let allTransactions = realm.objects(Transacoes.self).filter("clienteID = %@", clienteID)
    
    let transactions = Array(allTransactions)
    
    return transactions
}

//Lista quantidate das transações por cliente e moeda
func listAllQuantityByClienteCoin(_ clienteID: String, moedaNome: String) -> Double {
    
    let realm = try! Realm()
    
    let allTransacoes = realm.objects(Transacoes.self).filter("clienteID = %@ AND moedaNome = %@", clienteID, moedaNome)
    
    var quantidade = 0.0
    for transacao in allTransacoes {
        
        if (transacao.tipo == "COMPRA") {
            quantidade = (quantidade + transacao.quantidade)
        } else if (transacao.tipo == "VENDA") {
            quantidade = (quantidade - transacao.quantidade)
        }
        
    }
    
    return quantidade
}

//Lista quantidate das transações por cliente e moeda
func listAllValueByClienteCoin(_ clienteID: String, moedaNome: String) -> Double {
    
    let realm = try! Realm()
    
    let allTransacoes = realm.objects(Transacoes.self).filter("clienteID = %@ AND moedaNome = %@", clienteID, moedaNome)
    
    var valor = 0.0
    for transacao in allTransacoes {
        valor = (valor + transacao.valorTransacao)
    }
    
    return valor
}
