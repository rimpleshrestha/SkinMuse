class Question {
  final String question;
  final List<String> options;

  Question({required this.question, required this.options});

  factory Question.fromMap(Map<String, dynamic> map) {
    return Question(
      question: map['question'],
      options: List<String>.from(map['options']),
    );
  }
}
