import 'dart:math';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skin_muse/features/quiz/presentation/view_model.dart/quiz_model.dart';
import 'quiz_event.dart';
import 'quiz_state.dart';


class QuizBloc extends Bloc<QuizEvent, QuizState> {
  QuizBloc() : super(QuizState(questions: _initialQuestions)) {
    on<QuizStarted>(_onStarted);
    on<OptionSelected>(_onOptionSelected);
    on<QuizNextPressed>(_onNext);
    on<QuizBackPressed>(_onBack);
  }

  static final List<Question> _initialQuestions = [
    Question(
      question: "How does your skin usually feel a few hours after washing it?",
      options: [
        "Tight or rough",
        "Shiny or greasy",
        "Shiny in T-zone, dry on cheeks",
        "Comfortable and balanced",
        "Itchy, red, or easily irritated",
      ],
    ),
    Question(
      question: "How often does your skin feel oily?",
      options: ["Rarely", "Sometimes", "Often", "Almost always"],
    ),
    Question(
      question: "How does your skin react to the sun?",
      options: [
        "Burns easily",
        "Tans gradually",
        "Rarely burns or tans",
        "Not sure",
      ],
    ),
    Question(
      question: "How sensitive is your skin to skincare products?",
      options: [
        "Very sensitive, reacts easily",
        "Somewhat sensitive",
        "Not sensitive at all",
        "Unsure",
      ],
    ),
    Question(
      question: "How would you describe your skin's overall texture?",
      options: [
        "Rough or flaky",
        "Oily and smooth",
        "Combination (varies by area)",
        "Soft and even",
        "Red or irritated",
      ],
    ),
  ];

  void _onStarted(QuizStarted event, Emitter<QuizState> emit) {
    emit(QuizState(questions: _initialQuestions));
  }

  void _onOptionSelected(OptionSelected event, Emitter<QuizState> emit) {
    emit(state.copyWith(selectedOption: event.option));
  }

  void _onNext(QuizNextPressed event, Emitter<QuizState> emit) {
    final selected = state.selectedOption;
    if (selected == null) return;

    final updatedAnswers = List<String>.from(state.answers)..add(selected);

    if (state.currentIndex == state.questions.length - 1) {
      final skinType = _calculateSkinType(updatedAnswers);
      emit(state.copyWith(result: skinType, answers: updatedAnswers));
    } else {
      emit(
        state.copyWith(
          currentIndex: state.currentIndex + 1,
          answers: updatedAnswers,
          selectedOption: null,
        ),
      );
    }
  }

  void _onBack(QuizBackPressed event, Emitter<QuizState> emit) {
    if (state.currentIndex == 0) return;

    final updatedAnswers = List<String>.from(state.answers)..removeLast();
    emit(
      state.copyWith(
        currentIndex: state.currentIndex - 1,
        answers: updatedAnswers,
        selectedOption: null,
        result: null,
      ),
    );
  }

  String _calculateSkinType(List<String> answers) {
    Map<String, int> score = {
      "Dry": 0,
      "Oily": 0,
      "Combination": 0,
      "Normal": 0,
      "Sensitive": 0,
    };

    for (var answer in answers) {
      if (answer.contains("Tight") ||
          answer.contains("Rough") ||
          answer == "Rarely" ||
          answer == "Rough or flaky") {
        score["Dry"] = score["Dry"]! + 1;
      }
      if (answer.contains("greasy") ||
          answer == "Often" ||
          answer == "Almost always" ||
          answer == "Oily and smooth") {
        score["Oily"] = score["Oily"]! + 1;
      }
      if (answer.contains("T-zone") ||
          answer == "Sometimes" ||
          answer == "Combination (varies by area)") {
        score["Combination"] = score["Combination"]! + 1;
      }
      if (answer.contains("balanced") ||
          answer == "Tans gradually" ||
          answer == "Not sensitive at all" ||
          answer == "Soft and even" ||
          answer == "Rarely burns or tans") {
        score["Normal"] = score["Normal"]! + 1;
      }
      if (answer.contains("irritated") ||
          answer.contains("sensitive") ||
          answer == "Burns easily" ||
          answer == "Red or irritated") {
        score["Sensitive"] = score["Sensitive"]! + 1;
      }
    }

    var sorted =
        score.entries.toList()..sort((a, b) => b.value.compareTo(a.value));
    return sorted.first.key;
  }
}
