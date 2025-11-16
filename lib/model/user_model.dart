class UserModel{

  final String name;
  final String email;
  final String? phone;
  final String password;
  final String? image;
  final String? adress;
  final String? visa;
  final String? token;

  UserModel({
    required this.name,
    required this.email,
    required this.password,
    this.phone,
    this.image,
    this.adress,
    this.visa,
    this.token,
  });

  factory UserModel.fromjson(Map<String,dynamic>json){
    return UserModel(
      name: json['name']??"",
      email: json['email']??"",
      phone: json['phone']??"",
      password: json['passord']??"",
      image: json['image']??"",
      visa: json['visa']??"",
      adress: json['address']??"",
      token: json['token']??"",
    );
  }
}