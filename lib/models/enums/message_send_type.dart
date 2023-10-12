// ignore_for_file: public_member_api_docs, sort_constructors_first

enum MessageSendType {
  personal(1),
  group(2);

  const MessageSendType(this.number);
  final int number;
}
