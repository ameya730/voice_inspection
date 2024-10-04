enum Keywords {
  passed('confirm'),
  failed('Failed'),
  showEarlier('Show Earlier');

  final String prompt;
  const Keywords(this.prompt);
}
