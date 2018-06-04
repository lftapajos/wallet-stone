//
//  ListTransacoesTableViewCell.swift
//  wallet_stone
//
//  Created by Luis Felipe Tapajos on 29/05/18.
//  Copyright © 2018 Luis Felipe Tapajos. All rights reserved.
//

import UIKit

class ListTransacoesTableViewCell: UITableViewCell {

    // MARK: Declarações
    @IBOutlet weak var moedaLabel: UILabel!
    @IBOutlet weak var quantidadeLabel: UILabel!
    @IBOutlet weak var valorTransacaoLabel: UILabel!
    @IBOutlet weak var dataHoraTransacaoLabel: UILabel!
    @IBOutlet weak var tipoimageView: UIImageView!
    
    let moedaModel = MoedaModel()
    
    // MARK: Configura célula
    func configuraCelulaTransacao(transancao: Transacoes) {
        
        let moeda = moedaModel.loadCoinByName(transancao.moedaNome)

        //Formato moedas por tipo
        let valorFomatado = Help().formatCoin("pt_BR", valor: transancao.valorTransacao)
        
        //Carrega valores
        moedaLabel.text = moeda.nome
        quantidadeLabel.text = "Quantidade: \(transancao.quantidade)"
        valorTransacaoLabel.text = "Valor: \(valorFomatado)"
        dataHoraTransacaoLabel.text = transancao.dataHoraTransacao
        
        //Mostra imagem de operação compra, venda ou troca
        if (transancao.tipo == "COMPRA") {
            tipoimageView.image = UIImage(named: "btn_transacao_compra")
        } else if (transancao.tipo == "VENDA") {
            tipoimageView.image = UIImage(named: "btn_transacao_venda")
        } else if (transancao.tipo == "TROCA") {
            
            moedaLabel.text = "\(transancao.moedaNomeOrigem) por \(transancao.moedaNomeTroca)"
            quantidadeLabel.text = "\(transancao.quantidadeOrigem) ==> \(transancao.quantidadeTroca)"
            valorTransacaoLabel.text = "\(Help().formatCoin("pt_BR", valor: transancao.novoValorOrigem)) ==> \(Help().formatCoin("pt_BR", valor: transancao.novoValorTroca))"
            
            tipoimageView.image = UIImage(named: "btn_transacao_troca")
        }
        
        self.layer.borderWidth = 0.5
        self.layer.borderColor = UIColor(red:0.60, green:0.88, blue:0.96, alpha:1.0).cgColor
        self.layer.cornerRadius = 8
        
    }
    
    // MARK: Métodos
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
