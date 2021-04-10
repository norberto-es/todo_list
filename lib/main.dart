import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/app/database/connection.dart';

import 'package:todo_list/app/database/migrations/database_adm_connection.dart';
import 'package:todo_list/app/modules/del_task/del_task_controller.dart';

import 'package:todo_list/app/modules/home/home_controller.dart';
import 'package:todo_list/app/modules/home/home_page.dart';
import 'package:todo_list/app/modules/new_task/new_task_controller.dart';
import 'package:todo_list/app/modules/new_task/new_task_page.dart';
import 'app/modules/del_task/delete_task_page.dart';
import 'app/repositories/todos_repository.dart';

void main() {
  runApp(App());
}

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  //
  DatabaseAdmConnection databaseAdmConnection = DatabaseAdmConnection();

  @override
  void initState() {
    super.initState();
    Connection().instance;
    WidgetsBinding.instance.addObserver(databaseAdmConnection);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(databaseAdmConnection);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(
          create: (_) => TodosRepository(),
        )
      ],
      child: MaterialApp(
        title: 'Todo List',
        theme: ThemeData(
          primaryColor: Color(0xFFFF9229),
          buttonColor: Color(0xFFFF9229),
          textTheme: GoogleFonts.robotoTextTheme(),
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        routes: {
          NewTaskPage.routerName: (_) => ChangeNotifierProvider(
                create: (context) {
                  var day = ModalRoute.of(_).settings.arguments;

                  return NewTaskController(
                      repository: context.read<TodosRepository>(), day: day);
                },
                child: NewTaskPage(),
              ),
          //DeleteTaskPage
          DeleteTaskPage.routerName: (_) => ChangeNotifierProvider(
                create: (context) {
                  var idSel = ModalRoute.of(_).settings.arguments;
                  var descSel = ModalRoute.of(_).settings.arguments;
                  return DelTaskController(
                      repository: context.read<TodosRepository>(),
                      id: idSel,
                      desc: descSel);
                },
                child: DeleteTaskPage(),
              ),
        },
        home: ChangeNotifierProvider(
          create: (context) {
            // (_) = (context)
            // var repository = Provider.of<TodosRepository>(context);
            //! a partir 4.1
            var repository = context.read<TodosRepository>();
            return HomeController(repository: repository);
          },
          child: HomePage(),
        ),
      ),
    );
  }
}
