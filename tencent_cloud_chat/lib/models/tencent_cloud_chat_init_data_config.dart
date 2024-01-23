class TencentCloudChatInitDataConfig {
  bool? getConversationDataAfterInit = false;
  bool? getJoinedGroupListDataAfterInit = false;
  bool? getContactsDataAfterInit = false;

  TencentCloudChatInitDataConfig({
    this.getContactsDataAfterInit,
    this.getConversationDataAfterInit,
    this.getJoinedGroupListDataAfterInit,
  });
}
