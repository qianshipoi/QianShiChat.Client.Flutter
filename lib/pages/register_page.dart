import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qianshi_chat/main.dart';
import 'package:qianshi_chat/models/avatar.dart';
import 'package:qianshi_chat/models/paged_list.dart';
import 'package:qianshi_chat/models/userinfo.dart';
import 'package:qianshi_chat/pages/home_page.dart';
import 'package:qianshi_chat/providers/avatar_provider.dart';
import 'package:qianshi_chat/providers/user_provider.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final avatarProvider = Get.find<AvatarProvider>();
  final userProvider = Get.find<UserProvider>();
  final GlobalKey _formKey = GlobalKey<FormState>();
  var _isObscure = true;
  late String _account, _password, _nickName;
  Color _eyeColor = Colors.grey;
  final _avatar = Rxn<Avatar>();
  final avatars = <Avatar>[].obs;

  @override
  void initState() {
    super.initState();
    _getFirstAvatar();
  }

  _getFirstAvatar() async {
    var response = await avatarProvider.defaults(1);
    if (!response.isOk) {
      Get.snackbar('Error', "获取默认头像失败");
      return;
    }
    var paged = PagedList.fromMap(response.body!.data);
    var avatars = List<Map<String, dynamic>>.from(paged.items)
        .map((e) => Avatar.fromMap(e))
        .toList();
    setState(() {
      _avatar.value = avatars.first;
    });
  }

  _getDefaultAvatars() async {
    if (avatars.isNotEmpty) {
      return;
    }
    var response = await avatarProvider.defaults(20);
    if (!response.isOk) {
      Get.snackbar('Error', "获取默认头像失败");
      return;
    }
    var paged = PagedList.fromMap(response.body!.data);
    avatars.addAll(List<Map<String, dynamic>>.from(paged.items)
        .map((e) => Avatar.fromMap(e))
        .toList());
  }

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
                buildAvatar(context),
                buildAccountTextField(),
                const SizedBox(height: 30),
                buildPasswordTextField(context),
                const SizedBox(height: 30),
                buildNickNameTextField(),
                const SizedBox(height: 50),
                buildLoginButton(context),
                const SizedBox(height: 30),
                buildRegisterText(context),
              ],
            )));
  }

  Widget buildTitle() {
    return const Padding(
      padding: EdgeInsets.all(8.0),
      child: Text(
        'Register',
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

  Widget buildAvatar(context) {
    return Center(
      child: GestureDetector(
        onTap: () async {
          await _getDefaultAvatars();
          Get.bottomSheet(Container(
            color: Theme.of(context).scaffoldBackgroundColor,
            child: GridView.builder(
                padding: const EdgeInsets.all(8.0),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3),
                itemCount: avatars.length,
                itemBuilder: (context, index) {
                  var avatar = avatars[index];
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _avatar.value = avatar;
                      });
                      Get.back();
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.network(
                        avatar.path,
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                }),
          ));
        },
        child: Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: const [
                BoxShadow(
                    color: Colors.black12,
                    offset: Offset(0, 5),
                    blurRadius: 15,
                    spreadRadius: 5),
              ],
              image: DecorationImage(
                  image: NetworkImage(_avatar.value?.path ??
                      'https://chat-api.kuriyama.top/Raw/DefaultAvatar/1.jpg'),
                  fit: BoxFit.cover)),
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

  Widget buildNickNameTextField() {
    return TextFormField(
      decoration: const InputDecoration(labelText: 'NickName'),
      validator: (v) {
        if (v!.trim().isEmpty) {
          return 'NickName is empty';
        }
        return null;
      },
      onSaved: (v) => _nickName = v!,
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
        child: Text('Register',
            style: Theme.of(context).primaryTextTheme.headlineLarge),
        onPressed: () {
          // 表单校验通过才会继续执行
          if ((_formKey.currentState as FormState).validate()) {
            (_formKey.currentState as FormState).save();
            _doRegister(context);
          }
        },
      ),
    );
  }

  Widget buildRegisterText(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('已有账号？'),
        GestureDetector(
          onTap: Get.back,
          child: const Text(
            '点击登录',
            style: TextStyle(color: Colors.green),
          ),
        )
      ],
    );
  }

  Future _doRegister(context) async {
    if (_avatar.value == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: const Text('请选择头像'),
            action: SnackBarAction(
              label: '取消',
              onPressed: () {},
            )),
      );
      return;
    }
    try {
      var response = await userProvider.register(
          defaultAvatarId: _avatar.value!.id,
          account: _account,
          password: _password,
          nickname: _nickName);

      if (!response.body!.succeeded) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(response.body!.errors),
              action: SnackBarAction(
                label: '取消',
                onPressed: () {},
              )),
        );
        return;
      }

      var token = response.headers!['x-access-token']!;
      var user = UserInfo.fromMap(response.body!.data);
      initLoginInfo(token, user);
      Get.off(() => const HomePage());
    } catch (e) {
      logger.e(e);
      Get.snackbar('Error', "注册失败",
          backgroundColor: const Color.fromARGB(255, 168, 92, 92));
    }
  }
}
