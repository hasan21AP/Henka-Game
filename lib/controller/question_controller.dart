import 'package:get/get.dart';

class QuestionController extends GetxController {}

class QuestionControllerImpl extends QuestionController {
  final String question;
  final int points;
  final String category;

  QuestionControllerImpl(
      {required this.question, required this.points, required this.category});
}
