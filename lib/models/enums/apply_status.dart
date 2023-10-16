enum ApplyStatus {
  applied(1),
  passed(2),
  rejected(3),
  ignored(4);

  const ApplyStatus(this.number);
  final int number;

  static ApplyStatus fromValue(int val) {
    return ApplyStatus.values.firstWhere((element) => element.number == val);
  }
}
