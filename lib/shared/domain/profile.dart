class Profile {
  final int id;
  final String firstName;
  final String lastName;
  final String email;
  final String phone;

  Profile({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    final String phoneValue = json['phone'] as String? ?? ''; 

    return Profile(
      id: json['id'] as int,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      email: json['email'] as String,
      phone: phoneValue, 
    );
  }
}