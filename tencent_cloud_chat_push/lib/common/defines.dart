// Define the TencentCloudChatPushBrandID enumeration.
// ignore_for_file: constant_identifier_names

enum TencentCloudChatPushBrandID {
  XiaoMi,
  HuaWei,
  FCM,
  Meizu,
  Oppo,
  Vivo,
  Honor,
}

// Convert the TencentCloudChatPushBrandID enumeration to its corresponding integer value.
int brandIdToInt(TencentCloudChatPushBrandID brandId) {
  switch (brandId) {
    case TencentCloudChatPushBrandID.XiaoMi:
      return 2000;
    case TencentCloudChatPushBrandID.HuaWei:
      return 2001;
    case TencentCloudChatPushBrandID.FCM:
      return 2002;
    case TencentCloudChatPushBrandID.Meizu:
      return 2003;
    case TencentCloudChatPushBrandID.Oppo:
      return 2004;
    case TencentCloudChatPushBrandID.Vivo:
      return 2005;
    case TencentCloudChatPushBrandID.Honor:
      return 2006;
  }
}

// Convert the integer value to its corresponding TencentCloudChatPushBrandID enumeration.
TencentCloudChatPushBrandID intToBrandId(int brandIdInt) {
  switch (brandIdInt) {
    case 2000:
      return TencentCloudChatPushBrandID.XiaoMi;
    case 2001:
      return TencentCloudChatPushBrandID.HuaWei;
    case 2002:
      return TencentCloudChatPushBrandID.FCM;
    case 2003:
      return TencentCloudChatPushBrandID.Meizu;
    case 2004:
      return TencentCloudChatPushBrandID.Oppo;
    case 2005:
      return TencentCloudChatPushBrandID.Vivo;
    case 2006:
      return TencentCloudChatPushBrandID.Honor;
    default:
      throw Exception('Invalid brandIdInt: $brandIdInt');
  }
}
