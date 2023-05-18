import 'package:flutter/material.dart';

class ExercisePlanItem extends StatelessWidget {
  final Exercise exercise;
  final VoidCallback onEditPressed;
  final VoidCallback onDeletePressed;

  const ExercisePlanItem({
    required this.exercise,
    required this.onEditPressed,
    required this.onDeletePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  exercise.name.isNotEmpty ? exercise.name : 'Unnamed Exercise',
                  style: TextStyle(fontSize: 18),
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: onEditPressed,
                      icon: Icon(Icons.edit),
                    ),
                    IconButton(
                      onPressed: onDeletePressed,
                      icon: Icon(Icons.delete),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 10),
            Text('Sets: ${exercise.sets}'),
            Text('Reps: ${exercise.reps}'),
            Text('Weight: ${exercise.weight} kg'),
            if (exercise.isAction)
              Text('Rest: ${exercise.rest} seconds'),
            if (!exercise.isAction)
              Text('Rest Block'),
          ],
        ),
      ),
    );
  }
}
