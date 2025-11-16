
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:todo_getx/controller/signup_controller.dart';
import '../widgets/custom_btn_auth.dart';
import '../widgets/custom_text.dart';
import '../widgets/custom_txt_field.dart';
import 'login_view.dart';

class SignUpView extends StatelessWidget {
  SignUpView({Key? key}) : super(key: key);

  final SignUpController signUpController = Get.put(SignUpController());

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Form(
            key: signUpController.formKey,
            child: Column(
              children: [
                const Gap(80),

                // 👤 Avatar avec image sélectionnée
                Obx(() {
                  final imageFile = signUpController.image.value;

                  return Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      CircleAvatar(
                        radius: 60,
                        backgroundColor: Colors.purple.withOpacity(0.3),
                        backgroundImage: imageFile != null
                            ? FileImage(imageFile)
                            : const AssetImage('assets/images/logo.PNG')
                        as ImageProvider,
                      ),
                      Positioned(
                        bottom: 4,
                        right: 4,
                        child: GestureDetector(
                          onTap: () => signUpController.pickImage(),
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: const BoxDecoration(
                              color: Colors.purple,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              CupertinoIcons.camera_fill,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }),

                const Gap(20),
                CustomText(
                  text: 'Welcome Todo App register',
                  color: Colors.grey.shade400,
                  weight: FontWeight.w700,
                ),
                const Gap(15),

                CustomTxtField(
                  hint: 'Name',
                  ispassword: false,
                  controller: signUpController.nameController,
                ),
                const Gap(6),
                CustomTxtField(
                  hint: 'Email Address',
                  ispassword: false,
                  controller: signUpController.emailController,
                ),
                const Gap(6),
                CustomTxtField(
                  hint: 'Password',
                  ispassword: true,
                  controller: signUpController.passController,
                ),
                const Gap(6),
                CustomTxtField(
                  hint: 'Confirm Password',
                  ispassword: true,
                  controller: signUpController.confirmController,
                ),
                const Gap(20),

                CustomAuthBtn(
                  txt: 'SignUp',
                  ontap: () {
                    if (signUpController.formKey.currentState!.validate()) {
                      print('✅ SignUp Success');
                      print('📸 Image : ${signUpController.image.value?.path}');
                      signUpController.register();
                    }
                  },
                ),

                const Gap(20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomText(
                      text: "Already have an account? ",
                      color: Colors.grey.shade400,
                      weight: FontWeight.w500,
                      size: 13,
                    ),
                    const Gap(10),
                    GestureDetector(
                      onTap: () => Get.to(() =>  LoginView()),
                      child: CustomText(
                        text: 'Login here',
                        color: Colors.purple,
                        size: 13,
                      ),
                    ),
                  ],
                ),
                const Gap(50),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
