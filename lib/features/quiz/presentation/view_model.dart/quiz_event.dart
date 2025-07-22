abstract class QuizEvent {}

class QuizStarted extends QuizEvent {}

class OptionSelected extends QuizEvent {
  final String option;

  OptionSelected(this.option);
}

class QuizNextPressed extends QuizEvent {}

class QuizBackPressed extends QuizEvent {}
