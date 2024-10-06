enum Routes {
  landing('/'),
  login('/login'),
  logOut('/logout'),
  register('/register'),
  resetPassword('/resetPassword'),
  home('/home'),
  preDeliveryInspection('/preDeliveryInspection');

  final String path;
  const Routes(this.path);
}
