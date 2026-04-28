import 'package:fair_management_web/base/base_view_model.dart';
import 'package:fair_management_web/common/api.dart';
import 'package:fair_management_web/network/base_result.dart';
import 'package:fair_management_web/resmgr/subresmgr/bean/res_list_data.dart';

class SubResMgrViewModel extends BaseViewModel {
  SubResMgrViewModel({required Api api, required this.appId}) : super(api: api);
  final int appId;
  ResListData? resListData;
  bool isLoad = false;

  /**
   * 获取补丁列表
   */
  Future<void> getPatchList(dynamic params) async {
    resListData = await api.getPatchList(params);
    isLoad = false;
    notifyListeners();
  }

  Future<BaseResult?> updatePatch({
    required int bundleId,
    String? patchUrl,
    String? status,
    String? remark,
    String? bundleName,
    String? bundleVersion,
  }) async {
    final params = <String, dynamic>{
      'bundleId': bundleId,
      'patchUrl': patchUrl,
      'status': status,
      'remark': remark,
      'bundleName': bundleName,
      'bundleVersion': bundleVersion,
    };
    return api.updatePatch(params);
  }

  Future<BaseResult?> deletePatch(int bundleId) async {
    final result = await api.deletePatch(bundleId);
    if (result?.status == '0') {
      await getPatchList({'appId': appId.toString()});
    }
    return result;
  }

  Future<BaseResult?> changePatchStatus(int bundleId, int status) async {
    final result = await api.changePatchStatus(bundleId, status);
    if (result?.status == '0') {
      await getPatchList({'appId': appId.toString()});
    }
    return result;
  }
}
