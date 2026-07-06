import 'package:flutter/material.dart';

class PermissionStepWidget extends StatelessWidget {
  const PermissionStepWidget({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    required this.granted,
    required this.grantButtonLabel,
    required this.onGrant,
    required this.onContinue,
    this.optional = false,
  });

  final IconData icon;
  final String title;
  final String description;
  final bool granted;
  final String grantButtonLabel;
  final VoidCallback onGrant;
  final VoidCallback onContinue;
  final bool optional;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 72, color: Theme.of(context).colorScheme.primary),
          const SizedBox(height: 24),
          Text(
            title,
            style: Theme.of(context).textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            description,
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          if (granted)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.check_circle, color: Colors.green),
                const SizedBox(width: 8),
                Text(
                  'Granted',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(color: Colors.green),
                ),
              ],
            )
          else
            FilledButton(onPressed: onGrant, child: Text(grantButtonLabel)),
          const SizedBox(height: 16),
          if (granted)
            FilledButton.tonal(
              onPressed: onContinue,
              child: const Text('Continue'),
            )
          else if (optional)
            TextButton(onPressed: onContinue, child: const Text('Skip')),
        ],
      ),
    );
  }
}
