import 'package:adv/Features/Auth/presentation/manager/auth_cubit/auth_cubit.dart';
import 'package:adv/core/exports/ui_exports.dart';
import 'package:adv/core/helpers/validation_service.dart';
import 'package:adv/core/routing/app_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class AuthSignUpView extends StatefulWidget {
  const AuthSignUpView({super.key});

  @override
  State<AuthSignUpView> createState() => _AuthSignUpViewState();
}

class _AuthSignUpViewState extends State<AuthSignUpView> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirmPassword = TextEditingController();

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _confirmPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign up'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: BlocConsumer<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state is AuthAuthenticated && state.fromSignUp) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Welcome, ${state.user.email}. Pick your interests so we can set up your profile.',
                  ),
                ),
              );
              // Populate `profiles`: land on onboarding interests (`InterestsSelectionPage`).
              context.go(
                AppRouter.onboardingPath(
                  startPage: AppRouter.onboardingLastPageIndex,
                ),
              );
            } else if (state is AuthError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
          builder: (context, state) {
            final loading = state is AuthLoading;

            return SingleChildScrollView(
              padding: EdgeInsets.all(24.w),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      controller: _email,
                      decoration: const InputDecoration(labelText: 'Email'),
                      keyboardType: TextInputType.emailAddress,
                      autofillHints: const [AutofillHints.email],
                      enabled: !loading,
                      validator: ValidationService.email,
                    ),
                    SizedBox(height: 16.h),
                    TextFormField(
                      controller: _password,
                      obscureText: true,
                      decoration: const InputDecoration(labelText: 'Password'),
                      enabled: !loading,
                      validator: (v) => ValidationService.minLength(v, 6, fieldName: 'Password'),
                    ),
                    SizedBox(height: 16.h),
                    TextFormField(
                      controller: _confirmPassword,
                      obscureText: true,
                      decoration: const InputDecoration(labelText: 'Confirm password'),
                      enabled: !loading,
                      validator: (v) => ValidationService.matchFields(
                            v,
                            _password.text,
                            fieldName: 'Passwords',
                          ),
                    ),
                    SizedBox(height: 28.h),
                    FilledButton(
                      onPressed: loading
                          ? null
                          : () {
                              if (!_formKey.currentState!.validate()) return;
                              context.read<AuthCubit>().signUp(
                                    email: _email.text,
                                    password: _password.text,
                                  );
                            },
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColor.primaryColor,
                        foregroundColor: Colors.white,
                      ),
                      child: loading
                          ? const SizedBox(
                              height: 22,
                              width: 22,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text('Create account'),
                    ),
                    TextButton(
                      onPressed: loading ? null : () => context.push(AppRouter.kAuthSignIn),
                      child: Text(
                        'Already have an account? Sign in',
                        style: TextStyle(color: AppColor.primaryColor),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
