import 'package:flutter/material.dart';

class SocialSignInButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onPressed;

  const SocialSignInButton({
    super.key,
    required this.label,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      width: double.infinity,
      height: 44,
      child: OutlinedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 20),
        label: Text(label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
        style: OutlinedButton.styleFrom(
          foregroundColor: theme.colorScheme.onSurface,
          side: BorderSide(color: theme.dividerColor),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }
}
