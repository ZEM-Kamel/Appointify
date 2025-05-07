class UserEntity {
  final String uId;
  final String email;
  final String name;

  const UserEntity({
    required this.uId,
    required this.email,
    required this.name,
   
  });

  factory UserEntity.fromJson(Map<String, dynamic> json) {
    return UserEntity(
      uId: json['uId'] as String,
      email: json['email'] as String,
      name: json['name'] as String,

    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uId': uId,
      'email': email,
      'name': name,
    
    };
  }
}