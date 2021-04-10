import 'package:todo_list/app/database/connection.dart';
import 'package:todo_list/app/modeis/todo_model.dart';

class TodosRepository {
  Future<List<TodoModel>> findByPeriod(DateTime start, DateTime end) async {
    var startFilter = DateTime(start.year, start.month, start.day, 0, 0, 0);
    var endFilter = DateTime(end.year, end.month, end.day, 23, 59, 59);

    var conn = await Connection().instance;
    // result retorna um map llave valor llave nombre do campo
    var result = await conn.rawQuery(
      "select * from todo  where datahora between ? and ? order by datahora ",
      [startFilter.toIso8601String(), endFilter.toIso8601String()],
    );
    //  print('start filter do find ${startFilter.toIso8601String()}');
    // print('end filter do find ${endFilter.toIso8601String()}');

    return result.map((t) => TodoModel.fromMap(t)).toList();
  }

  Future<void> saveTodo(DateTime dateTimeTask, String descricao) async {
    var conn = await Connection().instance;
    await conn.rawInsert('insert into todo values(?,?,?,?)',
        [null, descricao, dateTimeTask.toIso8601String(), 0]);
  }

  Future<void> checkOrUncheckTodo(TodoModel todo) async {
    var conn = await Connection().instance;
    await conn.rawUpdate('update todo set finalizado = ? where id = ?',
        [todo.finalizado ? 1 : 0, todo.id]);
  }

  Future<void> removerTodo(int id) async {
    print('id para deletar $id');
    var conn = await Connection().instance;
    //  await conn.rawDelete('delete from todo where id = ?', [todo.id]);
    await conn.rawDelete('delete from todo where id = ?', [id]);
    print('id deletado $id');
  }

  Future<List<TodoModel>> veoTodo() async {
    var conn = await Connection().instance;
    var result = await conn.rawQuery('select * from todo ');
    var listo = result.map((t) => TodoModel.fromMap(t)).toList();
    print('veo todo');
    for (var i = 0; i < listo.length; i++) {
      print(
          ' id =${listo[i].id} desc=${listo[i].descricao} data=${listo[i].datahora} ');
    }
    return listo;
  }
}
