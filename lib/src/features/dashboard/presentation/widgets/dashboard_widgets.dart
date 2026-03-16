import 'package:flutter/material.dart';

class QuamaaCard extends StatelessWidget {
  const QuamaaCard({super.key, this.title, this.trailing, required this.child});

  final String? title;
  final Widget? trailing;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (title != null || trailing != null) ...[
              Row(
                children: [
                  if (title != null)
                    Text(
                      title!,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  const Spacer(),
                  if (trailing != null) trailing!,
                ],
              ),
              const SizedBox(height: 12),
            ],
            child,
          ],
        ),
      ),
    );
  }
}

class Ring extends StatelessWidget {
  const Ring({
    super.key,
    required this.color,
    required this.value,
    required this.label,
    required this.caption,
  });

  final Color color;
  final double value;
  final String label;
  final String caption;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 96,
          width: 96,
          child: Stack(
            fit: StackFit.expand,
            children: [
              CircularProgressIndicator(
                value: value,
                strokeWidth: 8,
                color: color,
                backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
              ),
              Center(
                child: Text(
                  '${(value * 100).round()}%',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(label, style: Theme.of(context).textTheme.bodyMedium),
        Text(caption, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}

enum Tone { neutral, warn, error }

class AlertChip extends StatelessWidget {
  const AlertChip({super.key, required this.label, this.tone = Tone.neutral});

  final String label;
  final Tone tone;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final (bg, fg) = switch (tone) {
      Tone.warn => (cs.secondaryContainer, cs.onSecondaryContainer),
      Tone.error => (cs.errorContainer, cs.onErrorContainer),
      _ => (cs.surfaceVariant, cs.onSurfaceVariant),
    };
    return Chip(
      label: Text(label),
      backgroundColor: bg,
      side: BorderSide(color: cs.outlineVariant),
      labelStyle: TextStyle(color: fg),
    );
  }
}

class BarRow extends StatelessWidget {
  const BarRow({
    super.key,
    required this.label,
    required this.value,
    required this.caption,
  });

  final String label;
  final double value;
  final String caption;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: Text(label)),
              Text(caption, style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: value,
              minHeight: 8,
              backgroundColor: cs.surfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class ActionButton extends StatelessWidget {
  const ActionButton({super.key, required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () {},
      icon: Icon(icon),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }
}
