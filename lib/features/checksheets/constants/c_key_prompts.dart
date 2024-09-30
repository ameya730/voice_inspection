enum Keywords {
  passed('Cleared'),
  failed('Failed'),
  showEarlier('Show Earlier');

  final String prompt;
  const Keywords(this.prompt);
}
