import 'package:flutter/material.dart';
import 'package:task_manager_23_08_25/data/models/count_summery_by_status.dart';
import 'package:task_manager_23_08_25/data/models/task_count_model.dart';
import 'package:task_manager_23_08_25/data/models/task_list_By_Status_model.dart';
import 'package:task_manager_23_08_25/data/services/network_caller.dart';
import 'package:task_manager_23_08_25/data/utlis/urls.dart';
import 'package:task_manager_23_08_25/ui/screens/add_new_task_screen.dart';
import 'package:task_manager_23_08_25/ui/widgets/screen_background.dart';
import 'package:task_manager_23_08_25/ui/widgets/show_snakebar_message.dart';
import 'package:task_manager_23_08_25/ui/widgets/task_item.dart';
import 'package:task_manager_23_08_25/ui/widgets/tm_app_bar.dart';

void main() => runApp(MaterialApp(home: NewTaskListScreen()));

class NewTaskListScreen extends StatefulWidget {
  const NewTaskListScreen({super.key});

  @override
  State<NewTaskListScreen> createState() => _NewTaskListScreenState();
}

class _NewTaskListScreenState extends State<NewTaskListScreen> {
  bool _getTaskCountByStatusInProgress = false;
  bool _getNewTaskListInProgress = false;
  CountTaskSummeryByStatusModel? countTaskSummeryByStatusModel;
  NewTaskListByStatusModel? newTaskListByStatusModel;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getTaskCountByStatus();
    _getNewTaskList();
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
            Padding(
              padding: EdgeInsets.all(8),
              child: SizedBox(
                height: 80,
                width: double.maxFinite,
                child: _getTaskCountByStatusInProgress
                    ? Center(child: CircularProgressIndicator()) // Center loader for task count
                    : _buildTaskCountSummery(textTheme),
              ),
            ),

            SizedBox(height: 8),
            Expanded(
              child:
                  _getNewTaskListInProgress
                  ? Center(child: CircularProgressIndicator())
              : ListView.builder(
                shrinkWrap: true,
                itemCount: newTaskListByStatusModel?.newTaskModelList?.length ??
                    0,
                itemBuilder: (context, index) {
                  return TaskItem(
                    taskModel: newTaskListByStatusModel!
                        .newTaskModelList![index],
                    refreshList: () {
                      _getNewTaskList();
                      _getTaskCountByStatus();
                      setState(() {});
                    },);
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(onPressed: () async {
        final result = await Navigator.pushNamed(
            context, AddNewTaskScreen.name);
        if (result != null) {
          _getTaskCountByStatus();
          _getNewTaskList();
          setState(() {});
        }
      }, child: Icon(Icons.add),),
    );
  }

  Widget _buildTaskCountSummery(TextTheme textTheme) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: countTaskSummeryByStatusModel?.taskCountList?.length ?? 0,
      itemBuilder: (BuildContext context, int index) {
        final TaskCountModel model = countTaskSummeryByStatusModel!
            .taskCountList![index];
        return Card(
          elevation: 0,
          color: Colors.white,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(model.sum.toString(), style: textTheme.titleLarge),
                Text(model.sId ?? '', style: textTheme.titleSmall),

              ],
            ),
          ),
        );
      },
    );
  }


  Future<void> _getTaskCountByStatus() async {
    _getTaskCountByStatusInProgress = true;
    setState(() {});
    final NetworkResponse response = await NetworkCaller.getRequest(
        url: Urls.taskStatusCountUrl);
    if (response.isSuccess) {
      countTaskSummeryByStatusModel =
          CountTaskSummeryByStatusModel.fromJson(response.responseBody!);
    }
    else {
      showSnakeBarMessage(context, response.errorMessage);
    }
    _getTaskCountByStatusInProgress = false;
    setState(() {});
  }


  Future<void> _getNewTaskList() async {
    _getNewTaskListInProgress = true;
    setState(() {});
    final NetworkResponse response = await NetworkCaller.getRequest(
        url: Urls.newTaskListByStatus('New'));

    if (response.isSuccess) {
      newTaskListByStatusModel =
          NewTaskListByStatusModel.fromJson(response.responseBody!);
    }
    else {
      showSnakeBarMessage(context, response.errorMessage);
    }
    _getNewTaskListInProgress = false;
    setState(() {});
  }


}

