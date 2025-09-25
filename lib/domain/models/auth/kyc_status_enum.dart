import 'dart:ui';

import 'package:zavona_flutter_app/res/values/app_colors.dart';

/// "pending', 'pending_approval', 'verified', 'rejected'
enum KycStatus {
  pending('pending'),
  pendingApproval('pending_approval'),
  verified('verified'),
  rejected('rejected');

  final String code;
  const KycStatus(this.code);

  static KycStatus? fromCode(String code) {
    for (var status in KycStatus.values) {
      if (status.code == code) {
        return status;
      }
    }
    return null;
  }
}

extension KycStatusExtension on KycStatus? {
  String get displayName {
    switch (this) {
      case KycStatus.pending:
        return 'Pending';
      case KycStatus.pendingApproval:
        return 'Pending Approval';
      case KycStatus.verified:
        return 'Verified';
      case KycStatus.rejected:
        return 'Rejected';
      default:
        return 'Unknown';
    }
  }

  bool get isVerified => this == KycStatus.verified;

  bool get requiresAction =>
      this == KycStatus.pending || this == KycStatus.rejected;

  Color get color {
    switch (this) {
      case KycStatus.pending:
        return AppColors.darkGray;
      case KycStatus.pendingApproval:
        return AppColors.warning;
      case KycStatus.verified:
        return AppColors.success;
      case KycStatus.rejected:
        return AppColors.error;
      default:
        return AppColors.darkGray;
    }
  }
}
