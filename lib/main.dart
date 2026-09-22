import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

enum Level { junior, middle, senior } //вывод enum  i zadavanie 3 urovney
//создание класса
class Student {
  final String name;
  final Level level;
  int points;//поля

  Student({
    required this.name,
    required this.level,
    this.points = 0,
  });

  void addPoints(int value) {
    points += value;//метод
  }

  @override
  String toString() => '$name (${level.name}) — $points очков';
}

extension StudentListText on List<Student> {//extension
  String toText() {
    final buffer = StringBuffer();
    for (var i = 0; i < length; i++) {
      buffer.writeln('${i + 1}. ${this[i]}');
    }//loops
    return buffer.toString().trimRight();
  }
}

T? firstOrNull<T>(List<T> items) {//generic функция, возвращает первый элоемент, T? это возвращаемый тип
  return items.isEmpty ? null : items.first;
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      home: const MyHomePage(title: 'МОАИСбд-31 Кадничанский Максим'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  String _status = 'Загрузка...';

  final List<Student> students = <Student>[//list
    Student(name: 'Vasya', level: Level.junior, points: 160),
    Student(name: 'Olya', level: Level.middle, points: 200),
    Student(name: 'Maxim', level: Level.senior, points: 220),
  ];

  Future<String> loadStatus() async {
    await Future.delayed(const Duration(milliseconds: 600));
    return 'Данные загружены';
  }//использование future, изменяет статус

  @override
  void initState() {
    super.initState();

    loadStatus().then((value) {
      if (!mounted) return;
      setState(() {
        _status = value;
      });
    });
  }

  void _incrementCounter() {
    setState(() {
      _counter++;

      students.forEach((student) {
        if (student.points < 250) {
          student.addPoints(10);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final Student? first = firstOrNull(students);

    final int totalPoints = students.fold<int>(
      0,
          (sum, student) => sum + student.points,//анонимная функция
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Статус: $_status'),
            Text('Счётчик: $_counter'),
            Text('Сумма очков: $totalPoints'),
            if (first != null) Text('Первый студент: $first'),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(students.toText(), textAlign: TextAlign.center),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}