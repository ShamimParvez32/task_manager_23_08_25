import 'package:flutter/material.dart';
import 'package:task_manager_23_08_25/data/models/cancelled_task_list_model.dart';
import 'package:task_manager_23_08_25/data/models/task_list_By_Status_model.dart';
import 'package:task_manager_23_08_25/data/services/network_caller.dart';
import 'package:task_manager_23_08_25/data/utlis/urls.dart';
import 'package:task_manager_23_08_25/ui/widgets/screen_background.dart';
import 'package:task_manager_23_08_25/ui/widgets/show_snakebar_message.dart';
import 'package:task_manager_23_08_25/ui/widgets/task_item.dart';
import 'package:task_manager_23_08_25/ui/widgets/tm_app_bar.dart';

void main() => runApp(MaterialApp(home: CancelledTaskListScreen()));

class CancelledTaskListScreen extends StatefulWidget {
  const CancelledTaskListScreen({super.key});

  @override
  State<CancelledTaskListScreen> createState() => _CancelledTaskListScreenState();
}

class _CancelledTaskListScreenState extends State<CancelledTaskListScreen> {

  bool _getCancelledTaskListInProgress = false;
  CancelledTaskListByStatusModel? cancelledTaskListByStatusModel;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _cancelledNewTaskList();
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
              _getCancelledTaskListInProgress
                  ? Center(child: CircularProgressIndicator())
                  : ListView.builder(
                shrinkWrap: true,
                itemCount: cancelledTaskListByStatusModel?.cancelledTaskModelList?.length ??
                    0,
                itemBuilder: (context, index) {
                  return TaskItem(
                    taskModel: cancelledTaskListByStatusModel!
                        .cancelledTaskModelList![index],
                    refreshList: () {
                      _cancelledNewTaskList();
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





  Future<void> _cancelledNewTaskList() async {
    _getCancelledTaskListInProgress = true;
    setState(() {});
    final NetworkResponse response = await NetworkCaller.getRequest(
        url: Urls.cancelledTaskListByStatus('Cancelled'));

    if (response.isSuccess) {
      cancelledTaskListByStatusModel =
          CancelledTaskListByStatusModel.fromJson(response.responseBody!);
    }
    else {
      showSnakeBarMessage(context, response.errorMessage);
    }
    _getCancelledTaskListInProgress = false;
    setState(() {});
  }


}

