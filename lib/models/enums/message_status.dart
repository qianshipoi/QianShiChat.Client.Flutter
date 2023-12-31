enum MessageStatus {
  sending(0),
  succeeded(1),
  failed(2);

  const MessageStatus(this.number);
  final int number;

  static MessageStatus fromValue(int val) {
    return MessageStatus.values.firstWhere((element) => element.number == val);
  }
}
