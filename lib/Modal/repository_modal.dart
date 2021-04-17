import 'package:git_trending/Modal/repo_built_by.dart';

class RepositoryModal {
  String author;
  String name;
  String avatar;
  String url;
  String description;
  String language;
  String languageColor;
  int stars;
  int forks;
  int currentPeriodStars;
  RepoBuiltBy builtBy;

  RepositoryModal(
      {this.builtBy,
      this.avatar,
      this.url,
      this.description,
      this.author,
      this.currentPeriodStars,
      this.forks,
      this.language,
      this.languageColor,
      this.name,
      this.stars});
  factory RepositoryModal.fromJson(Map<String, dynamic> json){
    return RepositoryModal(
      author: json["author"],
      name: json["name"],
      avatar: json["avatar"],
      url: json["url"],
      description: json["description"],
      language: json["language"],
      languageColor: json["languageColor"],
      stars: json["stars"],
      forks: json["forks"],
      currentPeriodStars: json["currentPeriodStars"],
      builtBy: RepoBuiltBy.fromJson(json["builtBy"][0])
    );
  }

}
