import 'package:fair_management_web/appmgr/subappmgr/bean/app_list_data.dart';
import 'package:fair_management_web/base/base_view_model.dart';
import 'package:fair_management_web/common/api.dart';

class SubAppMgrViewModel extends BaseViewModel {
  SubAppMgrViewModel({required Api api}) : super(api: api);

  AppListData? appListData;

  bool isLoad = false;

  Future<void> getAppList() async {
    appListData = await api.getAppList();
    isLoad = false;
    notifyListeners();
  }

  Future<bool> updateApp(int appId, String name, String info, String logo) async {
    final result = await api.updateApp(appId, name, info, logo);
    if (result?.status == '0') {
      await getAppList();
      return true;
    }
    return false;
  }

  Future<bool> deleteApp(int appId) async {
    final result = await api.deleteApp(appId);
    if (result?.status == '0') {
      await getAppList();
      return true;
    }
    return false;
  }
}
