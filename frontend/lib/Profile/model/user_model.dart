class UserModel {
  int id;
  String username;
  String email;
  String firstname;
  String lastname;
  String password;
  String phoneNumber;
  double bandScore;
  String languageProficiency;
  String studyPlan;
  
  UserModel({
    required this.id,
    required this.username,
    required this.email,
    required this.firstname,
    required this.lastname,
    required this.password,
    required this.phoneNumber,
    required this.bandScore,
    required this.languageProficiency,
    required this.studyPlan,
  });

  factory UserModel.fromJson(json) {
    if (json == null) {
      return UserModel(
        id: 0,
        username: '',
        email: '',
        firstname: '',
        lastname: '',
        password: '',
        phoneNumber: '',
        bandScore: 0,
        languageProficiency: '',
        studyPlan: '',
      );
    }
    return UserModel(
      id: json['id'],
      username: json['username'],
      email: json['email_address'],
      firstname: json['firstname'],
      lastname: json['lastname'],
      password: json['password'],
      phoneNumber: json['phone_number'],
      bandScore: json['ielts_band_score'],
      languageProficiency: json['language_proficiency'][0].toUpperCase() + json['language_proficiency'].substring(1),
      studyPlan: json['study_plan'] == 'A' ? 'Academic' : 'General',
    );
  }

}
