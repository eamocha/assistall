class Chat {
  final String message;
  final int time;
  Chat({
    required this.message,
    required this.time,
  });

  Chat.fromJson(Map<String, Object?> json)
      : this(
    message: json['message']! as String,
    time: json['time']! as int,
  );



  Map<String, Object?> toJson() {
    return {
      'message': message,
      'time': time,
    };
  }
}