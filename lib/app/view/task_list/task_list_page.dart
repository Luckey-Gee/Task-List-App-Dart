  import 'package:flutter/material.dart';
  import 'package:lista/app/model/task.dart';
  import 'package:lista/app/view/components/h1.dart';
  import 'package:lista/app/view/task_list/task_provider.dart';
  import 'package:provider/provider.dart';
  import 'package:intl/intl.dart';



  class TaskListPage extends StatelessWidget {
    const TaskListPage({Key? key}) : super(key: key);
  
  
  
    @override
    Widget build(BuildContext context) {
      return ChangeNotifierProvider(
        create: (_) => TaskProvider()..fetchTasks(),
        child: Scaffold(
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              _Header(),
              Expanded(child: _TaskList()),
          ],
          ),
          floatingActionButton: Builder(
            builder: (context) => FloatingActionButton(
              onPressed: () => _showNewTaskModal(context),
              child: const Icon(Icons.add, size: 50),
            ),
          ),
        ),
      );
    }
  
    void _showNewTaskModal(BuildContext context) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (_) => ChangeNotifierProvider.value(
          value: context.read<TaskProvider>(),
          child: const _NewTaskModal(),
        ),
      );
    }
  }
  
  class _NewTaskModal extends StatefulWidget {
    const _NewTaskModal({Key? key}) : super(key: key);
  
    @override
    _NewTaskModalState createState() => _NewTaskModalState();
  }
  
  class _NewTaskModalState extends State<_NewTaskModal> {
    final _controller = TextEditingController();
    DateTime? _selectedDateTime;
  
    void _selectDateTime() async {
      DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(2100),
      );
  
      if (pickedDate != null) {
        TimeOfDay? pickedTime = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.now(),
        );
  
        setState(() {
          if (pickedTime != null) {
            _selectedDateTime = DateTime(
              pickedDate.year,
              pickedDate.month,
              pickedDate.day,
              pickedTime.hour,
              pickedTime.minute,
            );
          } else {
            _selectedDateTime = DateTime(
              pickedDate.year,
              pickedDate.month,
              pickedDate.day,
            );
          }
        });
      }
    }


    @override
    Widget build(BuildContext context) {
      return SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 33,
            vertical: 23,
          ),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.vertical(top: Radius.circular(21)),
            color: Colors.white,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const H1('New Task'),
              const SizedBox(height: 26),
              TextField(
                controller: _controller,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
              const SizedBox(height: 26),
              ElevatedButton(
                onPressed: () async {
                  if (_controller.text.isNotEmpty) {
                    final task = Task(_controller.text, reminder: _selectedDateTime);
                    context.read<TaskProvider>().addNewTask(task);
                    Navigator.of(context).pop();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Please enter a title!"),
                      ),
                    );
                  }
                },
                child: const Text('Save'),
              ),
              TextButton(
                onPressed: _selectDateTime,
                child: Text(
                  _selectedDateTime != null
                      ? 'Reminder: ${DateFormat('yyyy-MM-dd HH:mm').format(_selectedDateTime!)}'
                      : 'Set Reminder',
                ),
              ),
            ],
          ),
        ),
      );
    }

  // ...
    }
  
  
  class _TaskList extends StatelessWidget {
    const _TaskList({
      Key? key,
    }) : super(key: key);
  
    @override
    Widget build(BuildContext context) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const H1('Things To Do...'),
            Expanded(
              child: Consumer<TaskProvider>(
                builder: (_, provider, __) {
                  if (provider.taskList.isEmpty){
                    return const Center(
                      child: Text('Nothing To Do Today :)'),
                    );
                  }
                  return  ListView.separated(
                    itemCount: provider.taskList.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 16),
                    itemBuilder: (_, index) => _TaskItem(
                      provider.taskList[index],
                      onTap: ()=> provider.onTaskDoneChange(provider.taskList[index]),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      );
    }
  }
  
  class _Header extends StatelessWidget {
    const _Header({
      Key? key,
    }) : super(key: key);
  
    @override
    Widget build(BuildContext context) {
      return Container(
        width: double.infinity,
        color: Theme.of(context).colorScheme.primary,
        child: Stack(
          children: [
            Column(
              children: [
                const SizedBox(height: 100),
                Center(
                  child: Image.asset(
                    'assets/images/3.png',
                    width: 180,
                    height: 180,
                  ),
                ),
                const SizedBox(height: 16),
                const SizedBox(height: 24)
              ],
            )
          ],
        ),
      );
    }
  }
  
  class _TaskItem extends StatefulWidget {
    const _TaskItem(this.task, {Key? key, this.onTap}) : super(key: key);
  
    final Task task;
    final VoidCallback? onTap;
  
    @override
    _TaskItemState createState() => _TaskItemState();
  }
  
  class _TaskItemState extends State<_TaskItem> {
    bool _isRemoved = false;
  
    @override
    Widget build(BuildContext context) {
      if (_isRemoved) {
        // If the task has been removed, return an empty container to hide it.
        return Container();
      }
  
      return GestureDetector(
        onTap: () {
          // Update the flag to mark the task as removed.
          setState(() {
            _isRemoved = true;
          });
  
          // Schedule the task removal after two seconds.
          Future.delayed(const Duration(seconds: 5), () {
            context.read<TaskProvider>().removeCompletedTasks();
          });
        },
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(21),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 21, vertical: 18),
            child: Row(
              children: [
                Icon(
                  widget.task.done ? Icons.check_box_rounded : Icons.check_box_outline_blank,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 10),
                Text(
                  widget.task.title,
                  style: TextStyle(
                    decoration: widget.task.done ? TextDecoration.lineThrough : null,
                  ),
                ),
                const Spacer(),
                if (widget.task.reminder != null)
                  Text(
                    '${DateFormat('yyyy-MM-dd HH:mm').format(widget.task.reminder!)}',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
              ],
            ),
          ),
        ),
      );
    }
  }
//<a href="https://www.flaticon.com/free-icons/things-to-do" title="things to do icons">Things to do icons created by Freepik - Flaticon</a>

