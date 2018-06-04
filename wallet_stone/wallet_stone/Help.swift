//
//  Help.swift
//  wallet_stone
//
//  Created by Luis Felipe Tapajos on 28/05/18.
//  Copyright © 2018 Luis Felipe Tapajos. All rights reserved.
//

import Foundation

class Help {
    
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
    
    func updateQuantity(_ clienteID: String, moedaNome: String, quantidade: Double) {
        
    }
    
    //Cálculo de compra da moeda Brita
    func calculateBuyBrita(_ quantidade: Double, valorCotacaoCompra: Double, saldoAtual: Double, clienteID: String, moedaAtual: String, completion: @escaping (Double)->(), failureBlock: @escaping ()->Void) {
        
        //Calcula Brita
        
        //Recupera a Cotação do Dolar
        let cotacaoCompra = Double(valorCotacaoCompra).rounded(toPlaces: 2)
        
        //let valor_compra = (formatCurrency(quantidade) * formatCurrency(valorCotacaoCompra))
        //print("valor_compra =====> \(valor_compra)")
        
        let quantidadeDouble = Double(quantidade).rounded(toPlaces: 2)
        
        let saldoFormatado = Double(saldoAtual).rounded(toPlaces: 2)
        
        //let saldoFormatado = formatCurrency(Double(saldoAtual))
        //print("saldoFormatado =====> \(saldoFormatado)")
        
        let valor_compra = (quantidadeDouble * cotacaoCompra)
        
        let novo_saldo = (saldoFormatado - valor_compra)
        //print("novo_saldo =====> \(novo_saldo)")
        
        //Verifica se existe saldo suciciente para a compra
        if (novo_saldo > 0) {
            
            //Verifica se o Cliente já possui saldo para a moeda Brita
            if (estoqueModel.getSaldoClienteByCoin(clienteID, moedaNome: MOEDA_BRITA)) {
                
                //Se tiver, atualiza o saldo
                estoqueModel.updateSaldoCliente(clienteID, moedaNome: MOEDA_BRITA, novaQuantidade: quantidadeDouble, novoSaldo: valor_compra)
                
            } else {
                
                //Senão cria um novo saldo do Cliente para a moeda Brita
                estoqueModel.addEstoque(clienteID, moedaNome: MOEDA_BRITA, quantidade: quantidadeDouble, saldo: valor_compra)
            }
            
            //Atualiza saldo do Cliente
            clienteModel.atualizaSaldoCliente(clienteID, novoSaldo: novo_saldo)
            
            //Grava Transação de compra
            transacaoModel.saveTransaction(clienteID, moedaNome: moedaAtual, valor: valor_compra, tipo: "COMPRA", quantidade: quantidadeDouble)
            
            completion(novo_saldo)
            
        } else {
            print("Saldo insuficiente!")
            completion(-1)
        }
    }
    
    //Cálculo de compra da moeda Bitcoin BTC
    func calculateBuyBtc(_ quantidade: Double, valorCotacaoCompra: Double, saldoAtual: Double, clienteID: String, moedaAtual: String, completion: @escaping (Double)->(), failureBlock: @escaping ()->Void) {
        
        //Recupera a Cotação do Dolar
        let cotacaoCompraDolar = Double(moedaModel.loadDollarQuotes(MOEDA_BRITA).cotacaoCompra).rounded(toPlaces: 2)
        
        //Recupera a Cotação de BTC
        let cotacaoBtc = moedaModel.loadDollarQuotes(MOEDA_BTC)
        
        let cotacao_formatada = Double(cotacaoBtc.cotacaoCompra).rounded(toPlaces: 2)
        //let cotacaoDolarDouble = Double(cotacaoDolar.cotacaoCompra).rounded(toPlaces: 2)
        //let cotacao_formatada = (cotacaoCompraDouble * cotacaoDolarDouble)
        //print("cotacao_formatada =====> \(cotacao_formatada)")
        
        let quantidadeDouble = Double(quantidade).rounded(toPlaces: 7)
        let valor_compra = (quantidadeDouble * cotacao_formatada)
        //print("valor_compra =====> \(valor_compra)")
        
        let valorCompraReal = (valor_compra * cotacaoCompraDolar)
        
        let saldoFormatado = Double(saldoAtual).rounded(toPlaces: 2)
        //print("saldoFormatado =====> \(saldoFormatado)")
        
        let novo_saldo = (saldoFormatado - valorCompraReal)
        //print("novo_saldo =====> \(novo_saldo)")
        
        //Verifica se existe saldo suciciente para a compra
        if (novo_saldo > 0) {
            
            //Verifica se o Cliente já possui saldo para a moeda BTC
            if (estoqueModel.getSaldoClienteByCoin(clienteID, moedaNome: MOEDA_BTC)) {
                
                //Se tiver, atualiza o saldo
                estoqueModel.updateSaldoCliente(clienteID, moedaNome: MOEDA_BTC, novaQuantidade: quantidade, novoSaldo: valorCompraReal)
                
            } else {
                
                //Senão cria um novo saldo do Cliente para a moeda BTC
                estoqueModel.addEstoque(clienteID, moedaNome: MOEDA_BTC, quantidade: quantidade, saldo: valorCompraReal)
            }
            
            //Atualiza saldo do Cliente
            clienteModel.atualizaSaldoCliente(clienteID, novoSaldo: novo_saldo)
            
            //Grava Transação de compra
            transacaoModel.saveTransaction(clienteID, moedaNome: moedaAtual, valor: valorCompraReal, tipo: "COMPRA", quantidade: quantidade)
            
            completion(novo_saldo)
        } else {
            print("Saldo insuficiente!")
            completion(-1)
        }
    }
    
    //Cálculo de venda da moeda Brita
    func calculateSellBrita(_ quantidade: Double, valorCotacaoVenda: Double, saldoAtual: Double, clienteID: String, moedaAtual: String, completion: @escaping ([String: Any])->(), failureBlock: @escaping ()->Void) {
        
        var dict = [String: Any]()
        
        let quantidadeDouble = Double(quantidade).rounded(toPlaces: 2)
        
        //Recupera a Cotação do Dolar
        let cotacaoVenda = Double(valorCotacaoVenda).rounded(toPlaces: 2)
        
        let valor_venda = (quantidadeDouble * cotacaoVenda)
        //print("valor_venda =====> \(valor_venda)")
        
        let saldoFormatado = Double(saldoAtual).rounded(toPlaces: 2)
        //print("saldoFormatado =====> \(saldoFormatado)")
        
        let novo_saldo = (saldoFormatado + valor_venda)
        //print("novo_saldo =====> \(novo_saldo)")
        
        //Verifica a soma de moedas do Cliente
        let verificaQuantidade = estoqueModel.listAllEstoqueByClienteCoin(clienteID, moedaNome: moedaAtual)
        //transacaoModel.listAllQuantityByClienteCoin(clienteID, moedaNome: moedaAtual)
        //print("verificaQuantidade =====> \(verificaQuantidade)")
        
        //Verifica se existe saldo suciciente para a compra
        if (verificaQuantidade.quantidade >= quantidadeDouble) {
            
            //Verifica se existe saldo suciciente para a compra
            if (novo_saldo > 0) {
                
                //Atualiza saldo do Estoque
                estoqueModel.updateSaldoCliente(clienteID, moedaNome: MOEDA_BRITA, novaQuantidade: -quantidadeDouble, novoSaldo: -valor_venda)
                
                //Atualiza saldo do Cliente
                clienteModel.atualizaSaldoCliente(clienteID, novoSaldo: novo_saldo)
                
                //Grava Transação de venda
                transacaoModel.saveTransaction(clienteID, moedaNome: moedaAtual, valor: valor_venda, tipo: "VENDA", quantidade: quantidadeDouble)
                
                //Verifica a quantidade de moedas no estoque do Cliente
                let verificaQuantidade = estoqueModel.listAllEstoqueByClienteCoin(clienteID, moedaNome: moedaAtual)
                
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
        
        let quantidadeDouble = Double(quantidade).rounded(toPlaces: 7)
        
        //Recupera a Cotação do Dólar
        let cotacaoDolar = Double(moedaModel.loadDollarQuotes(MOEDA_BRITA).cotacaoVenda).rounded(toPlaces: 2)
        
        //Recupera a Cotação de BTC
        let cotacaoBtc = moedaModel.loadDollarQuotes(MOEDA_BTC)
        
        let cotacaoVenda = Double(cotacaoBtc.cotacaoVenda).rounded(toPlaces: 2)
        //print("cotacaoVenda =====> \(cotacaoVenda)")
        
        //Converte a cotação para Real
        let cotacao_formatada = (cotacaoVenda * cotacaoDolar)
        //print("cotacao_formatada =====> \(cotacao_formatada)")
        //100583.32
        
        //Calcula o valor da venda em reais
        let valor_venda = (quantidadeDouble * cotacao_formatada)
        //print("valor_venda =====> \(valor_venda)")
        
        //let valorVendaReal = (valor_venda * cotacaoDolar)
        
        //Saldo atual formatado
        let saldoFormatado = Double(saldoAtual).rounded(toPlaces: 2)
        //print("saldoFormatado =====> \(saldoFormatado)")
        
        //Calcula novo saldo em reais
        let novo_saldo = (saldoFormatado + valor_venda)
        //print("novo_saldo =====> \(novo_saldo)")
        
        //Verifica a quantidade de moedas no estoque do Cliente
        let verificaQuantidade = estoqueModel.listAllEstoqueByClienteCoin(clienteID, moedaNome: moedaAtual)
        //print("verificaQuantidade =====> \(verificaQuantidade)")
        
        //Verifica se existe saldo suciciente para a compra
        if (verificaQuantidade.quantidade >= quantidadeDouble) {
            
            //Verifica se existe saldo suciciente para a compra
            if (novo_saldo > 0) {
                
                //Atualiza saldo do Estoque
                estoqueModel.updateSaldoCliente(clienteID, moedaNome: MOEDA_BTC, novaQuantidade: -quantidadeDouble, novoSaldo: -valor_venda)
                
                //Atualiza saldo do Cliente
                clienteModel.atualizaSaldoCliente(clienteID, novoSaldo: novo_saldo)
                
                //Grava Transação de venda
                transacaoModel.saveTransaction(clienteID, moedaNome: moedaAtual, valor: valor_venda, tipo: "VENDA", quantidade: quantidadeDouble)
                
                //Verifica a quantidade de moedas no estoque do Cliente
                let verificaQuantidade = estoqueModel.listAllEstoqueByClienteCoin(clienteID, moedaNome: moedaAtual)
                
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
    
    //Cálculo de troca da moeda Brita
    func calculateChangeBritaByBtc(_ quantidade: Double, clienteID: String, cotacaoVendaMoedaOrigem: Double, cotacaoVendaMoedaTroca: Double, quantidadeOrigem: Double, valorTroca: Double, novaQuantidadeTroca: Double, novoValorTrocaConvertido: Double, completion: @escaping ([String: Any])->(), failureBlock: @escaping ()->Void) {
        
        var dict = [String: Any]()
        
        //Subtrai o saldo do estoque de Brita
        estoqueModel.updateSaldoCliente(clienteID, moedaNome: MOEDA_BRITA, novaQuantidade: -quantidade, novoSaldo: -(quantidade  * cotacaoVendaMoedaOrigem))
        
        //Zera saldo de BTC
        estoqueModel.zeraSaldoClienteByCoin(clienteID, moedaNome: MOEDA_BTC)
        
        //Atualiza o novo saldo do estoque de BTC
        estoqueModel.updateSaldoCliente(clienteID, moedaNome: MOEDA_BTC, novaQuantidade: novaQuantidadeTroca, novoSaldo: novoValorTrocaConvertido)
        
        //Grava Transação de troca
        transacaoModel.saveTransactionChange(clienteID, moedaNomeOrigem: MOEDA_BRITA, moedaNomeTroca: MOEDA_BTC, novoValorOrigem: valorTroca, novoValorTroca: novoValorTrocaConvertido, quantidadeOrigem: quantidade, quantidadeTroca: novaQuantidadeTroca, tipo: "TROCA")
        
        dict["erro"] = 0
        
        completion(dict)
    }
    
    //Cálculo de troca da moeda Bitcoin BTC
    func calculateChangeBtcByBrita(_ quantidade: Double, clienteID: String, cotacaoVendaMoedaOrigem: Double, cotacaoVendaMoedaTroca: Double, quantidadeOrigem: Double, valorTroca: Double, novaQuantidadeTroca: Double, novoValorTrocaConvertido: Double, completion: @escaping ([String: Any])->(), failureBlock: @escaping ()->Void) {
        
        var dict = [String: Any]()
        
        //Subtrai o saldo do estoque de Brita
        estoqueModel.updateSaldoCliente(clienteID, moedaNome: MOEDA_BTC, novaQuantidade: -quantidade, novoSaldo: -(quantidade  * cotacaoVendaMoedaOrigem))
        
        //Zera saldo de BTC
        estoqueModel.zeraSaldoClienteByCoin(clienteID, moedaNome: MOEDA_BRITA)
        
        //Atualiza o novo saldo do estoque de BTC
        estoqueModel.updateSaldoCliente(clienteID, moedaNome: MOEDA_BRITA, novaQuantidade: novaQuantidadeTroca, novoSaldo: novoValorTrocaConvertido)
        
        //Grava Transação de troca
        transacaoModel.saveTransactionChange(clienteID, moedaNomeOrigem: MOEDA_BRITA, moedaNomeTroca: MOEDA_BRITA, novoValorOrigem: valorTroca, novoValorTroca: novoValorTrocaConvertido, quantidadeOrigem: quantidade, quantidadeTroca: novaQuantidadeTroca, tipo: "TROCA")
        
        dict["erro"] = 0
        
        completion(dict)
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
    
    //Recuera a data atual
    func getDateToday() -> String {
        
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-dd-yyyy"
        let resultDate = formatter.string(from: date)
        
        return resultDate
    }
    
    //Recuera a data e hora atual
    func getDateTimeToday() -> String {
        
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy hh:mm:ss"
        let resultDate = formatter.string(from: date)
        
        return resultDate
    }

}



