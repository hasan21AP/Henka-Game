import 'dart:developer';

import 'package:henka_game/data/database.dart';
import 'package:henka_game/data/models/questons_model.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseService {
  // ✅ **جلب الأسئلة مع تمرير `tableName` ليتم تعيينه كـ `category`**
  static Future<List<QuestionModel>> getQuestionsByCategory(
      String tableName) async {
    final Database db = await DatabaseHelper.database;

    log("🛢️ Fetching data from table: $tableName");

    List<Map<String, dynamic>> maps = await db.query(tableName);

    if (maps.isEmpty) {
      log("⚠️ WARNING: No data found in table: $tableName");
    }

    List<QuestionModel> questions = maps.map((q) {
      log("📝 Question Data: $q");
      return QuestionModel.fromMap(q, tableName);
    }).toList();

    log("✅ Questions loaded from $tableName: ${questions.length}");

    return questions;
  }
}
