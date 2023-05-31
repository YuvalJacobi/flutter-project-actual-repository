class Exercise {
  String name;

  String category;

  List<String> active_muscles;

  String level;

  String image_url;

  String user_id;

  String exercise_id;

  Exercise(
      {required this.name,
      required this.category,
      required this.active_muscles,
      required this.level,
      required this.image_url,
      required this.user_id,
      required this.exercise_id});
}