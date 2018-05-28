//
//  Moeda.swift
//  wallet_stone
//
//  Created by Luis Felipe Tapajos on 27/05/18.
//  Copyright © 2018 Luis Felipe Tapajos. All rights reserved.
//

import Foundation
import RealmSwift

//Adiciona uma nova moedas ao Realm
func addMoeda(_ nome: String, cotacaoCompra: Double, cotacaoVenda: Double, dataHoraCotacao: String) {
    
    let moeda = Moeda()
    
    moeda.moedaID = UUID().uuidString
    moeda.nome = nome
    moeda.cotacaoCompra = cotacaoCompra
    moeda.cotacaoVenda = cotacaoVenda
    moeda.dataHoraCotacao = dataHoraCotacao
    
    let realm = try! Realm()
    
    try! realm.write {
        realm.add(moeda)
        print("Moeda \(moeda.nome) adicionada no Realm.")
    }
}

//Remove todas as moedas
func deleteMoeda() {
    
    let realm = try! Realm()
    
    let allMoedas = realm.objects(Moeda.self)
    
    try! realm.write {
        realm.delete(allMoedas)
    }
}

//Lista todas as moedas registradas
func listMoedas() -> [Moeda] {
    
    let realm = try! Realm()
    
    let allMoedas = realm.objects(Moeda.self)
    
    let moedas = Array(allMoedas)
    
    return moedas
}
