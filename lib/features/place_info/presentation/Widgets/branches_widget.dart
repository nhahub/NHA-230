import 'package:flutter/material.dart';
import 'package:tal3a/core/constants/app_colors..dart';
import 'package:tal3a/core/constants/app_sizes.dart';
import 'package:url_launcher/url_launcher.dart';

class BranchesWidget extends StatelessWidget {
  final dynamic branchesData;

  const BranchesWidget({super.key, this.branchesData});

  List<Map<String, dynamic>> get branches {
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
    if (branches.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSizes.width24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: branches.map((branch) {
          return GestureDetector(
            onTap: () => _openLink(branch['mapLink']),
            child: Container(
              margin: EdgeInsets.only(bottom: 12),
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.shadowColor,
                    blurRadius: 8,
                  ),
                ],
              ),
              child: Row(
                children: [
                  Icon(Icons.location_on,
                      color: AppColors.primaryBlue),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(branch['branchName']),
                  ),
                  Icon(Icons.arrow_forward_ios, size: 16),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Future<void> _openLink(String? link) async {
    if (link == null) return;
    final uri = Uri.parse(link);
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}
