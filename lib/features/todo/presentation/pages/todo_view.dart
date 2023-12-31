import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/enums/data_states.dart';
import '../../../../core/injection/injection.dart';
import '../bloc/todo_bloc.dart';
import '../../domain/entities/todo_entity.dart';
import '../../domain/entities/todos_view_filter.dart';

class TodoBlocProviderWrapper extends StatelessWidget {
  const TodoBlocProviderWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<TodoBloc>(),
      child: TodoView(),
    );
  }
}

class TodoView extends StatefulWidget {
  const TodoView({super.key});

  @override
  State<TodoView> createState() => _TodoViewState();
}

class _TodoViewState extends State<TodoView> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  final TextEditingController titleController = TextEditingController();
  final TextEditingController subtitleController = TextEditingController();

  final TextEditingController titleDetailController = TextEditingController();
  final TextEditingController subtitleDetailController =
      TextEditingController();

  @override
  void dispose() {
    titleController.dispose();
    subtitleController.dispose();
    titleDetailController.dispose();
    subtitleDetailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        // if todo is deleted show snackbar
        BlocListener<TodoBloc, TodoState>(
          listenWhen: (previous, current) =>
              previous.todos.length < current.todos.length,
          listener: (context, state) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.blue,
                ),
              );
          },
        ),

        // if todo is added show snackbar
        BlocListener<TodoBloc, TodoState>(
          listenWhen: (previous, current) =>
              previous.todos.length > current.todos.length,
          listener: (context, state) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
          },
        ),

        // if todo is failed show snackbar
        BlocListener<TodoBloc, TodoState>(
          listener: (context, state) {
            if (state.status == DataStates.failure) {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: Colors.red,
                  ),
                );
            }
          },
        ),

        // if the filter display changes show the snackbar
        BlocListener<TodoBloc, TodoState>(
          listenWhen: (previous, current) => previous.filter != current.filter,
          listener: (context, state) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.blue,
                ),
              );
          },
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Icon(Icons.chevron_left)),
          title: const Text('Todo BLoC'),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () =>
                  context.read<TodoBloc>().add(TodoEventGet(limit: 4)),
              icon: Icon(Icons.cloud_download_rounded),
            ),
          ],
        ),
        floatingActionButton: _buildFAB(),
        body: Column(
          children: [
            _buildFilter(),
            _buildTodos(),
            _buildLoadingEventChange(),
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
                                id: (Random().nextDouble() * 100).floor(),
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
              case DataStates.failure:
                return Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Center(
                    child: Text(
                      state.message,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                );
              default:
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Center(
                    child: Text(
                      state.message,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                );
            }
          }

          return Flexible(
            child: ListView.separated(
                padding: const EdgeInsets.only(bottom: 24),
                shrinkWrap: true,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 16),
                itemCount: state.filteredTodos.length,
                itemBuilder: (context, index) {
                  TodoEntity todo = state.filteredTodos.elementAt(index);
                  return GestureDetector(
                    onTap: () => onTapTodo(index: index, todo: todo),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: ListTile(
                        title: Text(
                          todo.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color:
                                todo.isCompleted ? Colors.blue : Colors.black,
                            decoration: todo.isCompleted
                                ? TextDecoration.lineThrough
                                : null,
                          ),
                        ),
                        subtitle: Text(
                          todo.subtitle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color:
                                todo.isCompleted ? Colors.blue : Colors.black,
                            decoration: todo.isCompleted
                                ? TextDecoration.lineThrough
                                : null,
                          ),
                        ),
                        dense: true,
                        leading: SizedBox(
                          width: 26,
                          child: Checkbox(
                            value: todo.isCompleted,
                            onChanged: (value) {
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

  Widget _buildLoadingEventChange() {
    return BlocBuilder<TodoBloc, TodoState>(
      builder: (context, state) {
        if (state.status == DataStates.failure && state.todos.isNotEmpty)
          return Padding(
            padding: const EdgeInsets.all(24.0),
            child: Center(
              child: Text(
                state.message,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          );

        if (state.status == DataStates.loading && state.todos.isNotEmpty)
          return Padding(
            padding: const EdgeInsets.all(24.0),
            child: const Center(
              child: CircularProgressIndicator.adaptive(),
            ),
          );

        return SizedBox();
      },
    );
  }

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

  void onTapTodo({required int index, required TodoEntity todo}) async {
    titleDetailController.text = todo.title;
    subtitleDetailController.text = todo.subtitle;

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) => Padding(
        padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: titleDetailController,
              style: TextStyle(
                fontSize: 34,
                fontWeight: FontWeight.w600,
              ),
              decoration: InputDecoration(
                isCollapsed: true,
                border: InputBorder.none,
              ),
            ),
            SizedBox(height: 6),
            Divider(
              thickness: 2,
              color: Colors.grey,
            ),
            SizedBox(height: 16),
            Expanded(
              child: TextFormField(
                controller: subtitleDetailController,
                style: TextStyle(
                  fontSize: 16,
                ),
                decoration: InputDecoration(
                  isCollapsed: true,
                  border: InputBorder.none,
                ),
                maxLines: null,
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 16, bottom: 24),
              width: double.infinity,
              child: Material(
                color: Colors.blue,
                elevation: 4,
                borderRadius: BorderRadius.circular(12),
                clipBehavior: Clip.antiAlias,
                child: InkWell(
                  onTap: () {
                    context.read<TodoBloc>().add(
                          TodoEventUpdate(
                            index: index,
                            title: titleDetailController.text,
                            subtitle: subtitleDetailController.text,
                          ),
                        );

                    Navigator.pop(context);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(
                      'Update',
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
  }
}
