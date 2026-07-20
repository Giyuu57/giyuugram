import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/widgets/auth_text_field.dart';
import '../../../../core/widgets/primary_button.dart';
import '../providers/auth_controller.dart';

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _fullNameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _fullNameController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleSignup() async {
    if (!_formKey.currentState!.validate()) return;
    final success = await ref.read(authControllerProvider.notifier).signUp(
          email: _emailController.text.trim(),
          password: _passwordController.text,
          username: _usernameController.text.trim(),
          fullName: _fullNameController.text.trim(),
        );
    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Check your email to confirm your account')),
      );
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);
    final isLoading = authState.status == AuthStatus.loading;

    ref.listen(authControllerProvider, (previous, next) {
      if (next.status == AuthStatus.error && next.errorMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.errorMessage!), backgroundColor: Colors.red),
        );
      }
    });

    return Scaffold(
      appBar: AppBar(leading: const BackButton()),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20),
                const Text(
                  'Giyuugram',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 32),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Sign up to see photos and videos from your friends.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 32),
                AuthTextField(
                  controller: _emailController,
                  hintText: 'Email',
                  keyboardType: TextInputType.emailAddress,
                  validator: (v) =>
                      (v == null || !v.contains('@')) ? 'Enter a valid email' : null,
                ),
                const SizedBox(height: 8),
                AuthTextField(
                  controller: _fullNameController,
                  hintText: 'Full Name',
                  validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
                ),
                const SizedBox(height: 8),
                AuthTextField(
                  controller: _usernameController,
                  hintText: 'Username',
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return 'Required';
                    if (!RegExp(r'^[a-zA-Z0-9._]{3,30}$').hasMatch(v)) {
                      return 'Letters, numbers, dots, underscores only';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 8),
                AuthTextField(
                  controller: _passwordController,
                  hintText: 'Password',
                  obscureText: _obscurePassword,
                  validator: (v) =>
                      (v == null || v.length < 6) ? 'Min 6 characters' : null,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword ? Icons.visibility_off : Icons.visibility,
                      size: 20,
                    ),
                    onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                  ),
                ),
                const SizedBox(height: 20),
                PrimaryButton(
                  label: 'Sign up',
                  isLoading: isLoading,
                  onPressed: _handleSignup,
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Have an account? '),
                    GestureDetector(
                      onTap: () => context.pop(),
                      child: const Text('Log in', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
