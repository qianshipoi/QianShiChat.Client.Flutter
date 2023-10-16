enum MessageSendType {
  personal(1),
  group(2);

  const MessageSendType(this.number);
  final int number;

  static MessageSendType fromValue(int val) {
    return MessageSendType.values
        .firstWhere((element) => element.number == val);
  }
}
