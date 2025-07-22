import 'package:skin_muse/features/quiz/presentation/view_model.dart/quiz_model.dart';


class QuizState {
  final List<Question> questions;
  final int currentIndex;
  final List<String> answers;
  final String? selectedOption;
  final String? result;

  QuizState({
    required this.questions,
    this.currentIndex = 0,
    this.answers = const [],
    this.selectedOption,
    this.result,
  });

  bool get isFinished => result != null;

  Question get currentQuestion => questions[currentIndex];

  QuizState copyWith({
    List<Question>? questions,
    int? currentIndex,
    List<String>? answers,
    String? selectedOption,
    String? result,
  }) {
    return QuizState(
      questions: questions ?? this.questions,
      currentIndex: currentIndex ?? this.currentIndex,
      answers: answers ?? this.answers,
      selectedOption: selectedOption,
      result: result,
    );
  }
}
