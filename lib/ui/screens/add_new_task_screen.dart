import 'package:flutter/material.dart';
import 'package:task_manager_23_08_25/data/services/network_caller.dart';
import 'package:task_manager_23_08_25/data/utlis/urls.dart';
import 'package:task_manager_23_08_25/ui/widgets/looder.dart';
import 'package:task_manager_23_08_25/ui/widgets/screen_background.dart';
import 'package:task_manager_23_08_25/ui/widgets/show_snakebar_message.dart';
import 'package:task_manager_23_08_25/ui/widgets/tm_app_bar.dart';

class AddNewTaskScreen extends StatefulWidget {
  const AddNewTaskScreen({super.key});

  static const String name = '/add-new-task';

  @override
  State<AddNewTaskScreen> createState() => _AddNewTaskScreenState();
}

class _AddNewTaskScreenState extends State<AddNewTaskScreen> {
  final TextEditingController _titleTEController = TextEditingController();
  final TextEditingController _descriptionTEController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _addNewTaskInProgress = false;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: TmAppBar(),
      body: ScreenBackground(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(36),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  SizedBox(height: 80),
                  Text('Add New Task', style: textTheme.titleLarge),
                  SizedBox(height: 24),
                  TextFormField(
                    controller: _titleTEController,
                    decoration: InputDecoration(hintText: 'Title'),
                    validator: (String? value) {
                      if (value?.trim().isEmpty ?? true) {
                        return 'Enter Your title';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 8),
                  TextFormField(
                    controller: _descriptionTEController,
                    maxLines: 4,
                    decoration: InputDecoration(hintText: 'Description'),
                    validator: (String? value) {
                      if (value?.trim().isEmpty ?? true) {
                        return 'Enter Your description here';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 24),
                  Visibility(
                    visible: _addNewTaskInProgress == false,
                    replacement: CenterCircularProgressIndicator(),
                    child: ElevatedButton(
                      onPressed: () {
                        _onTabNewTaskBtn();
                      },
                      child: Icon(Icons.arrow_circle_right_outlined),
                    ),
                  ),

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }


  void _onTabNewTaskBtn() {
    if (_formKey.currentState!.validate()) {
      _addNewTask();
    }
  }

  Future<void> _addNewTask() async {
    _addNewTaskInProgress = true;
    setState(() {});

    Map<String, dynamic> requestBody = {
      "title": _titleTEController.text.trim(),
      "description": _descriptionTEController.text,
      "status": "New"
    };
    final NetworkResponse response = await NetworkCaller.postRequest(
      url: Urls.addNewTaskUrl,
      body: requestBody,
    );
    _addNewTaskInProgress = false;
    setState(() {});

    if (response.isSuccess) {
      clearTextField();
      showSnakeBarMessage(context, 'task added Successfully');
      Navigator.pop(context,true);
    } else {
      showSnakeBarMessage(context, 'create task failed');

    }
  }

  void clearTextField(){
    _titleTEController.clear();
    _descriptionTEController.clear();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _titleTEController.dispose();
    _descriptionTEController.dispose();
  }
}

