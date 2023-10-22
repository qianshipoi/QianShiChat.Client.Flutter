import 'package:get/get_navigation/src/root/internacionalization.dart';
import 'package:qianshi_chat/locale/globalization.dart';

class LocaleMessage extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        "en_US": {
          Globalization.language: "Language",
          Globalization.english: "english",
          Globalization.otherAccountLogin: "login with other accounts",
          Globalization.account: "Account",
          Globalization.login: "Login",
          Globalization.forgetPassword: "forget password?",
          Globalization.noAccount: "no account?",
          Globalization.clickToRegister: "click to register",
          Globalization.register: "Register",
          Globalization.password: "Password",
          Globalization.errorNetwork: "network error",
          Globalization.errorAccountNoExistsOrIncorrectPassword:
              "account not exists or incoreect password",
          Globalization.accountCanNotBeEmpty: "account can not be empty",
          Globalization.accountIsTooShort: "account is too short",
          Globalization.passwordCanNotBeEmpty: "password can not be empty",
          Globalization.actionCancel: "cancel",
          Globalization.error: "Error",
        },
        "zh_CN": {
          Globalization.language: "语言",
          Globalization.english: "英语",
          Globalization.otherAccountLogin: "其他账号登录",
          Globalization.account: "账号",
          Globalization.login: "登录",
          Globalization.forgetPassword: "忘记密码？",
          Globalization.noAccount: "没有账号？",
          Globalization.clickToRegister: "点击注册",
          Globalization.register: "注册",
          Globalization.password: "密码",
          Globalization.errorNetwork: "网络异常",
          Globalization.errorAccountNoExistsOrIncorrectPassword: "账号或密码错误",
          Globalization.accountCanNotBeEmpty: "账号不能为空",
          Globalization.accountIsTooShort: "账号太短",
          Globalization.passwordCanNotBeEmpty: "密码不能为空",
          Globalization.actionCancel: "取消",
          Globalization.error: "错误",
        },
      };
}
