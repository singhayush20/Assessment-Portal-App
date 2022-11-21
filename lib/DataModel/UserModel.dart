class User {
  late String? _userId;
  late String _firstName;
  late String _lastName;
  late String _password;
  late String _email;
  late String _phoneNumber;
  late String _userName;
  late String? _profile;
  late List<dynamic>? _roles;
  User(this._userName, this._firstName, this._lastName, this._password,
      this._email, this._phoneNumber);

  User.saveUser(
      {required String userId,
      required String firstName,
      required String lastName,
      required String password,
      required String email,
      required String phoneNumber,
      required String userName,
      required String profile,
      required List<dynamic> roles}) {
    this._userId = userId;
    _email = email;
    _password = password;
    _firstName = firstName;
    _lastName = lastName;
    _phoneNumber = phoneNumber;
    _userName = userName;
    _profile = profile;
    _roles = roles;
  }

  String get userId => _userId ?? "null";

  set userId(String value) {
    _userId = value;
  }

  String get phoneNumber => _phoneNumber;

  String get email => _email;

  String get password => _password;

  String get lastName => _lastName;

  String get firstName => _firstName;

  set phoneNumber(String value) {
    _phoneNumber = value;
  }

  set email(String value) {
    _email = value;
  }

  set password(String value) {
    _password = value;
  }

  set lastName(String value) {
    _lastName = value;
  }

  set firstName(String value) {
    _firstName = value;
  }

  set userName(String value) {
    _userName = value;
  }

  String get userName => _userName;

  List<dynamic> get roles => _roles!;

  set profile(String value) {
    _profile = value;
  }

  String get profile => _profile!;

  set roles(List<dynamic> value) {
    _roles = value;
  }
}
