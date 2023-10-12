// ignore_for_file: public_member_api_docs, sort_constructors_first

enum MessageType {
  text(1),
  image(2),
  video(3),
  audio(4),
  otherFile(127);

  const MessageType(this.number);
  final int number;
}
