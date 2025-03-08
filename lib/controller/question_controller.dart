import 'dart:async';
import 'package:get/get.dart';

class QuestionController extends GetxController {}

class QuestionControllerImpl extends QuestionController {
  late final String question;
  late final String answer;
  late final int points;
  late final String category;
  late final double answerTime;
  late final RxBool isTeamOneTurn;
  late final String teamOneName;
  late final String teamTwoName;

  RxBool showAnswer = false.obs; // ✅ تحكم في إظهار الإجابة
  RxInt remainingTime = 0.obs; // ✅ الوقت المتبقي
  RxString timerText = "".obs; // ✅ النص الذي سيعرض بدلاً من الوقت
  RxBool isTeamOneTime =
      true.obs; // ✅ الفريق الذي يجيب الآن (لا يحدد الدور القادم في GameBody)
  Timer? _timer;

  QuestionControllerImpl({
    required this.question,
    required this.points,
    required this.category,
    required this.answerTime,
    required this.answer,
    required this.isTeamOneTurn,
    required this.teamOneName,
    required this.teamTwoName,
  });

  @override
  void onInit() {
    super.onInit();
    isTeamOneTime.value =
        isTeamOneTurn.value; // ✅ الفريق الذي يجيب الآن هو من اختار البطاقة
    timerText.value =
        "الوقت المتبقي لفريق: ${isTeamOneTime.value ? teamOneName : teamTwoName}";
    _startTimer();
  }

  void _startTimer() {
    remainingTime.value = answerTime.toInt();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (remainingTime.value > 0) {
        remainingTime.value--;
      } else {
        timer.cancel();
        timerText.value =
            "انتهى وقت فريق ${isTeamOneTime.value ? teamOneName : teamTwoName}، بدأ وقت فريق ${!isTeamOneTime.value ? teamOneName : teamTwoName}";
        Future.delayed(Duration(seconds: 2), () {
          _startTeamTwoTimer();
        });
      }
    });
  }

  void _startTeamTwoTimer() {
    isTeamOneTime.value = !isTeamOneTime.value; // ✅ تغيير الفريق الذي يجيب فقط
    remainingTime.value = (answerTime / 2).toInt();
    timerText.value =
        "الوقت المتبقي لفريق: ${isTeamOneTime.value ? teamOneName : teamTwoName}";

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (remainingTime.value > 0) {
        remainingTime.value--;
      } else {
        timer.cancel();
        timerText.value =
            "انتهى وقت فريق ${isTeamOneTime.value ? teamOneName : teamTwoName}";
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
