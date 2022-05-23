import 'package:flutter/material.dart';
import 'package:groceries_list/databaseHelper.dart';
import 'package:groceries_list/grocery.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: GrociresScreen(),
    );
  }
}

class GrociresScreen extends StatefulWidget {
  const GrociresScreen({Key? key}) : super(key: key);

  @override
  State<GrociresScreen> createState() => _GrociresScreenState();
}

class _GrociresScreenState extends State<GrociresScreen> {

  TextEditingController groceryController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: groceryController,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: FutureBuilder(
        future: DatabaseHelper.instance.getGroceries(),
        builder: (context, AsyncSnapshot<List<Grocery>> snapshot) {
          if (snapshot.hasData) {
            return snapshot.data!.isEmpty
                ? const Center(
                    child: Text("No groceries found!"),
                  )
                : ListView.builder(
                    itemBuilder: (_, index) => ListTile(
                      title: Text(snapshot.data![index].name),
                      onLongPress: () {
                        DatabaseHelper.instance.remove(snapshot.data![index].id!.toInt());
                        setState(() {});
                      },
                      onTap: () {
                        if (groceryController.text.isNotEmpty) {
                          DatabaseHelper.instance.update(Grocery(id: snapshot.data![index].id,name: groceryController.text));
                          setState(() {});
                          groceryController.clear();
                        }
                      },
                    ),
                    itemCount: snapshot.data?.length,
                  );
          }
          return const  CircularProgressIndicator();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (groceryController.text.isNotEmpty) {
            DatabaseHelper.instance.add(Grocery(name: groceryController.text));
            groceryController.clear();
            setState(() {});
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
