import bundleManager from '@ohos.bundle.bundleManager';
import abilityAccessCtrl, { Permissions } from '@ohos.abilityAccessCtrl';

export async function checkAccessToken(permission: Permissions): Promise<boolean> {
  let atManager = abilityAccessCtrl.createAtManager();
  let grantStatus: abilityAccessCtrl.GrantStatus;

  // 获取应用程序的accessTokenID
  let tokenId: number;
  try {
    let bundleInfo: bundleManager.BundleInfo = await bundleManager.getBundleInfoForSelf(bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_APPLICATION);
    let appInfo: bundleManager.ApplicationInfo = bundleInfo.appInfo;
    tokenId = appInfo.accessTokenId;
  } catch (err) {
    console.error(`getBundleInfoForSelf failed, code is ${err.code}, message is ${err.message}`);
  }

  // 校验应用是否被授予权限
  try {
    grantStatus = await atManager.checkAccessToken(tokenId, permission);
  } catch (err) {
    console.error(`checkAccessToken failed, code is ${err.code}, message is ${err.message}`);
  }
  console.log('grantStatus:' + grantStatus.toString())
  return grantStatus === abilityAccessCtrl.GrantStatus.PERMISSION_GRANTED
}
