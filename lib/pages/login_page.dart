import 'dart:convert';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:qianshi_chat/main.dart';
import 'package:qianshi_chat/models/global_response.dart';
import 'package:qianshi_chat/models/userinfo.dart';
import 'package:qianshi_chat/pages/home_page.dart';
import 'package:qianshi_chat/utils/http/http_util.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<StatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey _formKey = GlobalKey<FormState>();
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
    return const Padding(
      padding: EdgeInsets.all(8.0),
      child: Text(
        'Login',
        style: TextStyle(fontSize: 42),
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
      decoration: const InputDecoration(labelText: 'Account'),
      validator: (v) {
        if (v!.trim().isEmpty) {
          return 'Account is empty';
        }
        if (v.length < 3) {
          return 'Account is too short';
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
          return 'Password is empty';
        }
        return null;
      },
      decoration: InputDecoration(
          labelText: 'Password',
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
          onPressed: () {
            logger.i('忘记密码');
          },
          child: const Text(
            '忘记密码？',
            style: TextStyle(fontSize: 14, color: Colors.grey),
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
        style: ButtonStyle(
          // 设置圆角
          shape: MaterialStateProperty.all(
              const StadiumBorder(side: BorderSide(style: BorderStyle.none))),
        ),
        child: Text('Login',
            style: Theme.of(context).primaryTextTheme.headlineLarge),
        onPressed: () {
          // 表单校验通过才会继续执行
          if ((_formKey.currentState as FormState).validate()) {
            (_formKey.currentState as FormState).save();
            _doLogin(context);
          }
        },
      ),
    );
  }

  Widget buildOtherLoginText() {
    return const Center(
        child:
            Text("其他账号登录", style: TextStyle(color: Colors.grey, fontSize: 14)));
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
                            content: Text('${item['title']}登录'),
                            action: SnackBarAction(
                              label: '取消',
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
        const Text('没有账号？'),
        GestureDetector(
          child: const Text(
            '点击注册',
            style: TextStyle(color: Colors.green),
          ),
          onTap: () {
            logger.i('去注册');
          },
        )
      ],
    );
  }

  Future _doLogin(context) async {
    try {
      var response = await HttpUtils.post('Auth',
          data: {"account": _account, "password": generateMD5(_password)});
      var result = GlobalResponse.fromMap(response.data);
      logger.i(response.headers);

      var token = response.headers['x-access-token']!.first;
      var user = UserInfo.fromJson(json.encode(result.data));
      initLoginInfo(token, user);
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const HomePage()),
          (route) => false);
    } catch (e) {
      logger.e(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: const Text('账号或密码错误'),
            action: SnackBarAction(
              label: '取消',
              onPressed: () {},
            )),
      );
    }
  }

  ///使用md5加密
  String generateMD5(String data) {
    Uint8List content = const Utf8Encoder().convert(data);
    Digest digest = md5.convert(content);
    return digest.toString();
  }
}
