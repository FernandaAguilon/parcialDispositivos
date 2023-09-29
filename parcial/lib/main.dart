import 'package:flutter/material.dart';

void main() {
  runApp(TodoApp());
}

class TodoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lista de Tareas Luisa Fernanda García Aguilón ',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: TodoListScreen(),
    );
  }
}

class TodoListScreen extends StatefulWidget {
  @override
  _TodoListScreenState createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  List<TodoItem> todoList = [];

  void addTodoItem(String title, String description) {
    setState(() {
      todoList.add(TodoItem(title: title, description: description));
    });
  }

  void toggleTodoItem(int index) {
    setState(() {
      todoList[index].isCompleted = !todoList[index].isCompleted;
    });
  }

  void editTodoItem(int index, String newTitle, String newDescription) {
    setState(() {
      todoList[index].title = newTitle;
      todoList[index].description = newDescription;
    });
  }

  void deleteTodoItem(int index) {
    setState(() {
      todoList.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Tareas'),
      ),
      body: ListView.builder(
        itemCount: todoList.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(todoList[index].title),
            subtitle: Text(todoList[index].description),
            trailing: Checkbox(
              value: todoList[index].isCompleted,
              onChanged: (value) {
                toggleTodoItem(index);
              },
            ),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) {
                  return EditTodoDialog(
                    initialTitle: todoList[index].title,
                    initialDescription: todoList[index].description,
                    onEditTodo: (newTitle, newDescription) {
                      editTodoItem(index, newTitle, newDescription);
                    },
                    onDeleteTodo: () {
                      deleteTodoItem(index);
                    },
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AddTodoDialog(
                onAddTodo: addTodoItem,
              );
            },
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class TodoItem {
  String title;
  String description;
  bool isCompleted;

  TodoItem({required this.title, required this.description, this.isCompleted = false});
}

class AddTodoDialog extends StatefulWidget {
  final Function(String, String) onAddTodo;

  AddTodoDialog({required this.onAddTodo});

  @override
  _AddTodoDialogState createState() => _AddTodoDialogState();
}

class _AddTodoDialogState extends State<AddTodoDialog> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _descriptionController = TextEditingController();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Agregar'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _titleController,
            decoration: InputDecoration(
              labelText: 'Titulo',
            ),
          ),
          TextField(
            controller: _descriptionController,
            decoration: InputDecoration(
              labelText: 'Descripción ',
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: () {
            String title = _titleController.text;
            String description = _descriptionController.text;
            widget.onAddTodo(title, description);
            Navigator.of(context).pop();
          },
          child: Text('Agregar'),
        ),
      ],
    );
  }
}

class EditTodoDialog extends StatefulWidget {
  final String initialTitle;
  final String initialDescription;
  final Function(String, String) onEditTodo;
  final Function onDeleteTodo;

  EditTodoDialog({
    required this.initialTitle,
    required this.initialDescription,
    required this.onEditTodo,
    required this.onDeleteTodo,
  });

  @override
  _EditTodoDialogState createState() => _EditTodoDialogState();
}

class _EditTodoDialogState extends State<EditTodoDialog> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.initialTitle);
    _descriptionController = TextEditingController(text: widget.initialDescription);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Edit Todo'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _titleController,
            decoration: InputDecoration(
              labelText: 'Title',
            ),
          ),
          TextField(
            controller: _descriptionController,
            decoration: InputDecoration(
              labelText: 'Description',
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            widget.onDeleteTodo();
            Navigator.of(context).pop();
          },
          child: Text('Delete'),
        ),
        TextButton(
          onPressed: () {
            String newTitle = _titleController.text;
            String newDescription = _descriptionController.text;
            widget.onEditTodo(newTitle, newDescription);
            Navigator.of(context).pop();
          },
          child: Text('Save'),
        ),
      ],
    );
  }
}

