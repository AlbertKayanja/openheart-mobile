import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CounsellorAuthPage extends StatefulWidget {
  const CounsellorAuthPage({super.key});

  @override
  State<CounsellorAuthPage> createState() => _CounsellorAuthPageState();
}

class _CounsellorAuthPageState extends State<CounsellorAuthPage> {
  final _formKey = GlobalKey<FormState>();

  bool isLogin = true;
  bool isLoading = false;

  final emailCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();
  final nameCtrl = TextEditingController();
  final qualificationCtrl = TextEditingController();
  final experienceCtrl = TextEditingController();

  final List<String> categories = [
    'Anxiety',
    'Depression',
    'Relationship',
    'Career',
    'Stress',
  ];

  final Set<String> selectedCategories = {};

  @override
  void dispose() {
    emailCtrl.dispose();
    passwordCtrl.dispose();
    nameCtrl.dispose();
    qualificationCtrl.dispose();
    experienceCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    if (!isLogin && selectedCategories.isEmpty) {
      _showError('Please select at least one counselling category');
      return;
    }

    setState(() => isLoading = true);

    try {
      if (isLogin) {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailCtrl.text.trim(),
          password: passwordCtrl.text.trim(),
        );
      } else {
        final cred =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailCtrl.text.trim(),
          password: passwordCtrl.text.trim(),
        );

        await FirebaseFirestore.instance
            .collection('counsellors')
            .doc(cred.user!.uid)
            .set({
          'email': emailCtrl.text.trim(),
          'name': nameCtrl.text.trim(),
          'qualification': qualificationCtrl.text.trim(),
          'experience': experienceCtrl.text.trim(),
          'categories': selectedCategories.toList(),
          'createdAt': FieldValue.serverTimestamp(),
        });
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(isLogin
              ? 'Login successful'
              : 'Registration successful'),
        ),
      );

      // 🚫 DO NOT NAVIGATE YET
      // We will add navigation ONLY after you confirm destination screen

    } on FirebaseAuthException catch (e) {
      _showError(e.message ?? 'Authentication failed');
    } catch (e) {
      _showError('Something went wrong. Please try again.');
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6EFEA),
      appBar: AppBar(
        title: const Text('Counsellor'),
        backgroundColor: const Color(0xFF6B4EFF),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Text(
                isLogin ? 'Counsellor Login' : 'Counsellor Registration',
                style:
                    const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: emailCtrl,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (v) =>
                    v == null || !v.contains('@') ? 'Invalid email' : null,
              ),
              const SizedBox(height: 10),

              TextFormField(
                controller: passwordCtrl,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Password'),
                validator: (v) =>
                    v == null || v.length < 6 ? 'Min 6 characters' : null,
              ),

              if (!isLogin) ...[
                const SizedBox(height: 10),
                TextFormField(
                  controller: nameCtrl,
                  decoration: const InputDecoration(labelText: 'Full Name'),
                  validator: (v) =>
                      v == null || v.isEmpty ? 'Required' : null,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: qualificationCtrl,
                  decoration:
                      const InputDecoration(labelText: 'Qualification'),
                  validator: (v) =>
                      v == null || v.isEmpty ? 'Required' : null,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: experienceCtrl,
                  decoration:
                      const InputDecoration(labelText: 'Experience'),
                  validator: (v) =>
                      v == null || v.isEmpty ? 'Required' : null,
                ),
                const SizedBox(height: 16),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Counselling Categories',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                ...categories.map(
                  (c) => CheckboxListTile(
                    title: Text(c),
                    value: selectedCategories.contains(c),
                    onChanged: (v) {
                      setState(() {
                        v == true
                            ? selectedCategories.add(c)
                            : selectedCategories.remove(c);
                      });
                    },
                  ),
                ),
              ],

              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: isLoading ? null : _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6B4EFF),
                ),
                child: isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text(isLogin ? 'Login' : 'Register'),
              ),

              TextButton(
                onPressed: () {
                  setState(() => isLogin = !isLogin);
                },
                child: Text(isLogin
                    ? 'New counsellor? Register'
                    : 'Already registered? Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
