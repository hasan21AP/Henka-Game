import 'package:henka_game/core/constants/terms.dart';

String nameEnToAr(String name) {
  switch (name) {
    case "anime_questions":
      return Terms.animeQuestions;
    case "football_questions":
      return Terms.footballQuestions;
    case "history_questions":
      return Terms.historyQuestions;
    case "movies_series_questions":
      return Terms.moviesAndSeriesQuestions;
    case "science_questions":
      return Terms.scienceQuestions;
    case "quran_questions":
      return Terms.quranQuestions;
    case "religious_questions":
      return Terms.religiousQuestions;
    default:
      return "غير معروف";
  }
}
