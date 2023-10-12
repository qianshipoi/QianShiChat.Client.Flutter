enum MessageType {
  text(1),
  image(2),
  video(3),
  audio(4),
  otherFile(127);

  const MessageType(this.number);
  final int number;

  static MessageType fromValue(int val) {
    return MessageType.values.firstWhere((element) => element.number == val);
  }
}
