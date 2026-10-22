import 'package:adv/Features/auth/presentation/manager/auth_cubit/auth_cubit.dart';
import 'package:adv/core/exports/ui_exports.dart';
import 'package:adv/core/helpers/validation_service.dart';
import 'package:adv/core/routing/app_router.dart';
import 'package:adv/core/services/setup_service_locator.dart';
import 'package:adv/Features/onboarding/domain/use_cases/is_onboarding_completed_use_case.dart';
import 'package:adv/Features/onboarding/domain/use_cases/complete_onboarding_use_case.dart';
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
          listener: (context, state) async {
            if (state is AuthAuthenticated && state.fromSignUp) {
              if (!context.mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Welcome, ${state.user.email}.'),
                ),
              );

              final completeOnboarding =
                  AppRouter.parseCompleteOnboarding(GoRouterState.of(context));
              if (completeOnboarding) {
                // The 4 interests picked before sign-up were already synced
                // to `profiles` by AuthRepoImpl.signUp()'s automatic
                // syncPendingProfile() call — just mark onboarding done and
                // go straight to Home instead of resuming the page flow.
                await getIt.get<CompleteOnboardingUseCase>()();
                if (!context.mounted) return;
                context.go(AppRouter.kHomeView);
                return;
              }

              final completed =
                  await getIt.get<IsOnboardingCompletedUseCase>()();
              if (!context.mounted) return;
              if (completed) {
                context.go(AppRouter.kHomeView);
              } else {
                context.go(AppRouter.onboardingPath(startPage: 1));
              }
            } else if (state is AuthEmailConfirmationRequired) {
              if (!context.mounted) return;
              // The account exists but there's no session yet — nothing was
              // synced. Say so plainly instead of pretending sign-up
              // finished, and send them to sign in once they've confirmed.
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  duration: const Duration(seconds: 6),
                  content: Text(
                    'Check ${state.email} for a confirmation link, then sign '
                    'in to finish setting up your account.',
                  ),
                ),
              );
              final completeOnboarding =
                  AppRouter.parseCompleteOnboarding(GoRouterState.of(context));
              context.go(
                completeOnboarding
                    ? AppRouter.signInToCompleteOnboardingPath()
                    : AppRouter.kAuthSignIn,
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
                      onPressed: loading
                          ? null
                          : () {
                              final completeOnboarding =
                                  AppRouter.parseCompleteOnboarding(
                                GoRouterState.of(context),
                              );
                              context.push(
                                completeOnboarding
                                    ? AppRouter.signInToCompleteOnboardingPath()
                                    : AppRouter.kAuthSignIn,
                              );
                            },
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
