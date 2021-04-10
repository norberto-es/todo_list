import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_list/app/modules/del_task/del_task_controller.dart';
import 'package:todo_list/app/repositories/todos_repository.dart';

class DeleteTaskPage extends StatefulWidget {
  static String routerName = '/deltask';

  const DeleteTaskPage(
      {Key key,
      this.idSelected,
      this.descricao,
      this.datahora,
      this.finalizado})
      : super(key: key);

  final int idSelected;
  final String descricao;
  final DateTime datahora;
  final bool finalizado;

  @override
  _DeleteTaskPageState createState() => _DeleteTaskPageState();
}

class _DeleteTaskPageState extends State<DeleteTaskPage> {
  var dateFormat = DateFormat('dd/MM/yyyy');

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('del page'),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Card(
                elevation: 10,
                child: Container(
                  width: MediaQuery.of(context).size.width - 30,
                  child: Column(
                    children: [
                      Text(
                        'ID  ${widget.idSelected}',
                        style: TextStyle(fontSize: 12),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          '${widget.descricao}',
                          style: TextStyle(fontSize: 25),
                        ),
                      ),
                      Text(
                        //'Dia ',
                        'Dia ${dateFormat.format(widget.datahora)}',
                        style: TextStyle(fontSize: 20),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(widget.finalizado ? 'Finalizado' : '',
                          style: TextStyle(
                              fontSize: 20,
                              color: Theme.of(context).primaryColor)),
                      SizedBox(
                        height: 10,
                      ),
                      Divider(),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          onPressed: () async {
                            print('deletado');
                            //     await DelTaskController(id: widget.idSelected)
                            //          .deletear();
                            await TodosRepository()
                                .removerTodo(widget.idSelected);
                            Navigator.of(context).pop();
                          },
                          style: ButtonStyle(
                              elevation: MaterialStateProperty.all(20.00),
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.red)),
                          child: Text(
                            'Deletar',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
