class QuestionModel {
  final int id;
  final String question;
  final String answer;
  final int points;
  final String category; // ✅ نضيفه يدويًا عند استرجاع البيانات

  QuestionModel({
    required this.id,
    required this.question,
    required this.answer,
    required this.points,
    required this.category, // ✅ لا يأتي من الجدول، نضيفه يدويًا
  });

  // ✅ `fromMap` لا يعتمد على `category` من الجدول، بل يستقبلها كمعامل
  factory QuestionModel.fromMap(Map<String, dynamic> json, String category) {
    return QuestionModel(
      id: json["id"],
      question: json["question"],
      answer: json["answer"],
      points: json["points"],
      category: category, // ✅ نمرر `tableName` كقيمة `category`
    );
  }
}
