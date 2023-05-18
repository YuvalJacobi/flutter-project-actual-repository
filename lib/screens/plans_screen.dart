import 'package:flutter/material.dart';

void main() {
  runApp(ExercisePlanApp());
}

class ExercisePlanApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Exercise Plans',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: ExercisePlanScreen(),
    );
  }
}

class ExercisePlanScreen extends StatefulWidget {
  @override
  _ExercisePlanScreenState createState() => _ExercisePlanScreenState();
}

class _ExercisePlanScreenState extends State<ExercisePlanScreen> {
  List<String> exercisePlans = [];

  void addExercisePlan() {
    setState(() {
      exercisePlans.add('Plan #${exercisePlans.length + 1}');
    });
  }

  void startExercisePlan(int index) {
    // Logic to start the exercise plan
    print('Starting plan: ${exercisePlans[index]}');
  }

  void editExercisePlan(int index) {
    // Logic to edit the exercise plan
    print('Editing plan: ${exercisePlans[index]}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Exercise Plans'),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(10),
            child: ElevatedButton(
              onPressed: addExercisePlan,
              child: Text('Add Plan'),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: exercisePlans.length,
              itemBuilder: (context, index) {
                return ExercisePlanItem(
                  name: exercisePlans[index],
                  onStartPressed: () => startExercisePlan(index),
                  onEditPressed: () => editExercisePlan(index),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ExercisePlanScreenState extends State<ExercisePlanScreen> {
  List<Exercise> exercisePlans = [
    Exercise(name: "Bench", sets: 3, reps: 8, weight: 80, rest: 0, isAction: true),
    Exercise(name: "", sets: 0, reps: 0, weight: 0, rest: 90, isAction: false),
    Exercise(name: "Lateral Raise", sets: 3, reps: 10, weight: 10, rest: 0, isAction: true),
  ];

  void addExercisePlan() {
    setState(() {
      exercisePlans.add(
        Exercise(name: "", sets: 0, reps: 0, weight: 0, rest: 0, isAction: false),
      );
    });
  }

  void startExercisePlan(int index) {
    // Logic to start the exercise plan
    print('Starting plan: ${exercisePlans[index].name}');
  }

  void editExercisePlan(int index) {
    // Redirect to EditScreen with the corresponding Exercise
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditScreen(exercise: exercisePlans[index]),
      ),
    );
  }

  void deleteExercisePlan(int index) {
    setState(() {
      exercisePlans.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Exercise Plans'),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(10),
            child: ElevatedButton(
              onPressed: addExercisePlan,
              child: Text('Add Plan'),
            ),
          ),
          ElevatedButton(
            onPressed: () => startExercisePlan(0), // Placeholder for play button
            child: Text('Play'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: exercisePlans.length,
              itemBuilder: (context, index) {
                final exercise = exercisePlans[index];
                return ExercisePlanItem(
                  exercise: exercise,
                  onEditPressed: () => editExercisePlan(index),
                  onDeletePressed: () => deleteExercisePlan(index),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ExercisePlanItem extends StatelessWidget {
  final String name;
  final VoidCallback onStartPressed;
  final VoidCallback onEditPressed;

  const ExercisePlanItem({
    required this.name,
    required this.onStartPressed,
    required this.onEditPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(name),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: onStartPressed,
              icon: Icon(Icons.play_arrow),
            ),
            IconButton(
              onPressed: onEditPressed,
              icon: Icon(Icons.edit),
            ),
          ],
        ),
      ),
    );
  }
}
