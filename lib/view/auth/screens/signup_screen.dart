// import 'package:adv/view/auth/screens/widgets/buildFormField.dart';
// import 'package:flutter/material.dart';
// import 'package:adv/core/exports/ui_exports.dart';
// import 'package:adv/view/auth/controller/auth_controller.dart';
// import 'package:adv/view/onboarding/screens/widgets/card_googl.dart';
//
// class SignUpScreen extends StatelessWidget {
//   const SignUpScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final controller = Get.put(AuthController());
//
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
//           child: Form(
//             key: controller.formKey,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // Header Section
//                 _buildHeader(context),
//
//                 SizedBox(height: 40),
//
//                 // Form Fields
//                 _buildFormFields(controller),
//
//                 SizedBox(height: 20),
//
//                 // Terms and Conditions
//                 _buildTermsAndConditions(controller),
//
//                 SizedBox(height: 30),
//
//                 // Sign Up Button
//                 _buildSignUpButton(controller),
//
//                 SizedBox(height: 20),
//
//                 // Login Link
//                 _buildLoginLink(controller),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildHeader(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         // Back Button
//         IconButton(
//           onPressed: () => Get.back(),
//           icon: Icon(Icons.arrow_back_ios, color: Colors.grey[700]),
//           padding: EdgeInsets.zero,
//           alignment: Alignment.centerLeft,
//         ),
//
//         SizedBox(height: 20),
//
//         // Title
//         Text(
//           'Create Account',
//           style: TextStyle(
//             fontSize: 32,
//             fontWeight: FontWeight.w700,
//             color: Colors.grey[800],
//           ),
//         ),
//
//         SizedBox(height: 8),
//
//         // Subtitle
//         Text(
//           'Join Halbouni Book Store and discover amazing books',
//           style: TextStyle(
//             fontSize: 16,
//             fontWeight: FontWeight.w400,
//             color: Colors.grey[600],
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildFormFields(AuthController controller) {
//     return Column(
//       children: [
//         // Name Fields
//         Row(
//           children: [
//             Expanded(
//               child: buildTextField(
//                 controller: controller.firstNameController,
//                 label: 'First Name',
//                 validator: controller.validateFirstName,
//                 icon: Icons.person_outline,
//               ),
//             ),
//             SizedBox(width: 16),
//             Expanded(
//               child: buildTextField(
//                 controller: controller.lastNameController,
//                 label: 'Last Name',
//                 validator: controller.validateLastName,
//                 icon: Icons.person_outline,
//               ),
//             ),
//           ],
//         ),
//
//         SizedBox(height: 16),
//
//         // Email Field
//         buildTextField(
//           controller: controller.emailController,
//           label: 'Email Address',
//           validator: controller.validateEmail,
//           icon: Icons.email_outlined,
//           keyboardType: TextInputType.emailAddress,
//         ),
//
//         SizedBox(height: 16),
//
//         // Phone Field
//         buildTextField(
//           controller: controller.phoneController,
//           label: 'Phone Number',
//           validator: controller.validatePhone,
//           icon: Icons.phone_outlined,
//           keyboardType: TextInputType.phone,
//         ),
//
//         SizedBox(height: 16),
//
//         // Password Field
//         Obx(
//           () => buildTextField(
//             controller: controller.passwordController,
//             label: 'Password',
//             validator: controller.validatePassword,
//             icon: Icons.lock_outline,
//             obscureText: !controller.isPasswordVisible.value,
//             suffixIcon: IconButton(
//               icon: Icon(
//                 controller.isPasswordVisible.value
//                     ? Icons.visibility_off
//                     : Icons.visibility,
//                 color: Colors.grey[600],
//               ),
//               onPressed: controller.togglePasswordVisibility,
//             ),
//           ),
//         ),
//
//         SizedBox(height: 16),
//
//         // Confirm Password Field
//         Obx(
//           () => buildTextField(
//             controller: controller.confirmPasswordController,
//             label: 'Confirm Password',
//             validator: controller.validateConfirmPassword,
//             icon: Icons.lock_outline,
//             obscureText: !controller.isConfirmPasswordVisible.value,
//             suffixIcon: IconButton(
//               icon: Icon(
//                 controller.isConfirmPasswordVisible.value
//                     ? Icons.visibility_off
//                     : Icons.visibility,
//                 color: Colors.grey[600],
//               ),
//               onPressed: controller.toggleConfirmPasswordVisibility,
//             ),
//           ),
//         ),
//       ],
//     );
//   }
//
//
//
//   Widget _buildTermsAndConditions(AuthController controller) {
//     return Obx(
//       () => Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Checkbox(
//             value: controller.agreeToTerms.value,
//             onChanged: (value) => controller.toggleTermsAgreement(),
//             activeColor: AppColor.primaryColor,
//           ),
//           Expanded(
//             child: Padding(
//               padding: EdgeInsets.only(top: 12),
//               child: RichText(
//                 text: TextSpan(
//                   style: TextStyle(
//                     fontSize: 14,
//                     color: Colors.grey[600],
//                     height: 1.4,
//                   ),
//                   children: [
//                     TextSpan(text: 'I agree to the '),
//                     TextSpan(
//                       text: 'Terms and Conditions',
//                       style: TextStyle(
//                         color: AppColor.primaryColor,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                     TextSpan(text: ' and '),
//                     TextSpan(
//                       text: 'Privacy Policy',
//                       style: TextStyle(
//                         color: AppColor.primaryColor,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildSignUpButton(AuthController controller) {
//     return Obx(
//       () => CardGoogle(
//         label:
//             controller.isLoading.value
//                 ? 'Creating Account...'
//                 : 'Create Account',
//         backGroundColor: AppColor.primaryColor,
//         onTap: controller.isLoading.value ? null : controller.signUp,
//       ),
//     );
//   }
//
//   Widget _buildLoginLink(AuthController controller) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         Text(
//           'Already have an account? ',
//           style: TextStyle(fontSize: 16, color: Colors.grey[600]),
//         ),
//         GestureDetector(
//           onTap: controller.navigateToLogin,
//           child: Text(
//             'Sign In',
//             style: TextStyle(
//               fontSize: 16,
//               color: AppColor.primaryColor,
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
