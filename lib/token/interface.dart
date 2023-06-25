mixin TokenManagerMixin {
  String? get token;
  String? name;

  bool get isAuthed => token != null;

  void setToken(String? token);
}