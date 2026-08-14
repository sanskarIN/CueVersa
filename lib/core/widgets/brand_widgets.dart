import 'package:flutter/material.dart';

import '../../core/constants/project_links.dart';
import '../../core/utils/external_links.dart';
import '../../l10n/app_localizations.dart';

class CueVerseMark extends StatelessWidget {
  const CueVerseMark({this.size = 72, super.key});

  final double size;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    return Semantics(
      image: true,
      label: '${localizations.appName}. ${localizations.tagline}',
      child: ExcludeSemantics(
        child: CustomPaint(size: Size.square(size), painter: _MarkPainter()),
      ),
    );
  }
}

class CreatorWatermark extends StatelessWidget {
  const CreatorWatermark({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      AppLocalizations.of(context).madeBy,
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.labelMedium?.copyWith(
        color: Theme.of(context).colorScheme.onSurfaceVariant,
        letterSpacing: .5,
      ),
    );
  }
}

class BmcSupportCard extends StatelessWidget {
  const BmcSupportCard({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final colors = Theme.of(context).colorScheme;
    return Semantics(
      button: true,
      link: true,
      label: localizations.supportLabel,
      hint: localizations.openExternalLink,
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () => openExternalLink(context, ProjectLinks.buyMeACoffee),
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 116),
            child: Ink(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: <Color>[
                    colors.primaryContainer,
                    colors.tertiaryContainer,
                  ],
                ),
              ),
              padding: const EdgeInsets.all(20),
              child: Row(
                children: <Widget>[
                  DecoratedBox(
                    decoration: BoxDecoration(
                      color: colors.surface.withValues(alpha: .85),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(14),
                      child: Icon(Icons.coffee_rounded, size: 34),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          localizations.supportProject,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          localizations.supportDisclaimer,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(Icons.open_in_new_rounded),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

final class _MarkPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = size.shortestSide / 2;
    final background = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: <Color>[Color(0xFF00A889), Color(0xFF073B52)],
      ).createShader(Offset.zero & size);
    canvas.drawCircle(center, radius, background);

    final ball = Paint()..color = const Color(0xFFF7C948);
    canvas.drawCircle(
      Offset(size.width * .63, size.height * .62),
      radius * .28,
      ball,
    );
    final cue = Paint()
      ..color = const Color(0xFFF4F8F7)
      ..strokeWidth = radius * .11
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(
      Offset(size.width * .22, size.height * .18),
      Offset(size.width * .56, size.height * .52),
      cue,
    );
    final orbit = Paint()
      ..color = const Color(0xFFA6F3DF)
      ..style = PaintingStyle.stroke
      ..strokeWidth = radius * .065;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius * .72),
      -.3,
      4.3,
      false,
      orbit,
    );
  }

  @override
  bool shouldRepaint(_MarkPainter oldDelegate) => false;
}
