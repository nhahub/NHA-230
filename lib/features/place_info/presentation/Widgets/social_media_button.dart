import 'package:flutter/material.dart';
import 'package:tal3a/L10n/app_localizations.dart';
import 'package:tal3a/core/constants/app_colors..dart';
import 'package:tal3a/core/constants/app_sizes.dart';
import 'package:url_launcher/url_launcher.dart';

class SocialMediaButton extends StatelessWidget {
  final String? url;

  const SocialMediaButton({super.key, this.url});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (url == null || url!.isEmpty) return const SizedBox.shrink();

    return Center(
      child: TextButton.icon(
        onPressed: () => _openLink(url),
        icon: const Icon(Icons.link, color: Colors.white),
        label: Text(
          AppLocalizations.of(context)!.visitOnSocialMedia,
          style: theme.textTheme.bodyLarge?.copyWith(
            color: Colors.white,
            fontSize: AppSizes.width56,
            fontWeight: FontWeight.w600,
          ),
        ),
        style: TextButton.styleFrom(
          backgroundColor: AppColors.primaryBlue,
          padding: EdgeInsets.symmetric(
            horizontal: AppSizes.width24,
            vertical: AppSizes.height12,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.radius100),
          ),
        ),
      ),
    );
  }

  Future<void> _openLink(String? urlString) async {
    if (urlString == null || urlString.trim().isEmpty) return;

    final trimmed = urlString.trim();
    final link = trimmed.startsWith('http') ? trimmed : 'https://$trimmed';
    final Uri uri = Uri.parse(link);

    try {
      if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
        await launchUrl(uri, mode: LaunchMode.inAppWebView);
      }
    } catch (e) {
      debugPrint('⚠️ Error launching URL: $e');
    }
  }
}
