# Wallet Stone

## Apresentação da Aplicação

Desafio desenvolvido para a empresa Stone. Desenvolvimento de aplicativo para criar uma carteira virtual de criptomoedas. Todo cliente ao se cadastrar recebe R$ 100.000,00 (cem mil reais) em conta para comprar Bitcoins e Britas. A cotação da criptomoeda Brita é equivalente ao dólar e pode ser consultada na API do Banco Central enquanto que a cotação do Bitcoin pode ser consultada na API do Mercado Bitcoin.

## Requerimento/Dependências

* [COCOAPODS](https://cocoapods.org) - The web framework used
* [Alamofire](https://github.com/Alamofire/Alamofire) - Dependency Management
* [ObjectMapper](https://github.com/Hearst-DD/ObjectMapper) - Dependency Management
* [PromisseKit](https://github.com/mxcl/PromiseKit) - Dependency Management
* [Realm](https://github.com/realm) - Dependency Management
* [Realm-Cocoa](https://github.com/realm/realm-cocoa) - Dependency Management
* [RealmSwift](https://github.com/realm/realm-cocoa/tree/master/RealmSwift) - Dependency Management

## Como Começar

- Desafio feito em linguagem Swift.
- Configuração de rotas através do arquivo: Constants.swift
- Dados armazenados em um Banco de Dados local.

## Lançamentos Principais

## Como usar

## Carregando Cotações

Ao abrir o aplicativo as cotações das moedas "Brita" e "Bitcoin (BTC)" são carregadas de suas respectivas APIs.

<a href="https://imgflip.com/gif/2bl8wq"><img src="https://i.imgflip.com/2bl8wq.gif" title="made at imgflip.com"/></a>

Caso as cotações não seja encontradas, uma mensagem de erro irá aparecer pedindo para que retorne novamente mais tarde. Isso foi criado porque as cotação são parte fundamental nas operações de compra, venda e troca do aplicativo.

<a href="https://imgflip.com/gif/2bl8ps"><img src="https://i.imgflip.com/2bl8ps.gif" title="made at imgflip.com"/></a>

Se as cotações forem carregadas, então o aplicativo estará pronto para ser executado.

<a href="https://imgflip.com/gif/2bl8mr"><img src="https://i.imgflip.com/2bl8mr.gif" title="made at imgflip.com"/></a>

## Registo de Clientes

É necessário criar um Cliente novo para executar as operações do aplicativo.

Campos para teste de registro:
- Nome: Jose
- Email: jose@gmail.com
- Senha: j0$3

<a href="https://imgflip.com/gif/2b8g6v"><img src="https://i.imgflip.com/2b8g6v.gif" title="made at imgflip.com"/></a>
<a href="https://imgflip.com/gif/2b8gdo"><img src="https://i.imgflip.com/2b8gdo.gif" title="made at imgflip.com"/></a>

## Login de Clientes

Efetuando o login o cliente poderá executar as operações do aplicativo.

Campos para teste de login:
- Email: jose@gmail.com
- Senha: j0$3

<a href="https://imgflip.com/gif/2b8gzr"><img src="https://i.imgflip.com/2b8gzr.gif" title="made at imgflip.com"/></a>

## Tela de Compra

Aqui o cliente poderá comprar moedas dos 2 tipos: Brita e Bitcoin (BTC).

Chamada para a tela de compra de Moedas:

<a href="https://imgflip.com/gif/2ba2g1"><img src="https://i.imgflip.com/2ba2g1.gif" title="made at imgflip.com"/></a>

## Comprando Brita

Comprando moedas do tipo Brita:

<a href="https://imgflip.com/gif/2ba2mr"><img src="https://i.imgflip.com/2ba2mr.gif" title="made at imgflip.com"/></a>

## Comprando BTC

Comprando moedas do tipo Bitcoin (BTC):

<a href="https://imgflip.com/gif/2ba2tl"><img src="https://i.imgflip.com/2ba2tl.gif" title="made at imgflip.com"/></a>

## Transações de Compra

Transações de compra efetuadas:

<a href="https://imgflip.com/gif/2ba2yc"><img src="https://i.imgflip.com/2ba2yc.gif" title="made at imgflip.com"/></a>

## Tela de Venda

Chamada para a tela de venda de Moedas:

<a href="https://imgflip.com/gif/2ba331"><img src="https://i.imgflip.com/2ba331.gif" title="made at imgflip.com"/></a>

## Vendendo Brita

Vendendo moedas do tipo Brita. É necessário ter saldo suficiente para a operação.

<a href="https://imgflip.com/gif/2ba39m"><img src="https://i.imgflip.com/2ba39m.gif" title="made at imgflip.com"/></a>

## Vendendo BTC

Vendendo moedas do tipo Bitcoin (BTC). É necessário ter saldo suficiente para a operação.

<a href="https://imgflip.com/gif/2ba3fn"><img src="https://i.imgflip.com/2ba3fn.gif" title="made at imgflip.com"/></a>

## Transações de Venda

Transações de venda efetuadas:

<a href="https://imgflip.com/gif/2ba3km"><img src="https://i.imgflip.com/2ba3km.gif" title="made at imgflip.com"/></a>

## Tela de Troca

Chama a tela para troca de Moedas:

<a href="https://imgflip.com/gif/2bb9ra"><img src="https://i.imgflip.com/2bb9ra.gif" title="made at imgflip.com"/></a>

## Troca de moedas com valor inválido

Ao tentar efetuar uma troca de moedas, alguns avisos podem ocorrer.

- Aviso de valor inválido.

<a href="https://imgflip.com/gif/2bele6"><img src="https://i.imgflip.com/2bele6.gif" title="made at imgflip.com"/></a>

## Troca de moedas com valor baixo

- Aviso de valor muito baixo para a transação.

Isso ocorre caso o valor escolhido para troca seja muito baixo tendendo a zero.

<a href="https://imgflip.com/gif/2belky"><img src="https://i.imgflip.com/2belky.gif" title="made at imgflip.com"/></a>

## Troca de moedas com saldo insuficiente

- Aviso de saldo insuficiente para a troca.

Isso ocorre quando o cliente desejar trocar uma quantidade de moedas superior a quantidade disponível por ele. 

<a href="https://imgflip.com/gif/2belqu"><img src="https://i.imgflip.com/2belqu.gif" title="made at imgflip.com"/></a>

## Confirmação de Troca de moedas

- Aviso de confirmação de troca de moedas.

Se tudo ocorrer bem, esse aviso deverá aparecer e uma nova transação será criada.

<a href="https://imgflip.com/gif/2belva"><img src="https://i.imgflip.com/2belva.gif" title="made at imgflip.com"/></a>

## Transações de Troca

- Confirmação de troca de uma moeda por outra.

Transações de troca efetuadas:

<a href="https://imgflip.com/gif/2bknhn"><img src="https://i.imgflip.com/2bknhn.gif" title="made at imgflip.com"/></a>

## Status do Código

## Licença

Este projeto está licenciado sob a licença MIT - Consulte LICENÇA para obter detalhes.

## Créditos

* **Luís Felipe Tapajós** - *Initial work* - [lftapajos](https://github.com/lftapajos)

