import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:qianshi_chat/constants.dart';
import 'package:qianshi_chat/locale/globalization.dart';
import 'package:qianshi_chat/main.dart';
import 'package:qianshi_chat/models/userinfo.dart';
import 'package:qianshi_chat/pages/home_page.dart';
import 'package:qianshi_chat/pages/register_page.dart';
import 'package:qianshi_chat/providers/auth_provider.dart';
import 'package:qianshi_chat/stores/index_controller.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<StatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey _formKey = GlobalKey<FormState>();
  final _authProvider = Get.find<AuthProvider>();
  var _isObscure = true;
  late String _account, _password;
  Color _eyeColor = Colors.grey;
  final List _loginMethod = [
    {
      'title': 'google',
      'icon': Icons.fiber_dvr,
    },
    {
      'title': 'facebook',
      'icon': Icons.facebook,
    },
    {
      'title': 'twitter',
      'icon': Icons.account_balance,
    }
  ];
  final _indexController = Get.find<IndexController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: [
                const SizedBox(
                  height: kToolbarHeight,
                ),
                buildTitle(),
                buildTitleLine(),
                const SizedBox(height: 50),
                buildAccountTextField(),
                const SizedBox(height: 30),
                buildPasswordTextField(context),
                buildForgetPasswordText(context),
                buildLanguageSelect(context),
                const SizedBox(height: 50),
                buildLoginButton(context),
                const SizedBox(height: 30),
                buildOtherLoginText(),
                buildOtherMethod(context),
                buildRegisterText(context),
              ],
            )));
  }

  Widget buildTitle() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        Globalization.login.tr,
        style: const TextStyle(fontSize: 42),
      ),
    );
  }

  Widget buildTitleLine() {
    return Padding(
      padding: const EdgeInsets.only(left: 12.0, top: 4.0),
      child: Align(
        alignment: Alignment.bottomLeft,
        child: Container(
          color: Colors.black,
          width: 40,
          height: 2,
        ),
      ),
    );
  }

  Widget buildAccountTextField() {
    return TextFormField(
      decoration: InputDecoration(labelText: Globalization.account.tr),
      validator: (v) {
        if (v!.trim().isEmpty) {
          return Globalization.accountCanNotBeEmpty.tr;
        }
        if (v.length < 3) {
          return Globalization.accountIsTooShort.tr;
        }
        return null;
      },
      onSaved: (v) => _account = v!,
    );
  }

  Widget buildPasswordTextField(BuildContext context) {
    return TextFormField(
      obscureText: _isObscure,
      onSaved: (v) => _password = v!,
      validator: (value) {
        if (value!.isEmpty) {
          return Globalization.passwordCanNotBeEmpty.tr;
        }
        return null;
      },
      decoration: InputDecoration(
          labelText: Globalization.password.tr,
          suffixIcon: IconButton(
              onPressed: () {
                setState(() {
                  _isObscure = !_isObscure;
                  _eyeColor = _isObscure
                      ? Colors.grey
                      : Theme.of(context).iconTheme.color!;
                });
              },
              icon: Icon(
                Icons.remove_red_eye,
                color: _eyeColor,
              ))),
    );
  }

  Widget buildForgetPasswordText(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Align(
        alignment: Alignment.centerRight,
        child: TextButton(
          onPressed: () {},
          child: Text(
            Globalization.forgetPassword.tr,
            style: const TextStyle(fontSize: 14, color: Colors.grey),
          ),
        ),
      ),
    );
  }

  Widget buildLoginButton(BuildContext context) {
    return SizedBox(
      height: 45,
      width: 270,
      child: ElevatedButton(
        child: Text(Globalization.login.tr,
            style: Theme.of(context).primaryTextTheme.headlineSmall),
        onPressed: () {
          if ((_formKey.currentState as FormState).validate()) {
            (_formKey.currentState as FormState).save();
            _doLogin(context);
          }
        },
      ),
    );
  }

  Widget buildOtherLoginText() {
    return Center(
        child: Text(Globalization.otherAccountLogin.tr,
            style: const TextStyle(color: Colors.grey, fontSize: 14)));
  }

  Widget buildOtherMethod(BuildContext context) {
    return ButtonBar(
      alignment: MainAxisAlignment.center,
      children: _loginMethod
          .map((item) => Builder(builder: (context) {
                return IconButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content:
                                Text(item['title'] + Globalization.login.tr),
                            action: SnackBarAction(
                              label: Globalization.actionCancel.tr,
                              onPressed: () {},
                            )),
                      );
                    },
                    icon: Icon(
                      item['icon'],
                      color: Theme.of(context).iconTheme.color,
                    ));
              }))
          .toList(),
    );
  }

  Widget buildRegisterText(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(Globalization.noAccount.tr),
        const SizedBox(
          width: 4,
        ),
        GestureDetector(
          child: Text(
            Globalization.clickToRegister.tr,
            style: const TextStyle(color: Colors.green),
          ),
          onTap: () {
            Get.to(() => const RegisterPage());
          },
        )
      ],
    );
  }

  Future _doLogin(context) async {
    try {
      var response = await _authProvider.login(_account, _password);
      if (!response.isOk) {
        throw ErrorDescription(response.toString());
      }
      var result = response.body!;
      if (!result.succeeded) {
        throw ErrorDescription(response.toString());
      }
      var token = response.headers![ApiContants.accessTokenHeaderKey]!;
      var user = UserInfo.fromMap(result.data);
      initLoginInfo(token, user);
      Get.off(() => const HomePage());
    } catch (e) {
      logger.e(e);
      Get.snackbar(Globalization.error.tr,
          Globalization.errorAccountNoExistsOrIncorrectPassword.tr,
          backgroundColor: Theme.of(context).primaryColor);
    }
  }

  Widget buildLanguageSelect(BuildContext context) {
    return DropdownButtonFormField<Language>(
        decoration: InputDecoration(
          labelText: Globalization.language.tr,
        ),
        value: _indexController.currentLanguage.value,
        items: _indexController.languages
            .map((e) => DropdownMenuItem<Language>(
                  value: e,
                  child: Text(e.displayName),
                ))
            .toList(),
        onChanged: (val) {
          if (val == null) return;
          _indexController.currentLanguage.value = val;
        });
  }
}
