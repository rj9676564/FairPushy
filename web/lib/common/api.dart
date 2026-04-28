import 'package:fair_management_web/appmgr/subappmgr/bean/app_list_data.dart';
import 'package:fair_management_web/network/base_result.dart';
import 'package:fair_management_web/network/fair_dio.dart';
import 'package:fair_management_web/resmgr/subresmgr/bean/res_list_data.dart';
import 'package:flutter/material.dart';
import 'package:fair_management_web/resmgr/subresmgr/bean/res_list_data.dart';

class Api {
  ///获取项目列表
  Future<AppListData?> getAppList() async {
    AppListData? appListData;
    try {
      Map<String, dynamic> params = <String, dynamic>{};
      var result =
          await FairDio.instance.post('/web/getAppList', params: params);
      var data = result?.data;
      if (data is Map<String, dynamic>) {
        appListData = AppListData.fromJson(data);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return appListData;
  }

  //获取补丁列表
  Future<ResListData?> getPatchList(dynamic params) async {
    ResListData? resListData;
    try {
      var result =
          await FairDio.instance.get('/web/module_patch', params: params);
      var data = result?.data;
      if (data is Map<String, dynamic>) {
        resListData = ResListData.fromJson(data);
      }
    } catch (e) {
      print(e.toString());
    }
    return resListData;
  }

  ///上传补丁文件
  Future<dynamic> uploadPathFile(formData) async {
    return await FairDio.instance.uploadFile(
        '/web/upload',
        data: formData,
        baseUrl: FairDio.uploadBaseUrl);
  }

  ///创建项目
  Future<BaseResult?> createApp(
      String appName, String appInfo, String appLogoUrl) async {
    Map<String, dynamic> params = <String, dynamic>{};
    params['appName'] = appName;
    params['appInfo'] = appInfo;
    params['appLogoUrl'] = appLogoUrl;
    return await FairDio.instance.post('/web/createApp', params: params);
  }

  ///更新项目
  Future<BaseResult?> updateApp(
      int appId, String appName, String appInfo, String appLogoUrl) async {
    Map<String, dynamic> params = <String, dynamic>{};
    params['appId'] = appId;
    params['appName'] = appName;
    params['appInfo'] = appInfo;
    params['appLogoUrl'] = appLogoUrl;
    return await FairDio.instance.post('/web/updateApp', params: params);
  }

  ///删除项目
  Future<BaseResult?> deleteApp(int appId) async {
    Map<String, dynamic> params = <String, dynamic>{};
    params['appId'] = appId;
    return await FairDio.instance.post('/web/deleteApp', params: params);
  }

  ///创建补丁
  Future<BaseResult?> createPatch(dynamic params) async {
    return await FairDio.instance.post('/web/create_patch', params: params);
  }

  ///更新补丁
  Future<BaseResult?> updatePatch(dynamic params) async {
    return await FairDio.instance.post('/web/update_patch', params: params);
  }

  ///删除补丁
  Future<BaseResult?> deletePatch(int bundleId) async {
    Map<String, dynamic> params = <String, dynamic>{};
    params['bundleId'] = bundleId;
    return await FairDio.instance.post('/web/delete_patch', params: params);
  }

  ///更改补丁状态 (发布/回滚/下线)
  Future<BaseResult?> changePatchStatus(int bundleId, int status) async {
    Map<String, dynamic> params = <String, dynamic>{};
    params['bundleId'] = bundleId;
    params['status'] = status;
    return await FairDio.instance.post('/web/patch_status', params: params);
  }
}
