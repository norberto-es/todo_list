import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_list/app/repositories/todos_repository.dart';

class DelTaskController extends ChangeNotifier {
  final TodosRepository repository;
  final dateFormat = DateFormat('dd/MM/yyyy');
  int idSelected;
  String descSelected;
  String error;

  DelTaskController({this.repository, int id, String desc}) {
    idSelected = id;
    descSelected = desc;
  }

  Future<void> deletear() async {
    try {
      print('Print id selectedi     $idSelected');
      await repository.removerTodo(idSelected);
    } catch (e) {
      error = 'Erro ao salvar todo';
    }
    this.notifyListeners();
  }
}
