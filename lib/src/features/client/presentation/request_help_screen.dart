import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../data/request_service.dart';

class RequestHelpScreen extends StatefulWidget {
  const RequestHelpScreen({super.key});

  @override
  State<RequestHelpScreen> createState() => _RequestHelpScreenState();
}

class _RequestHelpScreenState extends State<RequestHelpScreen> {
  final _topicController = TextEditingController();
  final _messageController = TextEditingController();
  bool _isSending = false;

  @override
  void dispose() {
    _topicController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final topic = _topicController.text.trim();
    final message = _messageController.text.trim();

    if (topic.isEmpty || message.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in topic and message.')),
      );
      return;
    }

    setState(() => _isSending = true);
    try {
      await RequestService().createHelpRequest(topic: topic, message: message);
      if (mounted) context.go('/client/waiting');
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to create request: $e')),
      );
    } finally {
      if (mounted) setState(() => _isSending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Request help'),
      ),

      // Scrollable body so keyboard/small screens don't overflow
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // --- Logo (optional) ---
            Center(
              child: Column(
                children: [
                  Image.asset(
                    'assets/images/openheart_logo.png',
                    height: 72,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),

            TextField(
              controller: _topicController,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                labelText: 'Topic',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),

            TextField(
              controller: _messageController,
              minLines: 6,
              maxLines: 10,
              decoration: const InputDecoration(
                labelText: 'What do you need help with?',
                border: OutlineInputBorder(),
                alignLabelWithHint: true,
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),

      // Button pinned to bottom; moves up with keyboard
      bottomNavigationBar: SafeArea(
        child: AnimatedPadding(
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeOut,
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            bottom: 16 + MediaQuery.of(context).viewInsets.bottom,
            top: 8,
          ),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isSending ? null : _submit,
              child: Text(_isSending ? 'Sending…' : 'Submit'),
            ),
          ),
        ),
      ),
    );
  }
}
