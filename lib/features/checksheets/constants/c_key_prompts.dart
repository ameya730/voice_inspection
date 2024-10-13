enum Keywords {
  passed('verified'),
  failed('rejected'),
  showEarlier('Show Earlier');

  final String prompt;
  const Keywords(this.prompt);
}
