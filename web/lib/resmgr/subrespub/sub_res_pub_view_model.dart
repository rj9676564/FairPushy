import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:fair_management_web/base/base_view_model.dart';
import 'package:fair_management_web/common/api.dart';
import 'package:fair_management_web/resmgr/res_mgr_view_model.dart';
import 'package:file_picker/file_picker.dart';

import '../../appmgr/subappmgr/bean/app_list_data.dart';
import '../../network/base_result.dart';

class SubResPubViewModel extends BaseViewModel {
  SubResPubViewModel(
      {required Api api, required this.appId})
      : super(api: api);
  final int appId;
  var uploadFileTip = '请选择补丁文件';
  var patchFileUrl;
  AppListData? appListData;
  var appSelectTip = '请选择项目';

  Future<void> getAppList() async {
    appListData = await api.getAppList();
    notifyListeners();
  }

  void uploadPatchFile(String fileName, fileBytes) async {
    FormData formData = FormData.fromMap({
      "file": MultipartFile.fromBytes(fileBytes, filename: fileName),
    });
    Response? result = await api.uploadPathFile(formData);
    if (result != null && result.statusCode == 200) {
      final responseData = result.data;
      final map =
          responseData is String ? json.decode(responseData) : responseData;
      if (map['code'] == 0) {
        patchFileUrl = map['data']['url'];
        uploadFileTip = '上传成功: $fileName';
      } else {
        uploadFileTip = '上传失败: ${map['msg']}';
      }
    } else {
      uploadFileTip = '文件上传失败';
    }
    notifyListeners();
  }

  void showFile(String bundleName, String bundleVersion, [void Function(void Function())? setState]) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      Uint8List fileBytes = result.files.first.bytes!;
      String fileName = result.files.first.name;
      uploadFileTip = '正在上传: $fileName';
      notifyListeners();
      if (setState != null) setState(() {});

      uploadPatchFile(fileName, fileBytes);
    }
  }

  void clearData(){
    uploadFileTip = '请选择补丁文件';
    patchFileUrl = '';
  }

  void setAppSelectTip(String value) {
    appSelectTip = value;
    notifyListeners();
  }

  Future<BaseResult?> createPatch(
    String bundleVersion,
    String appIdentify,
    String patchRemark,
    String moduleName,
    String patchUrl,
  ) async {
    var params = {
      'patchUrl': patchUrl.isNotEmpty ? patchUrl : patchFileUrl,
      'status': 0, // Default to draft
      'remark': patchRemark,
      'bundleName': moduleName,
      'appId': appIdentify,
      'bundleVersion': bundleVersion,
    };
    return api.createPatch(params);
  }

  /**
   * 修改补丁本地上传
   */
  Future<BaseResult?> updatePatch(
      String bundleId,
      String moduleName,
      String bundleVersion,
      String patchUrl,
      String patchRemark) async {
    var params = {
      'bundleId': bundleId,
      'bundleName': moduleName,
      'bundleVersion': bundleVersion,
      'patchUrl': patchFileUrl.toString().isNotEmpty ? patchFileUrl : patchUrl,
      'remark': patchRemark,
    };
    return api.updatePatch(params);
  }
}
