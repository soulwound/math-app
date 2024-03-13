import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:audioplayers/audioplayers.dart';

void main() {
  //player.play(alarmAudioPath);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          alignment: Alignment.center,
          child: const Text('Math App'),
        ),
      ),
      body: const Column(
        children: [
          TaskPage(),
          Statistics()
        ],
      ),
    );
  }
}

// Меню с карточками
class TaskPage extends StatelessWidget {
  const TaskPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Column(
            children: [
              TypeTile("Двухзначные числа", 'simplequestions.png'),
              TypeTile("Трехзначные числа", 'advancedquestions.png'),
            ],
          ),
        ),
        Expanded(
          flex: 1,
          child: Column(
            children: <TypeTile>[
              TypeTile("Умножение и деление", 'multiplying.png'),
              TypeTile("Степени двойки", 'poweroftwo.png'),
            ],
          ),
        ),
      ],
    );
  }
}

// Карточки заданий
class TypeTile extends StatelessWidget {

  final String title;
  final String iconName;

  TypeTile(this.title, this.iconName, {super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.hardEdge,
        child: InkWell(
          splashColor: Colors.deepPurple.withAlpha(30),
          child: Container(
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(vertical: 20.0),
            child: Column(
              children: [
                Image(image: AssetImage('assets/icons/$iconName'),),
                Text(title)
              ],
            ),
          ),
          onTap: () {
            debugPrint("Just tapped!! on tile $title!");
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => QuestionPage(title: title,)),
            );
            },
        ),
    );
  }
}

class Statistics extends StatelessWidget {
  const Statistics({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 30, 0, 0),
      child: Text('Luv u!'),
    );
  }
  
}

class QuestionPage extends StatefulWidget {
  final String title;

  const QuestionPage({required this.title, super.key});

  @override
  State<StatefulWidget> createState() => _QuestionPageState(title);

}

class _QuestionPageState extends State<QuestionPage>{

  String title;
  
  _QuestionPageState(this.title);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: TestScreen(title: title)
    );
  }
}

class TestScreen extends StatefulWidget {
  final String title;

  const TestScreen({required this.title, super.key});

  @override
  State<StatefulWidget> createState() => _TestScreenState(title);

}


class _TestScreenState extends State<TestScreen>{

  String title;
  int answersCount = 0;
  List<dynamic> questionData = [];

  _TestScreenState(this.title);
  final answerController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    questionData = createQuestion(title);
    print(questionData.toString());
    print(answerController.text.runtimeType);
    answerController.text = '';
    if((answersCount < 10) & (questionData[1].toString() != answerController.text)) {
      return Container(
        alignment: Alignment.center,
        child: Column(
          children: [
            Expanded(
              flex: 1,
                child: Center(
                    child: Text(
                        questionData[0],
                      style: TextStyle(fontSize: 40),
                    )
                )
            ),
            Expanded(
              flex: 1,
              child: TextFormField(
                autofocus: false,
                  controller: answerController,
                  onFieldSubmitted: (String value) async {
                    AudioPlayer player = new AudioPlayer();
                    if(value == questionData[1].toString()){
                      await player.setSource(AssetSource('sounds/ben-yes.wav'));
                      await player.resume();
                      setState(() {
                        answersCount += 1;
                      });
                    }
                    else{
                      await player.setSource(AssetSource(['sounds/ho-ho-ho-ben.wav', 'sounds/ben-no.wav'][Random().nextInt(2)]));
                      await player.resume();
                    }
                  },
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      labelText: "Ответ",
                      hintText: "сюда",
                      icon: Icon(Icons.numbers)
                  )
              )
              ),
          ],
        ),
      );
    }
    else{
      return Container(
        alignment: Alignment.center,
        child: FloatingActionButton.extended(
          label: Column(
            children: [
              Text('Ты выполнил 10 заданий по теме $title.'),
              Text('Нажми, чтобы вернуться'),
            ],
          ),
          onPressed: () {
            Navigator.pop(context);
          },
          //child: Text('Ты выполнил 10 заданий по теме $title. Нажми, чтобы вернуться'),
        ),
      );
    }
  }
}

List<dynamic> createQuestion(title) {
  List<dynamic> result = [];
  List<String> operations = ['-', '+', '/', '*'];
  if(title == 'Двухзначные числа'){
    debugPrint('Тут будет вопрос по теме двузначные');
    String operator = operations[Random().nextInt(2)];
    int first = Random().nextInt(201) - 100;
    int second = Random().nextInt(201) - 100;
    result.add('$first $operator $second = ?');
    operator == '-'? result.add(first - second) : result.add(first + second);
    return result;
  }
  else if(title == 'Трехзначные числа'){
    String operator = operations[Random().nextInt(2)];
    int first = Random().nextInt(2001) - 1000;
    int second = Random().nextInt(2001) - 1000;
    result.add('$first $operator $second = ?');
    operator == '-'? result.add(first - second) : result.add(first + second);
    return result;
  }
  else if(title == 'Умножение и деление'){
    String operator = operations[Random().nextInt(2)+2];
    if(operator == '/') {
      int second = Random().nextInt(21);
      int first = second * (Random().nextInt(20) + 1);
      result.add('$first $operator $second = ?');
      result.add(first ~/ second);
    }
    else{
      int first = Random().nextInt(20);
      int second = Random().nextInt(21);
      result.add('$first $operator $second = ?');
      result.add(first * second);
    }
    return result;
  }
  else if(title == 'Степени двойки'){
    int power = Random().nextInt(11);
    result.add('2 в степени $power = ?');
    result.add(pow(2, power));
    return result;

  }

  return [];
}