import 'package:flutter/material.dart';
import 'package:task_manager_23_08_25/data/models/progress_task_List_model.dart';
import 'package:task_manager_23_08_25/data/models/task_list_By_Status_model.dart';
import 'package:task_manager_23_08_25/data/services/network_caller.dart';
import 'package:task_manager_23_08_25/data/utlis/urls.dart';
import 'package:task_manager_23_08_25/ui/widgets/screen_background.dart';
import 'package:task_manager_23_08_25/ui/widgets/show_snakebar_message.dart';
import 'package:task_manager_23_08_25/ui/widgets/task_item.dart';
import 'package:task_manager_23_08_25/ui/widgets/tm_app_bar.dart';

void main() => runApp(MaterialApp(home: ProgressTaskListScreen()));

class ProgressTaskListScreen extends StatefulWidget {
  const ProgressTaskListScreen({super.key});

  @override
  State<ProgressTaskListScreen> createState() => _ProgressTaskListScreenState();
}

class _ProgressTaskListScreenState extends State<ProgressTaskListScreen> {
  bool _getProgressTaskListInProgress = false;
  ProgressTaskListByStatusModel? progressTaskListByStatusModel;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _progressNewTaskList();
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
              _getProgressTaskListInProgress
                  ? Center(child: CircularProgressIndicator())
                  : ListView.builder(
                shrinkWrap: true,
                itemCount: progressTaskListByStatusModel?.progressTaskModelList?.length ??
                    0,
                itemBuilder: (context, index) {
                  return TaskItem(
                    taskModel: progressTaskListByStatusModel!
                        .progressTaskModelList![index],
                    refreshList: () {
                      _progressNewTaskList();
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





  Future<void> _progressNewTaskList() async {
    _getProgressTaskListInProgress = true;
    setState(() {});
    final NetworkResponse response = await NetworkCaller.getRequest(
        url: Urls.progressTaskListByStatus('Progress'));

    if (response.isSuccess) {
      progressTaskListByStatusModel =
          ProgressTaskListByStatusModel.fromJson(response.responseBody!);
    }
    else {
      showSnakeBarMessage(context, response.errorMessage);
    }
    _getProgressTaskListInProgress = false;
    setState(() {});
  }


}

