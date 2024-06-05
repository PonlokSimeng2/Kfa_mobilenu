import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../models/M_commune.dart';
import '../models/M_roadAndcommune.dart';
import '../models/login_model.dart';
import '../models/register_model.dart';
import '../models/autoVerbal.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/user_model.dart';

const baseUrl = "https://www.oneclickonedollar.com/laravel_kfa_2023";

final apiServiceProvider = Provider<APIservice>((ref) {
  return APIservice();
});

class APIservice {
  Future<UserModel> getUserByToken(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/public/api/user'),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200 || response.statusCode == 422) {
      return UserModel.fromJson(response.body);
    } else if (response.statusCode == 201 || response.statusCode == 401) {
      return UserModel.fromJson(response.body);
    } else {
      throw Exception('Failed to load Data');
    }
  }

  Future<LoginReponseModel> login(LoginRequestModel requestModel) async {
    final response = await http.post(
      Uri.parse('$baseUrl/public/api/login'),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/x-www-form-urlencoded"
      },
      body: requestModel.toJson(),
    );

    if (response.statusCode == 200 || response.statusCode == 422) {
      return LoginReponseModel.fromJson(json.decode(response.body));
    } else if (response.statusCode == 201 || response.statusCode == 401) {
      return LoginReponseModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load Data');
    }
  }

  Future<RegisterReponseModel> register(
    RegisterRequestModel requestModel,
  ) async {
    final response = await http.post(
      Uri.parse(
        '$baseUrl/public/api/register',
      ),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/x-www-form-urlencoded"
      },
      body: requestModel.toJson(),
    );

    if (response.statusCode == 200 || response.statusCode == 422) {
      return RegisterReponseModel.fromJson(json.decode(response.body));
    } else if (response.statusCode == 201 || response.statusCode == 401) {
      return RegisterReponseModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load Data');
    }
  }

  Future<RegisterReponseModel_update> update_user(
    RegisterRequestModel_update requestModel,
    int id_user,
  ) async {
    final response = await http.put(
      Uri.parse(
        '$baseUrl/public/api/user/edit/${id_user.toString()}',
      ),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/x-www-form-urlencoded"
      },
      body: requestModel.toJson(),
    );

    return RegisterReponseModel_update.fromJson(json.decode(response.body));
  }

  Future<AutoVerbalReponseModel> saveAutoVerbal(
    AutoVerbalRequestModel requestModel,
  ) async {
    final response = await http.post(
      Uri.parse(
        '$baseUrl/public/api/autoverbal/save',
      ),
      headers: {
        "Accept": "application/json;charset=UTF-8",
        "Content-Type": "application/json"
      },
      body: json.encode(
        requestModel.toJson(),
      ),
    );

    if (response.statusCode == 200 || response.statusCode == 422) {
      return AutoVerbalReponseModel.fromJson(json.decode(response.body));
    } else if (response.statusCode == 201 || response.statusCode == 401) {
      return AutoVerbalReponseModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load Data');
    }
  }

  //Test
  Future<AutoVerbalReponseModel> Test(
    AutoVerbalRequestModel requestModel,
  ) async {
    final response = await http.post(
      Uri.parse(
        '$baseUrl/public/api/autoverbal/save',
      ),
      headers: {
        "Accept": "application/json;charset=UTF-8",
        "Content-Type": "application/json"
      },
      body: json.encode(
        requestModel.toJson(),
      ),
    );

    if (response.statusCode == 200 || response.statusCode == 422) {
      return AutoVerbalReponseModel.fromJson(json.decode(response.body));
    } else if (response.statusCode == 201 || response.statusCode == 401) {
      return AutoVerbalReponseModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load Data');
    }
  }

  Future<AutoVerbalReponseModel> saveAutoVerbal_Update(
    AutoVerbalRequestModel_update requestModel,
    int id,
  ) async {
    final response = await http.post(
      Uri.parse(
        '$baseUrl/public/api/autoverbal/save_new/$id',
      ),
      headers: {
        "Accept": "application/json;charset=UTF-8",
        "Content-Type": "application/json"
      },
      body: json.encode(
        requestModel.toJson(),
      ),
    );

    if (response.statusCode == 200 || response.statusCode == 422) {
      return AutoVerbalReponseModel.fromJson(json.decode(response.body));
    } else if (response.statusCode == 201 || response.statusCode == 401) {
      return AutoVerbalReponseModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load Data');
    }
  }

  Future<AutoVerbalReponseModel> saveVerbal(
    AutoVerbalRequestModel requestModel,
  ) async {
    final response = await http.post(
      Uri.parse(
        '$baseUrl/public/api/verbals/save',
      ),
      headers: {
        "Accept": "application/json;charset=UTF-8",
        "Content-Type": "application/json"
      },
      body: json.encode(
        requestModel.toJson(),
      ),
    );

    if (response.statusCode == 200 || response.statusCode == 422) {
      return AutoVerbalReponseModel.fromJson(json.decode(response.body));
    } else if (response.statusCode == 201 || response.statusCode == 401) {
      return AutoVerbalReponseModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load Data');
    }
  }

  Future<M_CommuneReponeModel> SaveCommune(M_Commune requestModel) async {
    final response = await http.post(
      Uri.parse(
        '$baseUrl/public/api/new_commune',
      ),
      headers: {
        "Accept": "application/json;charset=UTF-8",
        "Content-Type": "application/json"
      },
      body: json.encode(
        requestModel.toJson(),
      ),
    );

    if (response.statusCode == 200 || response.statusCode == 422) {
      return M_CommuneReponeModel.fromJson(json.decode(response.body));
    } else if (response.statusCode == 201 || response.statusCode == 401) {
      return M_CommuneReponeModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load Data');
    }
  }

  Future<roadAndcommune_ReponeModel> RoadAndCommune(
    roadAndcommune requestModel,
  ) async {
    final response = await http.post(
      Uri.parse(
        '$baseUrl/public/api/new_rc',
      ),
      headers: {
        "Accept": "application/json;charset=UTF-8",
        "Content-Type": "application/json"
      },
      body: json.encode(
        requestModel.toJson(),
      ),
    );
    if (response.statusCode == 200 || response.statusCode == 422) {
      return roadAndcommune_ReponeModel.fromJson(json.decode(response.body));
    } else if (response.statusCode == 201 || response.statusCode == 401) {
      return roadAndcommune_ReponeModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load Data');
    }
  }
}
