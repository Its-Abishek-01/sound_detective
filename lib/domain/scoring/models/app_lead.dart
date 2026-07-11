/// A possible-but-unverified suspect surfaced only on an unknown
/// result (`AnalysisResult.isUnknown`) — an app that had *some*
/// background activity nearby (moved to foreground/background,
/// started/stopped a foreground service), not a scored candidate.
/// Never claims to be an answer, only a lead worth the user checking
/// themselves.
class AppLead {
  const AppLead({required this.packageName, required this.appName});

  final String packageName;
  final String appName;

  factory AppLead.fromChannelMap(Map<dynamic, dynamic> map) {
    return AppLead(
      packageName: map['packageName'] as String,
      appName: map['appName'] as String,
    );
  }
}
