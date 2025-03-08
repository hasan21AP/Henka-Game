import 'dart:async';
import 'dart:developer';
import 'package:get/get.dart';

class QuestionController extends GetxController {}

class QuestionControllerImpl extends QuestionController {
  late final String question;
  late final String answer;
  late final int points;
  late final String category;
  late final double answerTime;

  RxBool showAnswer = false.obs; // ✅ تحكم في إظهار الإجابة
  RxInt remainingTime = 0.obs; // ✅ الوقت المتبقي
  RxBool isTeamOneTurn = true.obs; // ✅ دور الفريق الأول أم الثاني
  Timer? _timer;

  QuestionControllerImpl({
    required this.question,
    required this.points,
    required this.category,
    required this.answerTime,
    required this.answer,
  });

  @override
  void onInit() {
    super.onInit();
    log("Question: $question");
    log("Answer: $answer");
    log("Points: $points");
    log("Category: $category");
    log("Answer Time: $answerTime");

    _startTimer(); // ✅ بدء المؤقت عند فتح الصفحة
  }

  void _startTimer() {
    remainingTime.value = answerTime.toInt();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (remainingTime.value > 0) {
        remainingTime.value--;
      } else {
        timer.cancel();
        _startTeamTwoTimer(); // ✅ بعد انتهاء الفريق الأول، يبدأ مؤقت الفريق الثاني
      }
    });
  }

  void _startTeamTwoTimer() {
    isTeamOneTurn.value = false;
    remainingTime.value = (answerTime / 2).toInt();

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (remainingTime.value > 0) {
        remainingTime.value--;
      } else {
        timer.cancel();
      }
    });
  }

  void toggleAnswer() {
    showAnswer.value = !showAnswer.value;
  }

  void stopTimer() {
    _timer?.cancel();
  }

  @override
  void onClose() {
    stopTimer();
    super.onClose();
  }
}
