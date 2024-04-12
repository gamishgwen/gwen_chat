class UserDetails
{
  final String id;
  final String userName;
  final String emailId;
  final String imageUrl;

  UserDetails(this.id, this.userName, this.emailId, this.imageUrl);

  Map<String, dynamic> toJson(){
    return {'id': id, 'userName':userName, 'emailId': emailId, 'imageUrl': imageUrl};
  }

  factory UserDetails.fromJson(Map<String,dynamic> map){
    return UserDetails(map['id'], map['userName'], map['emailId'], map['imageUrl']);
  }

  @override
  String toString() {
    return 'UserDetails{id: $id, userName: $userName, emailId: $emailId, imageUrl: $imageUrl}';
  }
}




