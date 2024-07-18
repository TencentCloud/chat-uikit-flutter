This document describe how to implement sticker module in Tencent Cloud Chat Flutter UIKIt.

Two types of stickers, are available in Message widget, shows in the following list:
<table>
<tr>
<td rowspan="1" colSpan="1" >Sticker Type</td>

<td rowspan="1" colSpan="1" >MessageType</td>

<td rowspan="1" colSpan="1" >Integrate within Text</td>

<td rowspan="1" colSpan="1" >Sending Scheme</td>

<td rowspan="1" colSpan="1" >Rending Scheme</td>

<td rowspan="1" colSpan="1" >Usage</td>

<td rowspan="1" colSpan="1" >Default</td>
</tr>

<tr>
<td rowspan="1" colSpan="1" ><br>Small image</td>

<td rowspan="1" colSpan="1" >Text Message</td>

<td rowspan="1" colSpan="1" >Yes</td>

<td rowspan="1" colSpan="1" >Image name</td>

<td rowspan="1" colSpan="1" >The image is automatically matched against the local image assets by name.</td>

<td rowspan="1" colSpan="1" >**Enabled as default**<br>, with one set of default packages, while adding new packages and cutmization are also support.</td>

<td rowspan="1" colSpan="1" >One set of default packages are provided, shown as the screenshots below.</td>
</tr>

<tr>
<td rowspan="1" colSpan="1" ><br>Large image</td>

<td rowspan="1" colSpan="1" >Sticker Message</td>

<td rowspan="1" colSpan="1" >No</td>

<td rowspan="1" colSpan="1" >`baseURL` plus the image file name, which form the path of the emoji image asset</td>

<td rowspan="1" colSpan="1" ><br>The asset resources are parsed based on the path.</td>

<td rowspan="1" colSpan="1" >Images are stored as assets, and are defined in `List`</td>

<td rowspan="1" colSpan="1" >-</td>
</tr>
</table>

<table>
<tr>
<td rowspan="1" colSpan="1" >**Name**</td>

<td rowspan="1" colSpan="1" >Small Image<br>(Designed by us)</td>

<td rowspan="1" colSpan="1" >Tencent Large Image</td>
</tr>

<tr>
<td rowspan="1" colSpan="1" >**Type**</td>

<td rowspan="1" colSpan="1" >Small image</td>

<td rowspan="1" colSpan="1" >Large image</td>
</tr>

<tr>
<td rowspan="1" colSpan="1" >**Description**</td>

<td rowspan="1" colSpan="1" >**Enabled as default**<br>located at first</td>

<td rowspan="1" colSpan="1" >Not provided as default, this packages comes from customize configuration from our [Sample App](https://github.com/TencentCloud/chat-demo-flutter/tree/v2).</td>
</tr>

<tr>
<td rowspan="1" colSpan="1" >**Screenshots**</td>

<td rowspan="1" colSpan="1" ><br>![Figure 1](https://write-document-release-1258344699.cos.ap-guangzhou.tencentcos.cn/100027812451/646d5566416511ee96d3525400088f3a.jpeg?q-sign-algorithm=sha1&q-ak=AKIDDyjFF7XSAPg-9EuuDQjd98ooKKuMmA3EvRFxYQeTrw9bvAWv7hs8_p4JY6MYzko8&q-sign-time=1720058468;1720062068&q-key-time=1720058468;1720062068&q-header-list=&q-url-param-list=&q-signature=d694c6ad9f2b7d6be9849feed928c1302ac70420&x-cos-security-token=2CQZ8Wyt2sAPlDL881QtazkWlMGHbMya69e9fab506fe877484e34413e82b316fzAM0VnqTA4p7IAWgMij-NXbpZO-MHwkERVE8YhxCLJOo9cwuMDsnxYDDLeyev7LUC7pkMhGbqwNzgcv69McrtWjRDf_tuJCtB7nK7mrA_350NQagwGFKQudbAeoZCwu-Db5OQAW4tZirniI2XrhgNvtMhE7iifopoWAg-6FoTCMcjAWWEPeezi9kvijPj8aW1ui8ijay6CHV8MwuO21xiIokPUB544YKZ8skeYBzr2x2AIeHBm87p923cn29MYZwjzDTsQDKNxp5CWEZqa04wZtC_4WawwFtCPuOPQUzndzUlxP5HOhOEjT8TeQ6cNoxqZI7EOlkx4iTjONe2vNTlf16WcYp9h5PoGcJ_mCiYoyDlN7zSFjMfR068lM0vk83)<br>Figure 1</td>

<td rowspan="1" colSpan="1" ><br>![Figure 2](https://write-document-release-1258344699.cos.ap-guangzhou.tencentcos.cn/100027812451/64a6dd21416511eeb231525400c56988.jpeg?q-sign-algorithm=sha1&q-ak=AKID0IwK4_iqzadEdfWcqgfS0J49C3dbdTCAKNVp1uN-Lz-e9N2_w3Mt2vEKisOANOGe&q-sign-time=1720058468;1720062068&q-key-time=1720058468;1720062068&q-header-list=&q-url-param-list=&q-signature=53b3ea0ab2ccf99be9c6ba784f9f133d3364dce3&x-cos-security-token=2CQZ8Wyt2sAPlDL881QtazkWlMGHbMya8e15ef34d5387e3b2ec1db1b9c64871czAM0VnqTA4p7IAWgMij-NXbpZO-MHwkERVE8YhxCLJOo9cwuMDsnxYDDLeyev7LUC7pkMhGbqwNzgcv69McrtWjRDf_tuJCtB7nK7mrA_350NQagwGFKQudbAeoZCwu-Db5OQAW4tZirniI2XrhgNvtMhE7iifopoWAg-6FoTCMcjAWWEPeezi9kvijPj8aWjYcBvsQ95ZqBfCVdEt3r4CUi8NlzgHQLKiERa0THchBNWOxNoln5BYqHklodLM0btW9JUINiQzPiRzSM8vf-jPJy5V_17DWTwtx6m8UfIpejugftb9lSqwC6VdxARPuNfTGiuz14sCm4oOGVWwKkc0ZtfnkVyEiWh55H3MNZw0gw4cho7mD8fk_rA2ECp3uJ)<br>Figure 2</td>
</tr>
</table>


## Usage

First, install the [tencent_cloud_chat_sticker](https://pub.dev/packages/tencent_cloud_chat_sticker) plugin:
``` bash
flutter pub add tencent_cloud_chat_sticker
```

To enable the plugin, add the following code to the `plugins `list in `initUIKit`:
``` java
TencentCloudChatPluginItem(
  name: "sticker",
  initData: TencentCloudChatStickerInitData(
    userID: TencentCloudChatLoginData.userID,
  ).toJson(),
  pluginInstance: TencentCloudChatStickerPlugin(
    context: context,
  ),
)
```

In the `TencentCloudChatStickerInitData` object, you can select which default sticker sets to enable and add additional sticker sets to suit your needs.



