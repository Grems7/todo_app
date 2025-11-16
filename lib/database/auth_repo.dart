import 'package:dio/dio.dart';
import '../network/api_error.dart';
import '../network/api_service.dart';
import '../utils/pref_helper.dart';

class AuthRepo {
  final ApiService _apiService = ApiService();


  Future<bool> login(String email, String password) async {
    try {
      final result = await _apiService.post("/login", {
        "email": email,
        "password": password,
      });

      if (result is ApiError) {
        print("❌ Erreur API : ${result.message}");
        return false;
      }

      if (result is Map && result["data"] != null) {
        final data = result["data"];
        final user = data["user"];
        final id = user["id"];
        final token = data["token"];

        await PrefHelper.saveToken(token);
        await PrefHelper.saveId(id);

        print("✅ Token enregistré : $token");
        print("✅ ID utilisateur enregistré : $id");
        return true;
      } else {
        print("⚠️ Réponse inattendue : $result");
        return false;
      }
    } catch (e) {
      print("❌ Exception login : $e");
      return false;
    }
  }


  Future<bool> register({
    required String name,
    required String email,
    required String password,
    String? imagePath,
    String? phone,
    String? address,
    String? visa,
  }) async {
    try {
      FormData formData = FormData.fromMap({
        "name": name,
        "email": email,
        "password": password,
        "phone": phone ?? "",
        "address": address ?? "",
        "visa": visa ?? "",
        if (imagePath != null)
          "image": await MultipartFile.fromFile(
            imagePath,
            filename: imagePath.split('/').last,
          ),
      });

      final response = await _apiService.postFormData("/register", formData);

      print("✅ SignUp Success: $response");
      return true;
    } on DioException catch (e) {
      print("❌ Erreur API register: ${e.response?.data ?? e.message}");
      return false;
    }
  }

  Future<dynamic> getProfile() async {
    final id = await PrefHelper.getId();
    final response = await _apiService.get("/users/$id");
    return response;
  }

 /* Future<dynamic> updateProfile( {
    required String name,
    required String email,
    String? phone,
    String? address,
    String? visa,
    String? imagePath, // chemin du fichier (peut être null)
  }) async {
    //final id = await PrefHelper.getId();

    FormData formData = FormData.fromMap({
      "name": name,
      "email":email,
      "phone": phone,
      //"address": address,
      //"visa": visa,
      if (imagePath != null)
        "image": await MultipartFile.fromFile(imagePath, filename: "profile.jpg"),
    });

    final response = await _apiService.put("/$id", formData);
    return response.data;
  }*/


  // 🧑‍💻 Supprimer le profil utilisateur
  Future<bool> deleteProfile() async {
    try {
      // Récupère l’ID du user sauvegardé localement
      final userId = await PrefHelper.getId();

      if (userId == null || userId.isEmpty) {
        print("❌ Aucun ID utilisateur trouvé");
        return false;
      }

      // Envoie la requête DELETE vers ton backend
      final response = await _apiService.delete("users/$userId", {});

      if (response is ApiError) {
        print("❌ Erreur backend : ${response.message}");
        return false;
      }

      // Vérifie si le backend a bien répondu avec un message de succès
      if (response is Map && response.containsKey("message")) {
        print("✅ ${response['message']}");
        // Optionnel : on supprime le token et les infos locales
        await PrefHelper.clearToken();
        return true;
      } else {
        print("⚠️ Réponse inattendue : $response");
        return false;
      }
    } catch (e) {
      print("❌ Exception deleteProfile : $e");
      return false;
    }
  }

}