//
//  Help.swift
//  wallet_stone
//
//  Created by Luis Felipe Tapajos on 28/05/18.
//  Copyright © 2018 Luis Felipe Tapajos. All rights reserved.
//

import Foundation

//Formata Moedas
func formatCoin(_ codigo: String, valor: Double) -> String {
    
    let formatter = NumberFormatter()
    let locale = Locale(identifier: codigo)
    formatter.locale = locale
    formatter.numberStyle = .currency
    let valorFormatado = formatter.string(from: valor as NSNumber)
    return valorFormatado!
    
}

//Cálculo de compra da moeda Brita
func calculateBuyBrita(_ quantidade: Double, saldoAtual: Double, valorCotacaoCompra: Double) -> Double {
    
    let calculoCompra = (quantidade * valorCotacaoCompra)
    let calculoFinal = (saldoAtual - calculoCompra)
    
    //let saldoConvertido = (saldoAtual / valorCotacaoCompra)
    //let calculoCompra = (quantidade * valorCotacaoCompra)
    //let calculoFinal = (saldoConvertido - calculoCompra)
    //let saldoFinalDesconvertido = (calculoFinal * valorCotacaoCompra)
    
    return calculoFinal
}

//Cálculo de compra da moeda Bitcoin BTC
func calculateBuyBtc(_ saldoAtualDolar: Double, saldoConvercao: Double, valorCotacaoCompra: Double) -> Double {
    
    let calculoCompra = (saldoAtualDolar - saldoConvercao)
    let calculoFinal = (calculoCompra * valorCotacaoCompra)
    return calculoFinal
}

//Cálculo de venda da moeda Brita
func calculateSellBrita(_ quantidade: Double, saldoAtual: Double, valorCotacaoVenda: Double) -> Double {
    
    //let saldoConvertido = (saldoAtual / valorCotacaoVenda)
    let calculoVenda = (quantidade * valorCotacaoVenda)
    let saldoFinalDesconvertido = (saldoAtual + calculoVenda)
    //let saldoFinalDesconvertido = (calculoFinal * valorCotacaoVenda)
    
    return saldoFinalDesconvertido
}

//Cálculo de venda da moeda Bitcoin BTC
func calculateSellBtc(_ quantidade: Double, saldoAtualDolar: Double, valorCotacaoVenda: Double) -> Double {
    
    let calculoVenda = (quantidade * saldoAtualDolar) //valorCotacaoVenda * (
    //let calculoFinal = (saldoAtualDolar + calculoVenda)
    let saldoFinalDesconvertido = (calculoVenda / valorCotacaoVenda)
    
    return saldoFinalDesconvertido
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
