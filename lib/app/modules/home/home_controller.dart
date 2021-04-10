import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_list/app/modeis/todo_model.dart';
import 'package:todo_list/app/repositories/todos_repository.dart';
import 'package:collection/collection.dart';

class HomeController extends ChangeNotifier {
  final TodosRepository repository;
  int selectedTab = 1;
  DateTime daySelected;
  DateTime startFilter;
  DateTime endFilter;

  Map<String, List<TodoModel>> listTodos;
  var dateFormat = DateFormat('dd/MM/yyyy');

  HomeController({@required this.repository}) {
    // repository.saveTodo(DateTime.now().add(Duration(days: 1)),
    //     'descrição  ${DateTime.now().minute}');
    repository.veoTodo();

    findAllForWeek();
  }

  Future<void> changeSelectedTab(BuildContext context, int index) async {
    selectedTab = index;
    switch (index) {
      case 0:
        filterFinalized();
        break;
      case 1:
        findAllForWeek();
        break;
      case 2:
        var day = await showDatePicker(
          context: context,
          initialDate: daySelected,
          firstDate: DateTime.now().subtract(Duration(days: 361 * 3)),
          lastDate: DateTime.now().add(Duration(days: 361 * 10)),
        );
        if (day != null) {
          daySelected = day;
          findTodosBySelectedDay();
        }
        break;
    }
    notifyListeners();
  }

//*busco una semana//////////////////////
  Future<void> findAllForWeek() async {
    daySelected = DateTime.now();

    startFilter = DateTime.now();
    endFilter = DateTime.now();

    if (startFilter.weekday != DateTime.monday) {
      startFilter =
          //   startFilter.subtract(Duration(days: (startFilter.weekday - 1)));
          startFilter.subtract(Duration(days: 10));
      print('startFilter   $startFilter');
    }

    endFilter = endFilter.add(Duration(days: 20));

    var todos = await repository.findByPeriod(startFilter, endFilter);

    if (todos.isEmpty) {
      listTodos = {dateFormat.format(DateTime.now()): []};
    } else {
      listTodos =
          groupBy(todos, (TodoModel todo) => dateFormat.format(todo.datahora));
    }
    this.notifyListeners();
  }

  void checkedOrUncheck(TodoModel todo) {
    todo.finalizado = !todo.finalizado; // con estoinvierto el valor

    repository.checkOrUncheckTodo(todo);
    this.notifyListeners();
  }

  void filterFinalized() {
    listTodos = listTodos.map((key, value) {
      var todosFinalized = value.where((t) => t.finalizado).toList();
      return MapEntry(key, todosFinalized);
    });
    this.notifyListeners();
  }

  Future<void> findTodosBySelectedDay() async {
    var todos = await repository.findByPeriod(daySelected, daySelected);
    if (todos.isEmpty) {
      listTodos = {dateFormat.format(daySelected): []};
    } else {
      listTodos =
          groupBy(todos, (TodoModel todo) => dateFormat.format(todo.datahora));
    }
    this.notifyListeners();
  }

  void update() {
    if (selectedTab == 1) {
      this.findAllForWeek();
    } else if (selectedTab == 2) {
      this.findTodosBySelectedDay();
    } else {
      this.findAllForWeek();
    }
  }
}
