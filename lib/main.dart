import 'package:flutter/material.dart';

void main() {
  runApp(const ContadorApp());
}

class ContadorApp extends StatelessWidget {
  const ContadorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Contador de Inspeção',
      home: const TelaContador(),
    );
  }
}
class TelaContador extends StatefulWidget {
  const TelaContador({super.key});

  @override
  State<TelaContador> createState() => _TelaContadorState();
}
class _TelaContadorState extends State<TelaContador> {
  int _pecasAprovadas = 0;
  final _nomeController = TextEditingController();
  final List<String> _registros = [];
  //lista vazia de textos que vai guardadr o historico de registros
  void _aprovarPeca(){
    //funcao chamada toda vez que o botao +1 e tocado pelo usuario
    setState(() {
      //sempre que um dado do state muda essa alteraçao precisa ocorrer dentro do setstate
      //para que o flutter saiba que precisa redesenhar a tela com o novo valor
      _pecasAprovadas+=1;
      //incrementa pecas em 1

    });
  }
  void _registrarEZerar(){
    //funcao chamada quando o botao registrar e zerar e tocado pelo usuario
    final nome = _nomeController.text.trim().isEmpty
        ? 'Sem nome'
        : _nomeController.text.trim();
        //operador ternario(condicao?valorVerdadeiro:valorFalso)
        //.trim() remove espaços em branco de texto
        //se, depois disso o texto estiver vazio, usamos
        //''nao informado''; senao usamos o nome digitado
    setState((){
      _registros.add('$nome - $_pecasAprovadas peça(s)');
      //monta um texto combina o nome e a contagem atual (interpolacao de string)
      //adiciona esse texto montado no final da lista de registros
      _pecasAprovadas = 0;
      //zera o contador
    });
  }
  @override
  void dispose(){
    //dispose e chamado pelo flutter quando a tela e removidad da arvore
    //de widgets, ou seja, quando o usuario sai da tela
    _nomeController.dispose();
    //libera os recursos usados pelo controller (evita deixar memoria alocada/em uso)
    super.dispose();
    //chama a implementacao original/nativa do dispose da classe pai
    //deve ser sempre a ultima linha da funcao dispose,
    //para garantir que tudo seja limpo corretamente
  }
  @override
  Widget build(BuildContext context) {
    //monta a devolve a arvore de widgets que compoem a tela no estado atual(com valores atuais das variaveis)
    return Scaffold(
      appBar:AppBar(
        title: Text('inspecao de pecas'),
        //titulo fixo da barra no topo da tela
      ),
      body: Padding(
        padding:const EdgeInsets.all(16.0),
        child: Column(
          //organiza todo o conteudo da tela verticalmente
          children: [
            TextField(
              //campo de texto onde o inspetor digita o nome do inspetor
              controller: _nomeController,
              decoration: const InputDecoration(
                labelText: 'Nome do inspetor',
                border: OutlineInputBorder(),
                //desenha uma borda ao redor do campo de texto
              ),
              onChanged:(texto){
                //onchanged e chamado toda vez que o usuario digita ou apaga algo no campo de texto
                setState(() {});
                //chamamos o setstate com um bloco vazio so para forcar a tela 
                //a se redesenhar. o dado em so (_nomeController.text) ja foi atualizado pelo controller 
                //so precisamos avisar o flutter para reler esse valor no text logo abaixo
              },
            ),
            const SizedBox(height: 16.0),
            //espaco vertical entre o campo de texto e a linha de ''responsavel''

            Text(
              _nomeController.text.trim().isEmpty
              ? 'responsavel nao informado'
              : 'responsavel: ${_nomeController.text.trim()}',
              //operador ternario se o campo ainda estiver vazio 
              //mostramos um aviso, senao, mostramos o nome digitado
              //(interpolando dentro do texto com ${})
            style: const TextStyle(fontSize: 16, color: Colors.grey),

            ),
            const SizedBox(height: 16),
            Text(
              '$_pecasAprovadas',
              style: const TextStyle(fontSize: 60, fontWeight: FontWeight.bold)

            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FilledButton.icon(
                  onPressed: _aprovarPeca, 
                  icon: const Icon(Icons.add),
                  label: const Text('+1 peca'),

                  ),
                  const SizedBox(width: 12,),
                  OutlinedButton.icon(
                    onPressed: _registrarEZerar,
                    icon:const Icon(Icons.save_alt),
                    label: const Text('Registrar e zerar'),
                  ),

                  const SizedBox(width: 16,),

                  const Align(
                    alignment: AlignmentGeometry.centerLeft,
                    child:Text(
                      'historico do turno',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 8,),
                  Expanded(
                    child: _registros.isEmpty
                      ? const Center(child: Text('nenhum registro ainda'))
                      : ListView.builder(
                        itemCount: _registros.length,
                        itemBuilder: (context, index){
                          return Card(
                            child: ListTile(
                              leading: const Icon(Icons.history),
                              title: Text(_registros[index]),
                            ),
                          );
                        },
                      ),
                  ),
              ],
            )
          ]
        )
      )
    );
  }
}