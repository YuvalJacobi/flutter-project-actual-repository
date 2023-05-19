import 'package:flutter_complete_guide/model/plan.dart';

class UserProfile {
  String first_name;

  String last_name;

  String username;

  String email;

  int age;

  double height;

  double weight;

  List<Plan> plans = [];

  String user_id;

  UserProfile(
      {this.first_name = '',
      this.last_name = '',
      this.username = '',
      this.email = '',
      this.age = -1,
      this.height = -1,
      this.weight = -1,
      required this.plans,
      this.user_id = ''});
}
