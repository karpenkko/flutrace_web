import 'package:flutter/material.dart';
import 'package:flutrace_web/features/auth/presentation/widgets/sign_in_form.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < 600) {
            return Column(
              children: [
                SizedBox(
                  height: 200,
                  width: double.infinity,
                  child: Image.asset(
                    'assets/images/login_background.jpg',
                    fit: BoxFit.cover,
                  ),
                ),
                const Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 24),
                    child: SignInForm(),
                  ),
                ),
              ],
            );
          } else {
            return Row(
              children: [
                Flexible(
                  flex: 4,
                  child: SizedBox.expand(
                    child: Image.asset(
                      'assets/images/login_background.jpg',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const Flexible(
                  flex: 3,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 46.0, vertical: 60),
                    child: SignInForm(),
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
