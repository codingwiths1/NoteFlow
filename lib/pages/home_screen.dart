import 'package:note/pages/colors.dart';
import 'package:note/pages/database.dart';
import 'package:hive_flutter/hive_flutter.dart';
import "package:flutter/material.dart";

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final box = Hive.box('Storage');

  //Object of class DataBase
  final db = DataBase();

  // controller Object
  final controller = TextEditingController();

  // Search todolist
  List searchTodolist = [];

  //InitState
  @override
  void initState() {
    super.initState();
    if (db.box.get('key') == null) {
      db.firstUse();
    } else {
      db.loadData();
    }
    searchTodolist = db.todolist;
  }

  //The function
  void searching(query) {
    setState(() {
      if (query.isNotEmpty) {
        searchTodolist = db.todolist
            .where(
                (item) => item[0].toLowerCase().contains(query.toLowerCase()))
            .toList();
      } else {
        searchTodolist = db.todolist;
      }
    });
  }

// ListTile onTap Function
  void onTap(index) {
    setState(() {
      db.todolist[index][1] = !db.todolist[index][1];
      db.updateData();
    });
  }

// Delete Tasks Button
  void deleteTask(index) {
    setState(() {
      db.todolist.removeAt(index);
      db.updateData();
    });
  }

  // Add Tasks Button
  void addTask() {
    setState(() {
      if (controller.text.isNotEmpty) {
        db.todolist.insert(0, [controller.text, false]);
      } else {
        controller.text = null.toString();
      }
      controller.clear();
      db.updateData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: tdBgColor,
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(193),
          child: Container(
            padding: const EdgeInsets.only(left: 15, right: 15, top: 30),
            height: 193,
            decoration: BoxDecoration(color: tdBgColor),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Icon(
                      Icons.menu,
                      color: tdBlack,
                      size: 30,
                    ),
                    const SizedBox(
                        width: 40,
                        height: 40,
                        child: CircleAvatar(
                          backgroundImage: AssetImage('assets/images/fd.png'),
                        )),
                  ],
                ),
                Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20)),
                  margin: const EdgeInsets.only(
                      top: 25, left: 15, right: 15, bottom: 50),
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Row(
                    children: [
                      const Icon(Icons.search, size: 30),
                      const SizedBox(width: 5),
                      Expanded(
                        child: TextField(
                          onChanged: searching,
                          style: const TextStyle(
                              decorationColor: tdBlue, decorationThickness: 2),
                          cursorColor: tdBlue,
                          decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: 'search...',
                              hintStyle: TextStyle(color: tdGrey)),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )),
      drawer: Drawer(
        child: Text("hi"),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 15, right: 15, bottom: 80),
        child: ListView(
          children: [
            Container(
              decoration: const BoxDecoration(color: tdBgColor),
              child: const Padding(
                padding: EdgeInsets.only(bottom: 15),
                child: Text(
                  'All ToDos',
                  style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: searchTodolist.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: ListTile(
                      trailing: Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                            color: Colors.red[600],
                            borderRadius: BorderRadius.circular(10)),
                        child: IconButton(
                            onPressed: () => deleteTask(index),
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.white,
                            )),
                      ),
                      contentPadding: const EdgeInsets.all(5),
                      onTap: () => onTap(index),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      leading: Icon(
                          size: 25,
                          db.todolist[index][1]
                              ? Icons.check_box
                              : Icons.check_box_outline_blank),
                      title: Text(
                        searchTodolist[index][0],
                        style: TextStyle(
                            color: tdBlack,
                            fontWeight: FontWeight.w500,
                            fontSize: 22,
                            decoration: db.todolist[index][1]
                                ? TextDecoration.lineThrough
                                : TextDecoration.none,
                            decorationThickness: 2,
                            decorationColor: Colors.black),
                      ),
                      tileColor: Colors.white,
                    ),
                  );
                }),
          ],
        ),
      ),
      floatingActionButton: Row(
        children: [
          Expanded(
              child: Container(
            margin: const EdgeInsets.only(right: 15, left: 25),
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
                boxShadow: const [BoxShadow(color: tdGrey, blurRadius: 5)]),
            child: TextField(
              controller: controller,
              cursorColor: tdBlue,
              style: const TextStyle(
                  decorationColor: tdBlue,
                  fontSize: 22,
                  fontWeight: FontWeight.w500),
              decoration: const InputDecoration(
                hintText: 'Add new todo item',
                hintStyle: TextStyle(color: Colors.black38, fontSize: 19),
                border: InputBorder.none,
              ),
            ),
          )),
          FloatingActionButton(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
            onPressed: addTask,
            child: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}
