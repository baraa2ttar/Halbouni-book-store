import 'package:adv/core/constant/app_text_styles.dart';
import 'package:adv/view/auth/screens/widgets/buildFormField.dart';

import '../../../core/exports/main_exports.dart';
import '../controller/auth_controller.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AuthController());
    return Scaffold(
      appBar:AppBar(
          automaticallyImplyLeading :true
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 40,),
            Text("Welcome Back",
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 35
            ),
            ),
            SizedBox(height: 40,),
            Text("Please Enter your Username and password",
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 15
              ),
            ),
            SizedBox(height: 60,),

            Row(
              children: [
                SizedBox(
                  width: 1,
                ),
                buildTextField(
                  controller: controller.emailController,
                  label: 'User name ',
                  validator: controller.validateEmail,
                  icon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                ),
              ],
            ),
            SizedBox(height: 30,),

            Row(
              children: [
                SizedBox(
                  width: 1,
                ),
                Obx(
                      () => buildTextField(
                    controller: controller.confirmPasswordController,
                    label: 'Confirm Password',
                    validator: controller.validateConfirmPassword,
                    icon: Icons.lock_outline,
                    obscureText: !controller.isConfirmPasswordVisible.value,
                    suffixIcon: IconButton(
                      icon: Icon(
                        controller.isConfirmPasswordVisible.value
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: Colors.grey[600],
                      ),
                      onPressed: controller.toggleConfirmPasswordVisibility,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Obx(
                () =>
                   Checkbox(
                   value: controller.saveUsersPassword.value,
                    onChanged: (value) => controller.toggleTermsAgreement(),
                    activeColor: AppColor.primaryColor,
                  ),
                ),
                Text("remember me",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500
                ),)
              ],
            ),


          ],
        ),
      ),
    );
  }
}
