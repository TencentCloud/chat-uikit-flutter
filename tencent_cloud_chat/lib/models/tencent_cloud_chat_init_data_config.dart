class TencentCloudChatInitDataConfig {
  bool? getConversationDataAfterInit = true;
  bool? getJoinedGroupListDataAfterInit = false;
  bool? getContactsDataAfterInit = false;

  TencentCloudChatInitDataConfig({
    this.getContactsDataAfterInit,
    this.getConversationDataAfterInit,
    this.getJoinedGroupListDataAfterInit,
  });
}
