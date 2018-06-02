//
//  Help.swift
//  wallet_stone
//
//  Created by Luis Felipe Tapajos on 28/05/18.
//  Copyright © 2018 Luis Felipe Tapajos. All rights reserved.
//

import Foundation

let clienteModel = ClienteModel()
let transacaoModel = TransacaoModel()
let estoqueModel = EstoqueModel()
let moedaModel = MoedaModel()

//Formata Moedas
func formatCoin(_ codigo: String, valor: Double) -> String {
    
    let formatter = NumberFormatter()
    let locale = Locale(identifier: codigo)
    formatter.locale = locale
    formatter.numberStyle = .currency
    let valorFormatado = formatter.string(from: valor as NSNumber)
    return valorFormatado!
    
}

func formatCurrency(_ value: Double) -> Double{
    
    let stringValue = String(format: "%.2f", value)
    let outputString = Double(stringValue)
    
    return outputString!
}

//Cálculo de compra da moeda Brita
func calculateBuyBrita(_ quantidade: Double, valorCotacaoCompra: Double, saldoAtual: Double, clienteID: String, moedaAtual: String, completion: @escaping (Double)->(), failureBlock: @escaping ()->Void) {
    
    //Calcula Brita
    let valor_compra = (formatCurrency(quantidade) * formatCurrency(valorCotacaoCompra))
    //print("valor_compra =====> \(valor_compra)")
    
    let saldoFormatado = formatCurrency(Double(saldoAtual))
    //print("saldoFormatado =====> \(saldoFormatado)")
    
    let novo_saldo = (saldoFormatado - valor_compra)
    //print("novo_saldo =====> \(novo_saldo)")
    
    //Verifica se existe saldo suciciente para a compra
    if (novo_saldo > 0) {
        
        //Verifica se o Cliente já possui saldo para a moeda Brita
        if (estoqueModel.getSaldoClienteByCoin(clienteID, moedaNome: MOEDA_BRITA)) {
            
            //Se tiver, atualiza o saldo
            estoqueModel.updateSaldoCliente(clienteID, moedaNome: MOEDA_BRITA, novaQuantidade: quantidade, novoSaldo: valor_compra)
            
        } else {
            
            //Senão cria um novo saldo do Cliente para a moeda Brita
            estoqueModel.addEstoque(clienteID, moedaNome: MOEDA_BRITA, quantidade: quantidade, saldo: valor_compra)
        }
        
        //Atualiza saldo do Cliente
        clienteModel.atualizaSaldoCliente(clienteID, novoSaldo: novo_saldo)
        
        //Grava Transação de compra
        transacaoModel.saveTransaction(clienteID, moedaNome: moedaAtual, valor: valor_compra, tipo: "COMPRA", quantidade: quantidade)
        
        completion(novo_saldo)
        
    }
}

//Cálculo de compra da moeda Bitcoin BTC
func calculateBuyBtc(_ quantidade: Double, valorCotacaoCompra: Double, saldoAtual: Double, clienteID: String, moedaAtual: String, completion: @escaping (Double)->(), failureBlock: @escaping ()->Void) {
    
    //Recupera a Cotação do Dólar
    let cotacaoDolar = moedaModel.loadDollarQuotes(MOEDA_BRITA)
    
    //Recupera a Cotação de BTC
    let cotacaoBtc = moedaModel.loadDollarQuotes(MOEDA_BTC)
    
    let cotacao_formatada = (formatCurrency(cotacaoBtc.cotacaoCompra) * formatCurrency(cotacaoDolar.cotacaoCompra))
    //print("cotacao_formatada =====> \(cotacao_formatada)")
    
    let valor_compra = (formatCurrency(quantidade) * formatCurrency(cotacao_formatada))
    //print("valor_compra =====> \(valor_compra)")
    
    let saldoFormatado = formatCurrency(Double(saldoAtual))
    //print("saldoFormatado =====> \(saldoFormatado)")
    
    let novo_saldo = (saldoFormatado - valor_compra)
    //print("novo_saldo =====> \(novo_saldo)")
    
    //Verifica se existe saldo suciciente para a compra
    if (novo_saldo > 0) {
        
        //Verifica se o Cliente já possui saldo para a moeda BTC
        if (estoqueModel.getSaldoClienteByCoin(clienteID, moedaNome: MOEDA_BTC)) {
            
            //Se tiver, atualiza o saldo
            estoqueModel.updateSaldoCliente(clienteID, moedaNome: MOEDA_BTC, novaQuantidade: quantidade, novoSaldo: valor_compra)
            
        } else {
            
            //Senão cria um novo saldo do Cliente para a moeda BTC
            estoqueModel.addEstoque(clienteID, moedaNome: MOEDA_BTC, quantidade: quantidade, saldo: valor_compra)
        }
        
        //Atualiza saldo do Cliente
        clienteModel.atualizaSaldoCliente(clienteID, novoSaldo: novo_saldo)
        
        //Grava Transação de compra
        transacaoModel.saveTransaction(clienteID, moedaNome: moedaAtual, valor: valor_compra, tipo: "COMPRA", quantidade: quantidade)
        
        completion(novo_saldo)        
    }
}

//Cálculo de venda da moeda Brita
func calculateSellBrita(_ quantidade: Double, valorCotacaoVenda: Double, saldoAtual: Double, clienteID: String, moedaAtual: String, completion: @escaping ([String: Any])->(), failureBlock: @escaping ()->Void) {
    
    var dict = [String: Any]()
    
    let valor_venda = (formatCurrency(quantidade) * formatCurrency(valorCotacaoVenda))
    //print("valor_venda =====> \(valor_venda)")
    
    let saldoFormatado = formatCurrency(Double(saldoAtual))
    //print("saldoFormatado =====> \(saldoFormatado)")
    
    let novo_saldo = (saldoFormatado + valor_venda)
    //print("novo_saldo =====> \(novo_saldo)")
    
    //Verifica a soma de moedas do Cliente
    let verificaQuantidade = estoqueModel.listAllEstoquByClienteCoin(clienteID, moedaNome: moedaAtual)
    //transacaoModel.listAllQuantityByClienteCoin(clienteID, moedaNome: moedaAtual)
    //print("verificaQuantidade =====> \(verificaQuantidade)")
    
    //Verifica se existe saldo suciciente para a compra
    if (verificaQuantidade.quantidade >= quantidade) {
        
        //Verifica se existe saldo suciciente para a compra
        if (novo_saldo > 0) {
            
            //Atualiza saldo do Estoque
            estoqueModel.updateSaldoCliente(clienteID, moedaNome: MOEDA_BRITA, novaQuantidade: -quantidade, novoSaldo: -valor_venda)
            
            //Atualiza saldo do Cliente
            clienteModel.atualizaSaldoCliente(clienteID, novoSaldo: novo_saldo)
            
            //Grava Transação de venda
            transacaoModel.saveTransaction(clienteID, moedaNome: moedaAtual, valor: valor_venda, tipo: "VENDA", quantidade: quantidade)
            
            //Verifica a quantidade de moedas no estoque do Cliente
            let verificaQuantidade = estoqueModel.listAllEstoquByClienteCoin(clienteID, moedaNome: moedaAtual)
            
            //Remove campo de quantidade se o saldo zerar
            if (verificaQuantidade.quantidade <= 0) {
                //removeQuantity()
                dict["remove_campos"] = 1
            } else {
                dict["remove_campos"] = 0
            }
            
            dict["novo_saldo"] = novo_saldo
            dict["erro"] = 0
            
           completion(dict)
            
        } else {
            //print("Operação não pode ser executa por falta de saldo!")
            
            dict["remove_campos"] = 0
            dict["novo_saldo"] = novo_saldo
            dict["erro"] = 1
            
            completion(dict)
        }
    } else {
        //print("Operação não pode ser executa por falta de saldo!")
        
        dict["remove_campos"] = 0
        dict["novo_saldo"] = novo_saldo
        dict["erro"] = 1
        
        completion(dict)
    }
    
}

//Cálculo de venda da moeda Bitcoin BTC
func calculateSellBtc(_ quantidade: Double, valorCotacaoVenda: Double, saldoAtual: Double, clienteID: String, moedaAtual: String, completion: @escaping ([String: Any])->(), failureBlock: @escaping ()->Void) {
    
    var dict = [String: Any]()
    
    //Recupera a Cotação do Dólar
    let cotacaoDolar = moedaModel.loadDollarQuotes(MOEDA_BRITA)
    
    //Recupera a Cotação de BTC
    let cotacaoBtc = moedaModel.loadDollarQuotes(MOEDA_BTC)
    
    //Converte a cotação para Real
    let cotacao_formatada = (formatCurrency(cotacaoBtc.cotacaoVenda) * formatCurrency(cotacaoDolar.cotacaoVenda))
    //print("cotacao_formatada =====> \(cotacao_formatada)")
    
    //Calcula o valor da venda em reais
    let valor_venda = (formatCurrency(quantidade) * formatCurrency(cotacao_formatada))
    //print("valor_venda =====> \(valor_venda)")
    
    //Saldo atual formatado
    let saldoFormatado = formatCurrency(Double(saldoAtual))
    //print("saldoFormatado =====> \(saldoFormatado)")
    
    //Calcula novo saldo em reais
    let novo_saldo = (saldoFormatado + valor_venda)
    //print("novo_saldo =====> \(novo_saldo)")
    
    //Verifica a quantidade de moedas no estoque do Cliente
    let verificaQuantidade = estoqueModel.listAllEstoquByClienteCoin(clienteID, moedaNome: moedaAtual)
    //print("verificaQuantidade =====> \(verificaQuantidade)")
    
    //Verifica se existe saldo suciciente para a compra
    if (verificaQuantidade.quantidade >= quantidade) {
        
        //Verifica se existe saldo suciciente para a compra
        if (novo_saldo > 0) {
            
            //Atualiza saldo do Estoque
            estoqueModel.updateSaldoCliente(clienteID, moedaNome: MOEDA_BTC, novaQuantidade: -quantidade, novoSaldo: -valor_venda)
            
            //Atualiza saldo do Cliente
            clienteModel.atualizaSaldoCliente(clienteID, novoSaldo: novo_saldo)
            
            //Grava Transação de venda
            transacaoModel.saveTransaction(clienteID, moedaNome: moedaAtual, valor: valor_venda, tipo: "VENDA", quantidade: quantidade)
            
            //Verifica a quantidade de moedas no estoque do Cliente
            let verificaQuantidade = estoqueModel.listAllEstoquByClienteCoin(clienteID, moedaNome: moedaAtual)
            
            //Remove campo de quantidade se o saldo zerar
            if (verificaQuantidade.quantidade <= 0) {
                //removeQuantity()
                dict["remove_campos"] = 1
            } else {
                dict["remove_campos"] = 0
            }
            
            dict["novo_saldo"] = novo_saldo
            dict["erro"] = 0
            
            completion(dict)
        } else {
            //print("Operação não pode ser executa por falta de saldo!")
            
            dict["remove_campos"] = 0
            dict["novo_saldo"] = novo_saldo
            dict["erro"] = 1
            
            completion(dict)
        }
    } else {
        //print("Operação não pode ser executa por falta de saldo!")
        
        dict["remove_campos"] = 0
        dict["novo_saldo"] = novo_saldo
        dict["erro"] = 1
        
        completion(dict)
    }
    
}

//Converte Dólar para Real
func convertDollarToReal(_ cotacao: Double, valor: Double) -> Double {
    let calculo = (cotacao * valor)
    return calculo
}

//Converte Real para Dólar
func convertRealToDollar(_ cotacao:Double, valor: Double) -> Double {
    
    let valorCalculo = Double(round(valor * 10000000) / 10000000)
    
    let calculo = (valorCalculo / cotacao)
    return calculo
}

func getDateToday() -> String {
    
    let date = Date()
    let formatter = DateFormatter()
    formatter.dateFormat = "MM-dd-yyyy"
    let resultDate = formatter.string(from: date)
    
    return resultDate
}

func getDateTimeToday() -> String {
    
    let date = Date()
    let formatter = DateFormatter()
    formatter.dateFormat = "dd/MM/yyyy hh:mm:ss"
    let resultDate = formatter.string(from: date)
    
    return resultDate
}
