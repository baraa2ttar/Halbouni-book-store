// import 'package:adv/core/exports/main_exports.dart';
// import 'package:adv/core/helpers/validation_service.dart';
//
//
// class AuthController extends GetxController {
//   // Form controllers
//   final TextEditingController firstNameController = TextEditingController();
//   final TextEditingController lastNameController = TextEditingController();
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();
//   final TextEditingController confirmPasswordController =
//       TextEditingController();
//   final TextEditingController phoneController = TextEditingController();
//
//   // Form key for validation
//   final GlobalKey<FormState> formKey = GlobalKey<FormState>();
//
//   // Loading state
//   final RxBool isLoading = false.obs;
//
//   // Password visibility
//   final RxBool isPasswordVisible = false.obs;
//   final RxBool isConfirmPasswordVisible = false.obs;
//
//   // Terms and conditions
//   final RxBool agreeToTerms = false.obs;
//   final RxBool saveUsersPassword = true.obs;
//
//   @override
//   void onClose() {
//     firstNameController.dispose();
//     lastNameController.dispose();
//     emailController.dispose();
//     passwordController.dispose();
//     confirmPasswordController.dispose();
//     phoneController.dispose();
//     super.onClose();
//   }
//
//   void togglePasswordVisibility() {
//     isPasswordVisible.toggle();
//   }
//
//   void toggleConfirmPasswordVisibility() {
//     isConfirmPasswordVisible.toggle();
//   }
//
//   void toggleTermsAgreement() {
//     agreeToTerms.toggle();
//   }
//   void toggleSavingUsersPassword() {
//     saveUsersPassword.toggle();
//   }
//   String? validateFirstName(String? value) {
//     return ValidationService.requiredField(value, fieldName: 'First name');
//   }
//
//   String? validateLastName(String? value) {
//     return ValidationService.requiredField(value, fieldName: 'Last name');
//   }
//
//   String? validateEmail(String? value) {
//     return ValidationService.email(value);
//   }
//
//   String? validatePhone(String? value) {
//     return ValidationService.phone(value);
//   }
//
//   String? validatePassword(String? value) {
//     return ValidationService.minLength(value, 8, fieldName: 'Password');
//   }
//
//   String? validateConfirmPassword(String? value) {
//     if (value == null || value.isEmpty) {
//       return 'Please confirm your password';
//     }
//     return ValidationService.matchFields(
//       value,
//       passwordController.text,
//       fieldName: 'Passwords',
//     );
//   }
//
//   Future<void> signUp() async {
//     if (!formKey.currentState!.validate()) {
//       return;
//     }
//
//     if (!agreeToTerms.value) {
//       Get.snackbar(
//         'Terms Required',
//         'Please agree to the terms and conditions',
//         snackPosition: SnackPosition.TOP,
//         backgroundColor: Colors.red,
//         colorText: Colors.white,
//       );
//       return;
//     }
//
//     isLoading.value = true;
//
//     try {
//       // TODO: Implement actual sign-up API call here
//       await Future.delayed(Duration(seconds: 2)); // Simulate API call
//
//       Get.snackbar(
//         'Success',
//         'Account created successfully!',
//         snackPosition: SnackPosition.TOP,
//         backgroundColor: Colors.green,
//         colorText: Colors.white,
//       );
//
//       // TODO: Navigate to main app or login screen
//       print('Sign up data:');
//       print('Name: ${firstNameController.text} ${lastNameController.text}');
//       print('Email: ${emailController.text}');
//       print('Phone: ${phoneController.text}');
//     } catch (e) {
//       Get.snackbar(
//         'Error',
//         'Failed to create account. Please try again.',
//         snackPosition: SnackPosition.TOP,
//         backgroundColor: Colors.red,
//         colorText: Colors.white,
//       );
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
//   void navigateToLogin() {
//     // TODO: Navigate to login screen when implemented
//     Get.snackbar(
//       'Info',
//       'Login screen not implemented yet',
//       snackPosition: SnackPosition.TOP,
//       backgroundColor: Colors.blue,
//       colorText: Colors.white,
//     );
//   }
// }
