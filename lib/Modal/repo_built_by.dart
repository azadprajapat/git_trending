class RepoBuiltBy {
  String href;
  String avatar;
  String username;

  RepoBuiltBy({this.username, this.avatar, this.href});

  factory RepoBuiltBy.fromJson(Map<String, dynamic> json) {
    return RepoBuiltBy(
        href: json["href"], avatar: json["avatar"], username: json["username"]);
  }
}
