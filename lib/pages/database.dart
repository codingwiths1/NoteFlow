import 'package:hive_flutter/hive_flutter.dart';

class DataBase {

  final box = Hive.box('storage');

  //todolist
  List todolist = [
    ['Eat Cookies', true],
    ['Buy groceries', false],
  ];

  void firstUse() {
  todolist = [
  ['Eat Cookies', true],
  ['Buy groceries', false],
  ];
  }

  void updateData() {
  box.put('key', todolist);
  }

  void loadData() {
  todolist = box.get('key');
  }
  }

