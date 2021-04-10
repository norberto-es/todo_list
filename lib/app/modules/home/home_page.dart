import 'package:ff_navigation_bar/ff_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:todo_list/app/modules/del_task/delete_task_page.dart';
import 'package:todo_list/app/modules/home/home_controller.dart';
import 'package:todo_list/app/modules/new_task/new_task_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<HomeController>(
      builder: (BuildContext context, HomeController controller, _) {
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text('Atividades',
                style: TextStyle(color: Theme.of(context).primaryColor)),
            backgroundColor: Colors.white,
          ),
          bottomNavigationBar: FFNavigationBar(
            selectedIndex: controller.selectedTab,
            onSelectTab: (index) =>
                controller.changeSelectedTab(context, index),
            theme: FFNavigationBarTheme(
              itemWidth: 60,
              barHeight: 70,
              barBackgroundColor: Theme.of(context).primaryColor,
              unselectedItemIconColor: Colors.white,
              unselectedItemLabelColor: Colors.white,
              selectedItemBorderColor: Colors.white,
              selectedItemIconColor: Colors.white,
              selectedItemBackgroundColor: Theme.of(context).primaryColor,
              selectedItemLabelColor: Colors.black,
            ),
            items: [
              FFNavigationBarItem(
                iconData: Icons.check_circle,
                label: 'Finalizados',
              ),
              FFNavigationBarItem(
                iconData: Icons.view_week,
                label: 'Semanal',
              ),
              FFNavigationBarItem(
                iconData: Icons.calendar_today,
                label: 'Seleccionar Data',
              ),
            ],
          ),
          body: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: ListView.builder(
              itemCount: controller.listTodos?.keys?.length ?? 0,
              itemBuilder: (_, index) {
                var dateFormat = DateFormat('dd/MM/yyyy');

                var listTodos = controller.listTodos;
                var dayKey = listTodos.keys.elementAt(index);
                var day = dayKey;
                var todos = listTodos[dayKey];
                if (todos.isEmpty && controller.selectedTab == 0) {
                  return SizedBox.shrink();
                }
                var today = DateTime.now();
                if (dayKey == dateFormat.format(today)) {
                  day = 'HOJE';
                } else if (dayKey ==
                    dateFormat.format(today.add(Duration(days: 1)))) {
                  day = 'AMANHA';
                } else if (dayKey ==
                    dateFormat.format(today.add(Duration(days: 2)))) {
                  day = 'DESPUES DE AMAÑA';
                } else if (dayKey ==
                    dateFormat.format(today.add(Duration(days: -1)))) {
                  day = 'ONTEM';
                }

                return Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 20, right: 20, top: 20),
                      child: Row(
                        //asi o   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              day,
                              style: TextStyle(
                                  fontSize: 30, fontWeight: FontWeight.bold),
                            ),
                          ),
                          IconButton(
                              icon: Icon(
                                Icons.add_circle,
                                size: 30,
                                color: Theme.of(context).primaryColor,
                              ),
                              onPressed: () async {
                                await Navigator.of(context).pushNamed(
                                    NewTaskPage.routerName,
                                    arguments: dayKey);
                                controller.update();
                              })
                        ],
                      ),
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: todos.length,
                      itemBuilder: (_, index) {
                        var todo = todos[index];
                        return InkWell(
                          child: ListTile(
                            leading: Checkbox(
                              activeColor: Theme.of(context).primaryColor,
                              value: todo.finalizado,
                              onChanged: (bool value) =>
                                  controller.checkedOrUncheck(todo),
                            ),
                            title: Text(
                              todo.descricao,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                decoration: todo.finalizado
                                    ? TextDecoration.lineThrough
                                    : null,
                              ),
                            ),
                            trailing: Text(
                              '${todo.datahora.hour.toString().padLeft(2, '0')}:${todo.datahora.minute.toString().padLeft(2, '0')}',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                decoration: todo.finalizado
                                    ? TextDecoration.lineThrough
                                    : null,
                              ),
                            ),
                          ),
                          onTap: () async {
                            await Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) => DeleteTaskPage(
                                        idSelected: todo.id,
                                        descricao: todo.descricao,
                                        datahora: todo.datahora,
                                        finalizado: todo.finalizado,
                                      )),
                            );
                            controller.update();
                          },
                        );
                      },
                    )
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }
}
