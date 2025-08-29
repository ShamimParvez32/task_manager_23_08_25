import 'package:flutter/material.dart';
import 'package:task_manager_23_08_25/data/models/completed_task_list_model.dart';
import 'package:task_manager_23_08_25/data/models/task_list_By_Status_model.dart';
import 'package:task_manager_23_08_25/data/services/network_caller.dart';
import 'package:task_manager_23_08_25/data/utlis/urls.dart';
import 'package:task_manager_23_08_25/ui/widgets/screen_background.dart';
import 'package:task_manager_23_08_25/ui/widgets/show_snakebar_message.dart';
import 'package:task_manager_23_08_25/ui/widgets/task_item.dart';
import 'package:task_manager_23_08_25/ui/widgets/tm_app_bar.dart';

void main() => runApp(MaterialApp(home: CompletedTaskListScreen()));

class CompletedTaskListScreen extends StatefulWidget {
  const CompletedTaskListScreen({super.key});

  @override
  State<CompletedTaskListScreen> createState() => _CompletedTaskListScreenState();
}

class _CompletedTaskListScreenState extends State<CompletedTaskListScreen> {
  bool _getCompletedTaskListInProgress = false;
  CompletedTaskListByStatusModel? completedTaskListByStatusModel;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _completedNewTaskList();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme
        .of(context)
        .textTheme;
    return Scaffold(
      appBar: TmAppBar(),
      body: ScreenBackground(
        child: Column(
          children: [
            SizedBox(height: 8),
            Expanded(
              child:
              _getCompletedTaskListInProgress
                  ? Center(child: CircularProgressIndicator())
                  : ListView.builder(
                shrinkWrap: true,
                itemCount: completedTaskListByStatusModel?.completedTaskModelList?.length ??
                    0,
                itemBuilder: (context, index) {
                  return TaskItem(
                    taskModel: completedTaskListByStatusModel!
                        .completedTaskModelList![index],
                    refreshList: () {
                      _completedNewTaskList();
                      setState(() {});
                    },);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }





  Future<void> _completedNewTaskList() async {
    _getCompletedTaskListInProgress = true;
    setState(() {});
    final NetworkResponse response = await NetworkCaller.getRequest(
        url: Urls.completedTaskListByStatus('Completed'));

    if (response.isSuccess) {
      completedTaskListByStatusModel =
          CompletedTaskListByStatusModel.fromJson(response.responseBody!);
    }
    else {
      showSnakeBarMessage(context, response.errorMessage);
    }
    _getCompletedTaskListInProgress = false;
    setState(() {});
  }


}

