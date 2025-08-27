import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/router/route_names.dart';

class MobileEmailPage extends StatefulWidget {
  const MobileEmailPage({super.key});

  @override
  State<MobileEmailPage> createState() => _MobileEmailPageState();
}

class _MobileEmailPageState extends State<MobileEmailPage> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  bool _isPhoneAuth = true;

  @override
  void dispose() {
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _proceedToOtp() {
    if (_formKey.currentState!.validate()) {
      final credential = _isPhoneAuth
          ? _phoneController.text
          : _emailController.text;

      context.pushNamed(RouteNames.otpVerify, extra: credential);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        backgroundColor: Colors.blue.shade600,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 40),
              Text(
                'Welcome to Zavona Parking',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade700,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Enter your mobile number or email to continue',
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(color: Colors.grey.shade600),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),

              // Toggle between phone and email
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => setState(() => _isPhoneAuth = true),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _isPhoneAuth
                            ? Colors.blue.shade600
                            : Colors.grey.shade200,
                        foregroundColor: _isPhoneAuth
                            ? Colors.white
                            : Colors.grey.shade600,
                      ),
                      child: const Text('Phone'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => setState(() => _isPhoneAuth = false),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: !_isPhoneAuth
                            ? Colors.blue.shade600
                            : Colors.grey.shade200,
                        foregroundColor: !_isPhoneAuth
                            ? Colors.white
                            : Colors.grey.shade600,
                      ),
                      child: const Text('Email'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Input field
              if (_isPhoneAuth)
                TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    labelText: 'Mobile Number',
                    prefixText: '+91 ',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your mobile number';
                    }
                    if (value.length != 10) {
                      return 'Please enter a valid 10-digit mobile number';
                    }
                    return null;
                  },
                )
              else
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'Email Address',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email address';
                    }
                    if (!RegExp(
                      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                    ).hasMatch(value)) {
                      return 'Please enter a valid email address';
                    }
                    return null;
                  },
                ),

              const SizedBox(height: 32),

              ElevatedButton(
                onPressed: _proceedToOtp,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade600,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Send OTP',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),

              const Spacer(),

              Text(
                'By continuing, you agree to our Terms of Service and Privacy Policy',
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: Colors.grey.shade600),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
