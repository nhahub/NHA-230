import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_url_extractor/url_extractor.dart';
import 'package:tal3a/L10n/app_localizations.dart';
import 'package:tal3a/core/constants/app_colors..dart';
import 'package:tal3a/core/constants/app_sizes.dart';
import 'package:url_launcher/url_launcher.dart';

class BranchesWidget extends StatelessWidget {
  final dynamic branchesData;
  final void Function(double lat, double lng)? onMapLinkTap;

  const BranchesWidget({
    super.key,
    this.branchesData,
    this.onMapLinkTap,
  });

  List<Map<String, dynamic>> get branchesList {
    if (branchesData == null) return [];
    if (branchesData is List) {
      return branchesData.whereType<Map<String, dynamic>>().toList();
    }
    if (branchesData is Map<String, dynamic>) {
      return [branchesData];
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    final localizations = AppLocalizations.of(context)!;

    // ✅ الحالة الأولى: branchesData = String
    if (branchesData is String) {
      final mapLink = branchesData as String;
      return Align(
        alignment: Alignment.center,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryBlue,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSizes.radius100),
            ),
            padding: EdgeInsets.symmetric(
              horizontal: AppSizes.width40,
              vertical: AppSizes.height8,
            ),
          ),
          onPressed: () => _handleMapLink(context, mapLink),
          child: Text(
            localizations.goToLocation,
            style: theme.bodyLarge?.copyWith(
              color: Colors.white,
              fontSize: AppSizes.width56,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      );
    }

    // ✅ الحالة الثانية: List أو Map
    if (branchesList.isEmpty) return const SizedBox.shrink();

    return Align(
      alignment: Alignment.center,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            localizations.branches,
            style: theme.headlineSmall?.copyWith(
              color: AppColors.primaryBlue,
              fontSize: AppSizes.width56,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: AppSizes.height8),
          SizedBox(
            height: AppSizes.height320,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: branchesList.map((branch) {
                  final branchName =
                  (branch['branchName'] ?? 'Unnamed Branch').toString();
                  final mapLink = branch['mapLink']?.toString();

                  return GestureDetector(
                    onTap: mapLink == null || mapLink.isEmpty
                        ? null
                        : () => _handleMapLink(context, mapLink),
                    child: Container(
                      width: AppSizes.width400,
                      height: AppSizes.height90,
                      margin: EdgeInsets.symmetric(
                        vertical: AppSizes.height8,
                        horizontal: AppSizes.width20,
                      ),
                      padding: EdgeInsets.all(AppSizes.height20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(AppSizes.radius100),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.grey,
                            blurRadius: 6,
                            offset: Offset(0, 3),
                          ),
                        ],
                        border: Border.all(
                          color: AppColors.shadowColor,
                          width: 1,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          branchName,
                          textAlign: TextAlign.center,
                          style: theme.bodyLarge?.copyWith(
                            fontSize: AppSizes.width48,
                            color: AppColors.primaryBlue,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _handleMapLink(BuildContext context, String mapLink) async {
    try {
      // استخراج الإحداثيات من رابط Google Maps
      final result = await GoogleMapsUrlExtractor.processGoogleMapsUrl(mapLink);

      if (result != null && onMapLinkTap != null) {
        final lat = result['latitude']!;
        final lng = result['longitude']!;

        // استدعاء الـ callback لإرسال الإحداثيات لشاشة الماب
        onMapLinkTap!(lat, lng);
        return;
      }
      final coords = _extractCoordinates(mapLink);
      if (coords != null && onMapLinkTap != null) {
        onMapLinkTap!(coords['lat']!, coords['lng']!);
        return;
      }
      await _openLink(mapLink);

    } catch (e) {
      if (kDebugMode) {
        print('⚠️ Error extracting coordinates: $e');
      }
    }
  }



  // ✅ استخراج الإحداثيات من رابط Google Maps
  Map<String, double>? _extractCoordinates(String url) {
    try {
      // صيغة 1: https://maps.google.com/?q=31.2001,29.9187
      if (url.contains('q=')) {
        final match = RegExp(r'q=([-\d.]+),([-\d.]+)').firstMatch(url);
        if (match != null) {
          return {
            'lat': double.parse(match.group(1)!),
            'lng': double.parse(match.group(2)!),
          };
        }
      }

      // صيغة 2: https://www.google.com/maps/@31.2001,29.9187,15z
      if (url.contains('@')) {
        final match = RegExp(r'@([-\d.]+),([-\d.]+)').firstMatch(url);
        if (match != null) {
          return {
            'lat': double.parse(match.group(1)!),
            'lng': double.parse(match.group(2)!),
          };
        }
      }

      // صيغة 3: https://goo.gl/maps/xyz (يحتاج معالجة خاصة)
      // يمكن إضافة معالجة للروابط المختصرة إذا لزم الأمر

      return null;
    } catch (e) {
      debugPrint('⚠️ Error extracting coordinates: $e');
      return null;
    }
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