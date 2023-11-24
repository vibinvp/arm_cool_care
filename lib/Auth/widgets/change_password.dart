import 'package:arm_cool_care/Auth/widgets/textformfield.dart';
import 'package:arm_cool_care/General/AppConstant.dart';
import 'package:arm_cool_care/dbhelper/database_helper.dart';
import 'package:flutter/material.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({Key? key}) : super(key: key);

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.tela,
      appBar: AppBar(
        title: const Text("Change Password"),
      ),
      body: Container(
        margin: const EdgeInsets.only(
          left: 20,
          right: 20,
        ),
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.width / 1.8,
            ),
            enterNewPasswordTextField(),
            const SizedBox(
              height: 10,
            ),
            confirmPasswordTextField(),
            const SizedBox(
              height: 10,
            ),
            MaterialButton(
              onPressed: () {
                print("len----->${passwordController.text.length}");
                if (passwordController.text.length > 4 &&
                    passwordController.text == confirmPasswordController.text) {
                  setState(() {
                    isLoading = true;
                  });
                  updateAny('customers', 'password',
                          confirmPasswordController.text)
                      .then((value) {
                    setState(() {
                      isLoading = false;
                    });
                  });
                } else {
                  showLongToast('Check your password fields again...');
                }
              },
              color: AppColors.tela,
              textColor: AppColors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "Change",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget enterNewPasswordTextField() {
    return CustomTextField(
      hint: 'Enter new password',
      textEditingController: passwordController,
      keyboardType: TextInputType.text,
      icon: Icons.password,
      obscureText: true,
    );
  }

  Widget confirmPasswordTextField() {
    return CustomTextField(
      hint: 'Confirm password',
      textEditingController: confirmPasswordController,
      keyboardType: TextInputType.text,
      icon: Icons.password,
      obscureText: true,
    );
  }
}
