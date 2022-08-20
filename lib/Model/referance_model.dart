///New Code Version 25.3

class ReferanceModel{
  final String userId;
  final String value;
  final String userName;

  ReferanceModel({this.userName, this.userId,this.value});

  Map<String, dynamic> toMap() {
    return {
      'userName': this.userName,
      'user' : this.userId,
      'value': this.value,
    };
  }

  factory ReferanceModel.fromMap(Map<String, dynamic> map) {
    return ReferanceModel(
      userName: map['userName'] as String,
      value: map['value'] as String,
      userId: map['user'] as String,

    );
  }
}