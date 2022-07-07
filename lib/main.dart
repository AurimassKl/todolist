import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'provider/todo_providers.dart';

final todoProvider =
    StateNotifierProvider<TodoProvider, List<Todo>>((ref) => TodoProvider());
void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onPanDown: (_) {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primarySwatch: Colors.green),
        home: const ToDoPage(),
      ),
    );
  }
}

class ToDoPage extends ConsumerWidget {
  const ToDoPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todoList = ref.watch(todoProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text("TODO sąrašas"),
      ),
      body: ListView.builder(
        itemCount: todoList.length,
        itemBuilder: (context, index) {
          final todoItem = todoList[index];
          return Card(
            child: ListTile(
              title: Text(todoItem.content),
              trailing: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  ref.read(todoProvider.notifier).removeTodo(
                        todoItem,
                      );
                },
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: ((context) => const AddPage()),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class AddPage extends ConsumerStatefulWidget {
  const AddPage({Key? key}) : super(key: key);

  @override

  // ignore: library_private_types_in_public_api
  _AddPageState createState() => _AddPageState();
}

class _AddPageState extends ConsumerState<AddPage> {
  @override
  Widget build(BuildContext context) {
    final myController = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pridėti"),
      ),
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(30.0),
          child: Column(
            children: [
              TextField(
                controller: myController,
                maxLines: 5,
                cursorColor: Colors.black,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 30,
                ),
                decoration: InputDecoration(
                  hintStyle: const TextStyle(color: Colors.green),
                  hintText: "Įveskite užduotį",
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(width: 3, color: Colors.green),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(width: 3, color: Colors.red),
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  debugPrint(myController.text);
                  ref.read(todoProvider.notifier).addTodo(
                        myController.text,
                      );
                  Navigator.pop(context);
                },
                child: const Text("Pridėti"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
