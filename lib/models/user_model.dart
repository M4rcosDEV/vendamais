class UserModel{
  final String? uid;
  final String? displayName;
  final String? email;
  final String? photoUrl;
  
  UserModel({this.uid, this.displayName, this.email, this.photoUrl});

  UserModel? copyWith({required String photoUrl}) {}

}