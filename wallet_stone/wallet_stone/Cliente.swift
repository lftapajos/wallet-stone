//
//  Cliente.swift
//  wallet_stone
//
//  Created by Luis Felipe Tapajos on 26/05/18.
//  Copyright © 2018 Luis Felipe Tapajos. All rights reserved.
//

import Foundation
import RealmSwift

//Adiciona um novo cliente ao Realm
func addCliente(_ nome: String, email: String, senha: String, saldo: Double) -> Bool {
    
    let user = Cliente()
    var retorno = false
    
    user.clienteID = UUID().uuidString
    user.nome = nome
    user.email = email
    user.senha = senha
    user.saldo = saldo //R$100.000
    
    let realm = try! Realm()
    
    if (verifyEmailExistente(email)) {
        retorno = false
    } else {
        try! realm.write {
            realm.add(user)
            print("Usuário \(user.nome) adicionado no Realm.")
            retorno = true
        }
    }
    return retorno
}

//Remove todos os clientes
func deleteCliente() {
    
    let realm = try! Realm()
    
    let allClientes = realm.objects(Cliente.self)
    
    try! realm.write {
        realm.delete(allClientes)
    }
}

//Lista todos os nomes do clientes registrados
func listAllClientes() {
    
    let realm = try! Realm()
    
    let allClientes = realm.objects(Cliente.self)
    
    for cliente in allClientes {
        print("Nome: \(cliente.nome)")
    }
}

//Lista detalhes do usuário logado
func listDetailCliente(_ email: String) -> Cliente {
    
    let realm = try! Realm()
    let cliente = Cliente()
    
    let detailCliente = realm.objects(Cliente.self)
    
    let predicate = NSPredicate(format: "email = %@", email)
    let filteredCliente = detailCliente.filter(predicate)
    
    for user in filteredCliente {
        
        cliente.clienteID = user.clienteID
        cliente.nome = user.nome
        cliente.email = user.email
        cliente.senha = user.senha
        cliente.saldo = user.saldo
        
    }
    
    return cliente
}

//Verifica se o usuário existe
func verifyLoginCliente(_ email: String, senha: String) -> Bool {
    
    let realm = try! Realm()
    
    let cliente = realm.objects(Cliente.self)
    
    let predicate = NSPredicate(format: "email = %@ AND senha = %@", email, senha)
    let filteredCliente = cliente.filter(predicate)
    
    if (filteredCliente.count > 0) {
        print("Nome: \(String(describing: filteredCliente.first!.nome))")
        print("clienteID: \(String(describing: filteredCliente.first!.clienteID))")
        return true
    } else {
        print("Usuário não encontrado!")
        return false
    }
}

//Verifica se o usuário existe
func verifyEmailExistente(_ email: String) -> Bool {
    
    let realm = try! Realm()
    
    let cliente = realm.objects(Cliente.self)
    
    let predicate = NSPredicate(format: "email = %@", email)
    let filteredCliente = cliente.filter(predicate)
    
    if (filteredCliente.count > 0) {
        return true
    } else {
        return false
    }
}

//Atualiza saldo do cliente
func atualizaSaldoCliente(_ clienteID: String, moedaNome: String, valor: Double, novoSaldo: Double) {
    
    let realm = try! Realm()
    
    let detailCliente = realm.objects(Cliente.self).filter("clienteID = %@", clienteID)
    
    if let cliente = detailCliente.first {
        try! realm.write {
            cliente.saldo = novoSaldo
        }
    }
}



