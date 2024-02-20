class QuizQuestion {
  // Constructor Function
  const QuizQuestion(this.text, this.answers);

  // properties
  final String text;
  final List<String> answers;

  List<String> getShuffledAnswers() {
    final shuffledList = List.of(answers);
    shuffledList.shuffle();
    return shuffledList;
  }
}
