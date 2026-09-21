class UserModel {
  final int? id;
  final String email;
  final String? username;
  final String? avatarUrl;
  final String? createdAt;

  const UserModel({
    this.id,
    required this.email,
    this.username,
    this.avatarUrl,
    this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'email': email,
      'username': username,
      'avatar_url': avatarUrl,
      'created_at': createdAt ?? DateTime.now().toIso8601String(),
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] as int?,
      email: map['email'] as String? ?? '',
      username: map['username'] as String?,
      avatarUrl: map['avatar_url'] as String?,
      createdAt: map['created_at'] as String?,
    );
  }

  UserModel copyWith({
    int? id,
    String? email,
    String? username,
    String? avatarUrl,
    String? createdAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      username: username ?? this.username,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
