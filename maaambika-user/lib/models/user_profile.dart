class UserProfile {
  String name;
  String phone;
  String email;
  int avatarIndex;
  String upiId;
  String bankAccount;
  String address;

  UserProfile({
    required this.name,
    required this.phone,
    required this.email,
    required this.avatarIndex,
    required this.upiId,
    required this.bankAccount,
    required this.address,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'phone': phone,
    'email': email,
    'avatarIndex': avatarIndex,
    'upiId': upiId,
    'bankAccount': bankAccount,
    'address': address,
  };

  factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
    name: json['name'] ?? '',
    phone: json['phone'] ?? '',
    email: json['email'] ?? '',
    avatarIndex: json['avatarIndex'] ?? 0,
    upiId: json['upiId'] ?? '',
    bankAccount: json['bankAccount'] ?? '',
    address: json['address'] ?? '',
  );

  UserProfile copyWith({
    String? name,
    String? phone,
    String? email,
    int? avatarIndex,
    String? upiId,
    String? bankAccount,
    String? address,
  }) {
    return UserProfile(
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      avatarIndex: avatarIndex ?? this.avatarIndex,
      upiId: upiId ?? this.upiId,
      bankAccount: bankAccount ?? this.bankAccount,
      address: address ?? this.address,
    );
  }
}
