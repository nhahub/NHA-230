import 'package:flutter/material.dart';
import 'package:tal3a/core/constants/app_colors..dart';
import 'package:tal3a/core/constants/app_sizes.dart';
import 'package:url_launcher/url_launcher.dart';

class BranchesWidget extends StatelessWidget {
  final dynamic branchesData;

  const BranchesWidget({super.key, this.branchesData});

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
    final theme = Theme
        .of(context)
        .textTheme;

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
          onPressed: () => _openLink(mapLink),
          child: Text(
            "Go to Location",
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
            "📍 Branches:",
            style: theme.headlineSmall?.copyWith(
              color: AppColors.primaryBlue,
              fontSize: AppSizes.width56,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: AppSizes.height8),

          // ✅ خلي الجزء بتاع الفروع قابل للتمرير فقط
          SizedBox(
            height: AppSizes.height320, // ارتفاع محدد علشان السكروول يشتغل كويس
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
                        : () => _openLink(mapLink),
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
                        border: Border.all(color: AppColors.shadowColor,
                            width: 1),
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
