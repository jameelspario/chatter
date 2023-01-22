
class UserModel {
  final String? id;
  final String? profileUrl;
  final String? bannerUrl;
  final String? name;
  final String? email;

  UserModel({this.id, this.profileUrl, this.bannerUrl, this.name, this.email});

  static UserModel fromJson(id, Map<String, dynamic> json) => UserModel(
    id:id,
    profileUrl: json['profile'] ??'',
    bannerUrl: json['banner']??'',
    name: json['name']??'',
    email: json['email']??'',
  );
}
