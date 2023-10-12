// ignore_for_file: public_member_api_docs, sort_constructors_first

enum MessageStatus {
  sending(0),
  succeeded(1),
  failed(2);

  const MessageStatus(this.number);
  final int number;
}
