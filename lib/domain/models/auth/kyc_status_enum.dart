import 'dart:ui';

import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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

/// "pending', 'pending_approval', 'verified', 'rejected'
enum ParkingVerificationStatus {
  pending('pending'),
  pendingApproval('pending_approval'),
  verified('verified'),
  rejected('rejected');

  final String code;
  const ParkingVerificationStatus(this.code);

  static ParkingVerificationStatus? fromCode(String code) {
    for (var status in ParkingVerificationStatus.values) {
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

extension ParkingVerificationStatusExtension on ParkingVerificationStatus? {
  String displayName(KycStatus? ownerKycStatus) {
    switch (this) {
      case ParkingVerificationStatus.pending:
        return 'Pending';
      case ParkingVerificationStatus.pendingApproval:
        return 'Pending Approval';
      case ParkingVerificationStatus.verified:
        return ownerKycStatus == KycStatus.verified
            ? 'Dual Verified'
            : 'Verified';
      case ParkingVerificationStatus.rejected:
        return 'Rejected';
      default:
        return 'Not Verified';
    }
  }

  bool get isVerified => this == ParkingVerificationStatus.verified;

  bool get requiresAction =>
      this == ParkingVerificationStatus.pending ||
      this == ParkingVerificationStatus.rejected;

  Color color(KycStatus? ownerKycStatus) {
    switch (this) {
      case ParkingVerificationStatus.pending:
        return AppColors.darkGray;
      case ParkingVerificationStatus.pendingApproval:
        return AppColors.warning;
      case ParkingVerificationStatus.verified:
        return ownerKycStatus == KycStatus.verified
            ? AppColors.success
            : AppColors.warning;
      case ParkingVerificationStatus.rejected:
        return AppColors.error;
      default:
        return AppColors.darkGray;
    }
  }

  IconData icon(KycStatus? ownerKycStatus) {
    switch (this) {
      case ParkingVerificationStatus.pending:
        return FontAwesomeIcons.clock;
      case ParkingVerificationStatus.pendingApproval:
        return FontAwesomeIcons.clock;
      case ParkingVerificationStatus.verified:
        return ownerKycStatus == KycStatus.verified
            ? FontAwesomeIcons.solidCircleCheck
            : FontAwesomeIcons.circleCheck;
      case ParkingVerificationStatus.rejected:
        return FontAwesomeIcons.solidCircleXmark;
      default:
        return FontAwesomeIcons.upload;
    }
  }
}
