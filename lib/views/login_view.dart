import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:todo_getx/views/signup_view.dart';
import '../controller/login_controller.dart';
import '../widgets/custom_btn_auth.dart';
import '../widgets/custom_text.dart';
import '../widgets/custom_txt_field.dart';


class LoginView extends StatelessWidget {
  LoginView({Key? key}) : super(key: key);

  final LoginController controller = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Form(
                key: controller.formKey,
                child: Column(
                  children: [
                    const Gap(130),
                    Image.asset("assets/images/logo.PNG", width: 180),
                    const Gap(10),
                    CustomText(
                      text: 'Welcome Back, Discover List ToDo',
                      color: Colors.grey.shade400,
                      weight: FontWeight.w900,
                      size: 13,
                    ),
                    const Gap(50),
                    CustomTxtField(
                      controller: controller.emailController,
                      hint: 'Email Address',
                      ispassword: false,
                    ),
                    const Gap(10),
                    CustomTxtField(
                      controller: controller.passController,
                      hint: 'Password',
                      ispassword: true,
                    ),
                    const Gap(30),

                    // 🔄 Obx pour afficher le chargement dynamiquement
                    Obx(() => controller.isLoading.value
                        ? const CupertinoActivityIndicator(color: Colors.purple)
                        : CustomAuthBtn(
                      txt: 'Login',
                      ontap: controller.login,
                    )),

                    const Gap(20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomText(
                          text: "Don't have an account? ",
                          color: Colors.grey.shade400,
                          weight: FontWeight.w500,
                          size: 13,
                        ),
                        const Gap(20),
                        GestureDetector(
                          onTap: () => Get.to(() => SignUpView()),
                          child: const CustomText(
                            text: 'Sign Up here',
                            color: Colors.purple,
                            size: 13,
                          ),
                        ),
                      ],
                    ),
                    const Gap(300),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
