import 'package:flutter/material.dart';
import 'dashboard_page.dart';

class LoginPage extends StatefulWidget {
  final VoidCallback? onToggleTheme;
  const LoginPage({super.key, this.onToggleTheme});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _email = TextEditingController();
  final _pass = TextEditingController();
  bool _obscure = true;

  void _login() {
    final e = _email.text.trim();
    final p = _pass.text;
    if (e.isEmpty || p.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Masukkan email dan password (min 6 karakter)')));
      return;
    }
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const DashboardPage()));
  }

  Widget _leftPanel(double width) {
    final image = Image.asset('assets/welcome.jpg', fit: BoxFit.cover, errorBuilder: (context, err, st) {
      return Container(
        color: Colors.grey[300],
        child: const Center(child: Text('WELCOME', style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold))),
      );
    });

    return Container(
      width: width,
      color: Colors.white,
      child: Stack(children: [
        Positioned.fill(child: image),
        Positioned.fill(child: Container(color: Colors.black.withOpacity(0.32))),
        Positioned(
          top: 80,
          left: 50,
          right: 0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Hello,',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 41,
                  fontWeight: FontWeight.w400,
                  height: 0.6,
                ),
              ),
              const SizedBox(),
              const Text(
                'welcome!',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 55,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: Text(
                  'Rencanakan perjalananmu dengan mudah. Buat itinerary, kelola destinasi, dan atur budget.',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.88),
                    fontSize: 15,
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ]),
    );
  }

  Widget _rightForm(bool wide) {
    final padding = EdgeInsets.symmetric(horizontal: wide ? 56 : 24, vertical: wide ? 48 : 32);
    return SingleChildScrollView(
      child: Padding(
        padding: padding,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text('Login', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontSize: 28, fontWeight: FontWeight.w700)),
                const SizedBox(height: 18),
                TextField(
                  controller: _email,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(labelText: 'Email', floatingLabelBehavior: FloatingLabelBehavior.always),
                ),
                const SizedBox(height: 18),
                TextField(
                  controller: _pass,
                  obscureText: _obscure,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    suffixIcon: IconButton(
                      icon: Icon(_obscure ? Icons.visibility_off : Icons.visibility),
                      onPressed: () => setState(() => _obscure = !_obscure),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Forgot (demo)'))),
                    child: const Text('Forgot password?'),
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 52,
                  child: ElevatedButton(
                    onPressed: _login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0A6B67),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    child: const Text('Login'),
                  ),
                ),
                const SizedBox(height: 18),
                Center(
                  child: Wrap(
                    children: [
                      const Text("Don't have an account? "),
                      TextButton(onPressed: () {}, child: const Text('Sign up')),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(builder: (ctx, constraints) {
        final wide = constraints.maxWidth >= 800;
        if (wide) {
          return Row(children: [
            Expanded(flex: 11, child: _leftPanel(constraints.maxWidth * 0.55)),
            Expanded(flex: 9, child: _rightForm(true)),
          ]);
        } else {
          return Column(children: [
            SizedBox(height: 260, child: _leftPanel(constraints.maxWidth)),
            Expanded(child: _rightForm(false)),
          ]);
        }
      }),
    );
  }
}