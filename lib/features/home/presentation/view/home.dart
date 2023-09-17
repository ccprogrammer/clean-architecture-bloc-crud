import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../enums/data_states.dart';
import '../../presentation/bloc/todo_bloc.dart';
import '../../domain/entities/todo_entity.dart';
import '../../domain/entities/todos_view_filter.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  final TextEditingController titleController = TextEditingController();
  final TextEditingController subtitleController = TextEditingController();

  @override
  void dispose() {
    titleController.dispose();
    subtitleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<TodoBloc, TodoState>(
          listenWhen: (previous, current) =>
              previous.todos.length < current.todos.length,
          listener: (context, state) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text('Todo Added'),
                  backgroundColor: Colors.blue,
                ),
              );
          },
        ),
        BlocListener<TodoBloc, TodoState>(
          listenWhen: (previous, current) =>
              previous.todos.length > current.todos.length,
          listener: (context, state) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text('Todo Deleted'),
                  backgroundColor: Colors.red,
                ),
              );
          },
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Todo BLoC'),
          centerTitle: true,
        ),
        floatingActionButton: _buildFAB(),
        body: Column(
          children: [
            _buildFilter(),
            _buildTodos(),
          ],
        ),
      ),
    );
  }

  Widget _buildFAB() => FloatingActionButton(
        onPressed: () {
          onTapAdd();
        },
        child: const Icon(Icons.add),
      );

  Widget _buildFormField() => Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the title for todos';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: subtitleController,
                decoration: const InputDecoration(
                  labelText: 'Subtitle',
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the subtitle for todos';
                  }
                  return null;
                },
              ),
              Spacer(),
              Container(
                margin: EdgeInsets.only(top: 16),
                width: double.infinity,
                child: Material(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(12),
                  clipBehavior: Clip.antiAlias,
                  child: InkWell(
                    onTap: () {
                      if (!_formKey.currentState!.validate()) return;

                      context.read<TodoBloc>().add(
                            TodoEventAdd(
                              todo: TodoEntity(
                                id: '${(Random().nextDouble() * 100).floor()}',
                                title: titleController.text,
                                subtitle: subtitleController.text,
                                isCompleted: false,
                              ),
                            ),
                          );

                      titleController.clear();
                      subtitleController.clear();

                      Navigator.pop(context);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text(
                        'Add Todo',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );

  Widget _buildFilter() => BlocBuilder<TodoBloc, TodoState>(
        builder: (context, state) {
          return Align(
            alignment: Alignment.topRight,
            child: Container(
              margin: EdgeInsets.only(right: 16, bottom: 16, top: 24),
              padding: EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blue),
                borderRadius: BorderRadius.circular(999),
              ),
              child: GestureDetector(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      state.filter.text,
                      style: TextStyle(color: Colors.blue),
                    ),
                    SizedBox(width: 8),
                    Icon(Icons.sort, color: Colors.blue),
                  ],
                ),
                onTap: () async => await showDialog(
                  context: context,
                  builder: (context) => Dialog(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        InkWell(
                          onTap: () => onFilterTap(TodosViewFilter.all),
                          child: Container(
                            width: double.infinity,
                            margin: EdgeInsets.symmetric(vertical: 16),
                            child: Text(
                              'All',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: state.filter == TodosViewFilter.all
                                    ? Colors.blue
                                    : Colors.black,
                              ),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () =>
                              onFilterTap(TodosViewFilter.completedOnly),
                          child: Container(
                            width: double.infinity,
                            margin: EdgeInsets.symmetric(vertical: 16),
                            child: Text(
                              'Completed',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: state.filter ==
                                        TodosViewFilter.completedOnly
                                    ? Colors.blue
                                    : Colors.black,
                              ),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () => onFilterTap(TodosViewFilter.activeOnly),
                          child: Container(
                            width: double.infinity,
                            margin: EdgeInsets.symmetric(vertical: 16),
                            child: Text(
                              'Active',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color:
                                    state.filter == TodosViewFilter.activeOnly
                                        ? Colors.blue
                                        : Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      );

  Widget _buildTodos() => BlocBuilder<TodoBloc, TodoState>(
        builder: (context, state) {
          if (state.todos.isEmpty) {
            switch (state.status) {
              case DataStates.initial:
                return Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Center(
                    child: Text(
                      'Add some todos',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                );
              case DataStates.loading:
                return Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: const Center(
                    child: CircularProgressIndicator.adaptive(),
                  ),
                );
              case DataStates.success:
                return Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Center(
                    child: Text(
                      'Todos Empty',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                );
              default:
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Center(
                    child: Text(
                      'Something went wrong!',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                );
            }
          }

          return Expanded(
            child: ListView.separated(
                padding: const EdgeInsets.only(bottom: 24),
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 16),
                itemCount: state.filteredTodos.length,
                itemBuilder: (context, index) {
                  TodoEntity todo = state.filteredTodos.elementAt(index);
                  return GestureDetector(
                    onTap: () => onTapTodo(todo: todo),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: ListTile(
                        title: Text(todo.title),
                        subtitle: Text(todo.subtitle),
                        dense: true,
                        leading: SizedBox(
                          width: 26,
                          child: Checkbox(
                            value: todo.isCompleted,
                            onChanged: (value) {
                              print('value => $value');
                              context.read<TodoBloc>().add(
                                    TodoEventIsCompleted(
                                      index: index,
                                      isCompleted: value!,
                                    ),
                                  );
                            },
                          ),
                        ),
                        horizontalTitleGap: 0,
                        trailing: GestureDetector(
                          onTap: () {
                            context
                                .read<TodoBloc>()
                                .add(TodoEventDelete(todo: todo));
                          },
                          child: const Icon(Icons.delete, color: Colors.red),
                        ),
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(width: 1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                  );
                }),
          );
        },
      );

  // * Event Handler
  void onFilterTap(TodosViewFilter filter) {
    context.read<TodoBloc>().add(TodoEventFilter(filter: filter));
    Navigator.pop(context);
  }

  void onTapAdd() async {
    await showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(12),
        ),
      ),
      builder: (context) => _buildFormField(),
    );
  }

  void onTapTodo({required TodoEntity todo}) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) => Padding(
        padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              todo.title,
              style: TextStyle(
                fontSize: 34,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 6),
            Divider(
              thickness: 2,
              color: Colors.grey,
            ),
            SizedBox(height: 16),
            Text(
              todo.subtitle,
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
