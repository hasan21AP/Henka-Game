import 'dart:io';
import 'package:flutter/services.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

// ✅ استيراد `sqflite_common_ffi` لتهيئة `databaseFactory` عند التشغيل على سطح المكتب

class DatabaseHelper {
  static Database? _database;

  static const String dbName = "henka.db";

  static Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  static Future<Database> _initDatabase() async {
    // ✅ **تهيئة `databaseFactoryFfi` إذا كنت تعمل على ويندوز أو macOS أو Linux**
    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      databaseFactory = databaseFactoryFfi;
    }

    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, dbName);

    // تحقق مما إذا كانت قاعدة البيانات موجودة بالفعل
    bool dbExists = await databaseExists(path);

    if (!dbExists) {
      ByteData data = await rootBundle.load("assets/database/$dbName");
      List<int> bytes = data.buffer.asUint8List();
      await File(path).writeAsBytes(bytes, flush: true);
    }

    // ✅ فتح قاعدة البيانات باستخدام `databaseFactory`
    return await openDatabase(path, version: 1);
  }
}
