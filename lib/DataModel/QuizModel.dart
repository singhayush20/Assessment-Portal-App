class QuizModel {
  int? _quizId;
  String _title;
  String _description;
  String _maxMarks;
  bool _active;
  int _categoryId;
  int _numberOfQuestions;
  int _time;

  QuizModel(this._title, this._description, this._maxMarks, this._active,
      this._categoryId, this._numberOfQuestions, this._time);

  QuizModel.saveQuiz(
      this._quizId,
      this._title,
      this._description,
      this._maxMarks,
      this._active,
      this._categoryId,
      this._numberOfQuestions,
      this._time);

  int get numberOfQuestions => _numberOfQuestions;

  set quizId(int value) {
    _quizId = value;
  }

  int get categoryId => _categoryId;

  bool get active => _active;

  String get maxMarks => _maxMarks;

  String get description => _description;

  String get title => _title;

  int get quizId => _quizId ?? 0;
  int get time => _time;
  set title(String value) {
    _title = value;
  }

  set numberOfQuestions(int value) {
    _numberOfQuestions = value;
  }

  set categoryId(int value) {
    _categoryId = value;
  }

  set active(bool value) {
    _active = value;
  }

  set maxMarks(String value) {
    _maxMarks = value;
  }

  set description(String value) {
    _description = value;
  }

  set time(int time) {
    _time = time;
  }
}
