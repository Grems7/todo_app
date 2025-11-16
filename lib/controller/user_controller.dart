import 'package:get/get.dart';
import 'package:todo_getx/database/auth_repo.dart';


class UserController extends GetxController {
  final AuthRepo _authRepo = AuthRepo();

  var userName = "".obs;
  var userEmail = "".obs;
  var userImage = "".obs;

  @override
  void onInit() {
    super.onInit();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    try {
      final data = await _authRepo.getProfile();
      print("📄 Données utilisateur récupérées : $data");

      if (data != null && data is Map) {
        userName.value = data["name"] ?? "User";
        userEmail.value = data["email"] ?? "";
        userImage.value = data["image"] ?? "";
      } else {
        print("⚠️ Données utilisateur vides ou mal formées.");
      }
    } catch (e) {
      print("❌ Erreur fetchUserData : $e");
    }
  }

}
