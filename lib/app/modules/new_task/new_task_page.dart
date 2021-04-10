import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/app/modules/new_task/new_task_controller.dart';
import 'package:todo_list/app/shared/time_component.dart';

class NewTaskPage extends StatefulWidget {
  static String routerName = '/new';

  @override
  _NewTaskPageState createState() => _NewTaskPageState();
}

class _NewTaskPageState extends State<NewTaskPage> {
  var _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<NewTaskController>().addListener(() {
        //});
        //   Provider.of<NewTaskController>(context, listen: false).addListener(() {
        var controller = context.read<NewTaskController>();
        if (controller.error != null) {
          //  _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(controller.error)));
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('controller.error'),
              duration: const Duration(seconds: 3),
            ),
          );
        }

        if (controller.saved) {
          //   _scaffoldKey.currentState.showSnackBar(
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Todo cadastrado com sucesso'),
            duration: const Duration(seconds: 2),
          ));
          Future.delayed(Duration(seconds: 4), () => Navigator.pop(context));
        }
      });
    });
  }

  @override
  void dispose() {
    context.read<NewTaskController>().removeListener(() {});
//    Provider.of<NewTaskController>(context, listen: false).removeListener(() {});
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<NewTaskController>(
      builder: (BuildContext context, NewTaskController controller, _) {
        return Scaffold(
          key: _scaffoldKey,
          backgroundColor: Colors.white,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.white,
          ),
          body: SingleChildScrollView(
            child: Form(
              key: controller.formKey,
              child: Container(
                padding:
                    EdgeInsets.only(left: 20, right: 20, top: 0, bottom: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'NOVA TASK',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                      ),
                    ),
                    SizedBox(height: 15),
                    Text(
                      'data',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          //     fontSize: 16,
                          color: Colors.grey[700]),
                    ),
                    SizedBox(height: 10),
                    Text(
                      controller.dayFormated,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.grey[700]),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Nome da task',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          //     fontSize: 16,
                          color: Colors.grey[700]),
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      controller: controller.nomeTaskController,
                      decoration: InputDecoration(border: OutlineInputBorder()),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Nome da task brigatorio';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 15),
                    Text(
                      'Hora',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.grey[700]),
                    ),
                    SizedBox(height: 10),
                    TimeComponent(
                        date: controller.daySelected,
                        onSelectedTime: (date) {
                          controller.daySelected = date;
                        }),
                    SizedBox(height: 20),
                    _buildButton(controller),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildButton(NewTaskController controller) {
    return Center(
      child: InkWell(
        onTap: () => !controller.saved ? controller.save() : null,
        child: AnimatedContainer(
          duration: Duration(milliseconds: 300),
          curve: Curves.decelerate,
          width: controller.saved ? 80 : MediaQuery.of(context).size.width,
          height: controller.saved ? 80 : 40,
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: controller.saved
                ? BorderRadius.circular(100)
                : BorderRadius.circular(0),
            boxShadow: [
              controller.saved
                  ? BoxShadow(
                      offset: Offset(2, 2),
                      blurRadius: 30,
                      color: Theme.of(context).primaryColor)
                  : BoxShadow(
                      blurRadius: 1, color: Theme.of(context).primaryColor),
              //        BoxShadow(blurRadius: 30,color: Theme.of(context).primaryColor)
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: !controller.saved ? 0 : 80,
                child: AnimatedOpacity(
                  curve: Curves.easeInBack,
                  duration: Duration(milliseconds: 500),
                  opacity: controller.saved ? 1 : 0,
                  child: Icon(Icons.check, color: Colors.white),
                ),
              ),
              Visibility(
                visible: !controller.saved,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: Container(
                      child: Text(
                        'Salvar',
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
