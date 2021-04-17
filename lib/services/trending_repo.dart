import 'dart:convert';

import 'package:git_trending/Modal/repository_modal.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class TrendingRepo {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  String url =
      "https://private-anon-eb891769c7-githubtrendingapi.apiary-mock.com/repositories?since=daily";

  Future<List<RepositoryModal>> get_trending_repo() async {
    SharedPreferences preferences = await _prefs;
    var last_updated = await preferences.getString("updatedOn");
    if (last_updated != null) {
      DateTime updatedOn = DateTime.parse(last_updated);
      if (cache_valid(updatedOn.difference(DateTime.now()))) {
        print("getting from local");
        var data = await preferences.getString("trending_repo");
        var raw_list = json.decode(data) as List;
        List<RepositoryModal> repo_list = await raw_list
            .map<RepositoryModal>((json) => RepositoryModal.fromJson(json))
            .toList();
        return repo_list;
      }
    }
    return get_trending_repo_remote();
  }

  Future<List<RepositoryModal>> get_trending_repo_remote() async {
    var request = http.Request('GET', Uri.parse(url));
    http.StreamedResponse response;
    try {
       response = await request.send();
    }catch(e){
      return null;
    }
    print("getting from remote");
    if (response.statusCode == 200) {
      var data = (await response.stream.bytesToString());
      print("saving locally");
      await save_locally(data);
      var raw_list = json.decode(data) as List;
      List<RepositoryModal> repo_list = await raw_list
          .map<RepositoryModal>((json) => RepositoryModal.fromJson(json))
          .toList();
      return repo_list;
    } else {
      print(response.reasonPhrase);
      return null;
    }
  }

  void save_locally(String data) async {
    SharedPreferences preferences = await _prefs;
    await preferences.setString("trending_repo", data);
    await preferences.setString("updatedOn", DateTime.now().toString());
  }

  bool cache_valid(Duration time_difference) {
    if (time_difference.inMinutes < 15) {
      print("valid");
      return true;
    }
    print("not valid");
    return false;
  }
}
