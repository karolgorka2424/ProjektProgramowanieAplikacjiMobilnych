import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  final int id;
  final String name;
  final String email;
  String? avatar;

  // Additional fields for API User
  String? username;
  Address? address;
  String? phone;
  String? website;
  Company? company;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.avatar,
    this.username,
    this.address,
    this.phone,
    this.website,
    this.company,
  });

  // Create User with password for local auth
  factory User.withPassword({
    required int id,
    required String name,
    required String email,
    required String password,
    String? avatar,
  }) {
    return User(
      id: id,
      name: name,
      email: email,
      avatar: avatar ?? 'https://i.pravatar.cc/150?img=$id',
    );
  }

  // Convert from JSON
  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  // Convert to JSON
  Map<String, dynamic> toJson() => _$UserToJson(this);
}

@JsonSerializable()
class Address {
  final String street;
  final String suite;
  final String city;
  final String zipcode;
  final Geo geo;

  Address({
    required this.street,
    required this.suite,
    required this.city,
    required this.zipcode,
    required this.geo,
  });

  factory Address.fromJson(Map<String, dynamic> json) => _$AddressFromJson(json);
  Map<String, dynamic> toJson() => _$AddressToJson(this);
}

@JsonSerializable()
class Geo {
  final String lat;
  final String lng;

  Geo({required this.lat, required this.lng});

  factory Geo.fromJson(Map<String, dynamic> json) => _$GeoFromJson(json);
  Map<String, dynamic> toJson() => _$GeoToJson(this);
}

@JsonSerializable()
class Company {
  final String name;
  final String catchPhrase;
  final String bs;

  Company({
    required this.name,
    required this.catchPhrase,
    required this.bs,
  });

  factory Company.fromJson(Map<String, dynamic> json) => _$CompanyFromJson(json);
  Map<String, dynamic> toJson() => _$CompanyToJson(this);
}

// User with password for authentication
class UserWithPassword extends User {
  final String password;

  UserWithPassword({
    required int id,
    required String name,
    required String email,
    required this.password,
    String? avatar,
  }) : super(
    id: id,
    name: name,
    email: email,
    avatar: avatar ?? 'https://i.pravatar.cc/150?img=$id',
  );

  // Convert to User without password
  User toUser() {
    return User(
      id: id,
      name: name,
      email: email,
      avatar: avatar,
    );
  }
}