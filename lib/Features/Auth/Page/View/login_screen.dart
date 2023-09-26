import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:invisquery/Core/utils/color_config.dart';
import 'package:invisquery/Core/utils/validators.dart';
import 'package:invisquery/Core/widgets/bouncing_widget.dart';
import 'package:invisquery/Core/widgets/custom_text_field.dart';
import 'package:invisquery/Core/widgets/rounded_button.dart';
import 'package:invisquery/Features/Auth/Page/Bloc/login/login_bloc.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with ValidationMixin {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> formState = GlobalKey<FormState>();
  bool passwordVisible = false;
  bool isPasswordReset = false;
  bool isSignUp = false;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (isPasswordReset) {
          isPasswordReset = false;
          setState(() {});
          return false;
        }
        if (isSignUp) {
          isSignUp = false;
          setState(() {});
          return false;
        }
        EasyLoading.dismiss();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          elevation: 1,
        ),
        body: BlocConsumer<LoginBloc, LoginState>(
          listener: (context, state) {
            if (state is FailureLogin) {
              EasyLoading.dismiss();
              EasyLoading.showError(state.failure.message);
            }
            if (state is LoginLoading) {
              EasyLoading.show(status: "");
            }
            if (state is LoginSuccess) {
              EasyLoading.dismiss();
              EasyLoading.showSuccess(
                  "Welcome to InvisQuery ${state.authModel.user.email}");
            }
            if (state is LoginPasswordResetSuccess) {
              EasyLoading.dismiss();
              EasyLoading.showInfo(
                      "password reset link has been sent to your registered email address")
                  .then((value) {
                isPasswordReset = false;
                setState(() {});
              });
            }
          },
          builder: (context, state) {
            // Default UI for the login form
            return AbsorbPointer(
              absorbing: state is LoginLoading,
              child: AnimatedOpacity(
                opacity: state is LoginLoading ? 0.5 : 1,
                duration: const Duration(milliseconds: 300),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: formState,
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Center(
                              child: Text(
                            !isPasswordReset
                                ? (isSignUp ? "Create account" : "Login")
                                : "Reset Password",
                            style: const TextStyle(
                                color: Colors.white, fontSize: 40),
                          )),
                          SizedBox(
                            height: !isPasswordReset ? 20 : 0.2.sh,
                          ),
                          if (!isPasswordReset && !isSignUp)
                            BouncingWidget(
                              duration: const Duration(milliseconds: 300),
                              onTap: () {
                                BlocProvider.of<LoginBloc>(context)
                                    .add(const AnonLogin());
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    "Skip",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 16.sp),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  const Icon(
                                    Icons.navigate_next,
                                    color: ColorConfig.primaryColor,
                                    size: 30,
                                  )
                                ],
                              ),
                            ),
                          if (!isPasswordReset && !isSignUp)
                            const SizedBox(
                              height: 20,
                            ),
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: CustomTextField(
                              controller: emailController,
                              keyboardType: TextInputType.emailAddress,
                              validator: (value) {
                                if (!isValidEmail(value!)) {
                                  return "Enter a valid email";
                                }
                                return null;
                              },
                              labelText: "Email",
                              hintText: "Enter a valid email",
                            ),
                          ),
                          if (!isPasswordReset) const SizedBox(height: 16),
                          if (!isPasswordReset)
                            Padding(
                              padding: const EdgeInsets.all(10),
                              child: CustomTextField(
                                controller: passwordController,
                                keyboardType: TextInputType.visiblePassword,
                                obscureText: !passwordVisible,
                                maxLines: 1,
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      passwordVisible = !passwordVisible;
                                    });
                                  },
                                  icon: Icon(
                                    passwordVisible
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                    color: Colors.white,
                                  ),
                                ),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Enter a valid email";
                                  }
                                  if (isPasswordReset &&
                                      isValidPassword(value)) {
                                    return "one digit, one special character, and a minimum length of 8 characters.";
                                  }
                                  return null;
                                },
                                labelText: "Password",
                                hintText: "Enter a valid password",
                              ),
                            ),
                          if (!isPasswordReset && !isSignUp)
                            const SizedBox(height: 16),
                          if (!isPasswordReset && !isSignUp)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                BouncingWidget(
                                  onTap: () {
                                    setState(() {
                                      isPasswordReset = true;
                                    });
                                  },
                                  duration: const Duration(milliseconds: 300),
                                  child: Center(
                                    child: RichText(
                                      text: TextSpan(children: [
                                        TextSpan(
                                            text: "Forgot password?",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14.sp,
                                            )),
                                      ]),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          const SizedBox(height: 16),
                          CustomRoundedButton(
                            width: 0.5.sw,
                            border: Border.all(color: ColorConfig.primaryColor),
                            borderRadius: BorderRadius.circular(16.r),
                            onTap: () {
                              if (formState.currentState!.validate()) {
                                if (!isPasswordReset) {
                                  // Dispatch a login event when the button is pressed
                                  final email = emailController.text;
                                  final password = passwordController.text;
                                  BlocProvider.of<LoginBloc>(context).add(
                                    LoginPasswordBasedEvent(
                                      isNewAccount: isSignUp,
                                      email: email,
                                      password: password,
                                    ),
                                  );
                                } else {
                                  BlocProvider.of<LoginBloc>(context).add(
                                      ResetPasswordEvent(emailController.text));
                                }
                              }
                            },
                            child: Text(
                              !isPasswordReset
                                  ? (isSignUp ? "Sign-up" : "Login")
                                  : "Reset Password",
                              style: TextStyle(
                                  color: Colors.white, fontSize: 16.sp),
                            ),
                          ),
                          if (!isPasswordReset) const SizedBox(height: 20),
                          if (!isPasswordReset)
                            BouncingWidget(
                              onTap: () {
                                setState(() {
                                  isSignUp = !isSignUp;
                                });
                              },
                              duration: const Duration(milliseconds: 300),
                              child: Center(
                                child: RichText(
                                  text: TextSpan(children: [
                                    TextSpan(
                                        text: !isSignUp
                                            ? "Don't have account?"
                                            : "Already have an account?",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14.sp,
                                        )),
                                    TextSpan(
                                        text:
                                            !isSignUp ? "\tSign-up" : "\tLogin",
                                        style: TextStyle(
                                          color: ColorConfig.primaryColor,
                                          fontSize: 14.sp,
                                        ))
                                  ]),
                                ),
                              ),
                            ),

                          /*Padding(
                            padding: const EdgeInsets.all(14),
                            child: Row(
                              children: [
                                Flexible(
                                  child: Divider(
                                    height: 10.h,
                                    thickness: 1,
                                    color: ColorConfig.kGrayColor,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 10),
                                  child: Text(
                                    "OR",
                                    style:
                                        TextStyle(color: Colors.white, fontSize: 14.sp),
                                  ),
                                ),
                                Flexible(
                                  child: Divider(
                                    height: 10.h,
                                    thickness: 1,
                                    color: ColorConfig.kGrayColor,
                                  ),
                                ),
                              ],
                            ),
                          ),*/
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
