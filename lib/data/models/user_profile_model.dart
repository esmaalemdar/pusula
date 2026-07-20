// ═══════════════════════════════════════════════════════════════════════════
// PUSULA — Kullanıcı Profili Modeli
// ═══════════════════════════════════════════════════════════════════════════

class UserProfile {
  final String fullName;
  final String email;
  final String membershipLevel;
  final String memberSince;
  final String maskedTc;
  final int activeFiles;
  final int completedProcesses;
  final int savedDocuments;

  const UserProfile({
    required this.fullName,
    required this.email,
    required this.membershipLevel,
    required this.memberSince,
    required this.maskedTc,
    required this.activeFiles,
    required this.completedProcesses,
    required this.savedDocuments,
  });

  // copyWith metodu eklendi
  UserProfile copyWith({
    String? fullName,
    String? email,
    String? membershipLevel,
    String? memberSince,
    String? maskedTc,
    int? activeFiles,
    int? completedProcesses,
    int? savedDocuments,
  }) {
    return UserProfile(
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      membershipLevel: membershipLevel ?? this.membershipLevel,
      memberSince: memberSince ?? this.memberSince,
      maskedTc: maskedTc ?? this.maskedTc,
      activeFiles: activeFiles ?? this.activeFiles,
      completedProcesses: completedProcesses ?? this.completedProcesses,
      savedDocuments: savedDocuments ?? this.savedDocuments,
    );
  }

  factory UserProfile.mock() {
    return const UserProfile(
      fullName: "Ahmet Yılmaz",
      email: "ahmet.yilmaz@hukuk.com",
      membershipLevel: "Gümüş",
      memberSince: "Haziran 2023",
      maskedTc: "123*****890",
      activeFiles: 3,
      completedProcesses: 12,
      savedDocuments: 45,
    );
  }
}


