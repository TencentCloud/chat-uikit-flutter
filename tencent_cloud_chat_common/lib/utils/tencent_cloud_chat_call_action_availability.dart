bool shouldEnableDirectCallActions({
  required String? userID,
  required String? groupID,
  required bool Function({required String userID}) getUserOnlineStatus,
}) {
  final normalizedGroupID = groupID?.trim();
  if (normalizedGroupID != null && normalizedGroupID.isNotEmpty) {
    return true;
  }

  final normalizedUserID = userID?.trim();
  if (normalizedUserID == null || normalizedUserID.isEmpty) {
    return false;
  }

  return getUserOnlineStatus(userID: normalizedUserID);
}
