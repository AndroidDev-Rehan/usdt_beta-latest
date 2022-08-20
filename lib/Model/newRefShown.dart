class NewRefShown{
   int count;

  NewRefShown({this.count});

  Map<String, dynamic> toMap() {
    return {
      'count': this.count,
    };
  }

  factory NewRefShown.fromMap(Map<String, dynamic> map) {
    return NewRefShown(
      count: map['count'] as int ?? 0,
    );
  }
}