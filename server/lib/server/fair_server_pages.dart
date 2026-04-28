import 'package:HotUpdateService/server/src/get_server.dart';
import 'package:HotUpdateService/server/fair_server_routes.dart';
import 'package:HotUpdateService/pages/project/view/project_create_page.dart';
import 'package:HotUpdateService/pages/project/view/project_list_page.dart';
import 'package:HotUpdateService/pages/project/view/project_query_page.dart';
import 'package:HotUpdateService/pages/project/view/project_manage_page.dart';
import 'package:HotUpdateService/pages/patch/view/patch_create_page.dart';
import 'package:HotUpdateService/pages/patch/view/patch_list_query_page.dart';
import 'package:HotUpdateService/pages/patch/view/patch_query_page.dart';
import 'package:HotUpdateService/pages/patch/view/patch_manage_page.dart';
import 'package:HotUpdateService/pages/record/view/record_query_page.dart';
import 'package:HotUpdateService/pages/user/view/login_page.dart';
import 'package:HotUpdateService/pages/storage/view/upload_page.dart';
import 'package:HotUpdateService/pages/storage/view/storage_serve_page.dart';

/*
* 接口路由配置，Server端提供的所有接口需在routes中配置相关参数
* GetPage中主要参数：
*   name：请求的url名字
*   page：Widget页面主要是当前接口的实现逻辑
*   method：请求方式
*   needAuth：是否需要登录鉴权 true：鉴权：   false：不做鉴权
*
* Created by Wang Meng on 2022/5/11.
* Copyright © 2022 58. All rights reserved.
*
* */
mixin AppPages {
  static final routes = [
    // Auth
    GetPage(
      name: Routes.LOGIN,
      page: () => LoginPage(),
      method: Method.post,
    ),
    GetPage(
      name: Routes.REGISTER,
      page: () => RegisterPage(),
      method: Method.post,
    ),

    // App (Client)
    GetPage(
      name: Routes.GET_APP_PATCH, //获取补丁文件
      page: () => GetPatchPage(),
      method: Method.get,
    ),

    // Web (Admin)
    GetPage(
      name: Routes.GET_PROJECT, //获取项目详情
      page: () => GetProjectPage(),
      method: Method.post,
    ),
    GetPage(
      name: Routes.CREATE_PROJECT, //创建项目
      page: () => CreateProjectPage(),
      method: Method.post,
    ),
    GetPage(
      name: Routes.UPDATE_PROJECT,
      page: () => UpdateProjectPage(),
      method: Method.post,
    ),
    GetPage(
      name: Routes.DELETE_PROJECT,
      page: () => DeleteProjectPage(),
      method: Method.post,
    ),
    GetPage(
      name: Routes.PROJECT_LIST, //获取项目列表
      page: () => ProjectListPage(),
      method: Method.post,
    ),
    GetPage(
      name: Routes.GET_APP_PATCH_LIST, //获取补丁列表
      page: () => GetPatchListPage(),
      method: Method.get,
    ),
    GetPage(
      name: Routes.CREATE_APP_PATCH, //创建补丁
      page: () => CreatePatchPage(),
      method: Method.post,
    ),
    GetPage(
      name: Routes.UPDATE_PATCH,
      page: () => UpdatePatchPage(),
      method: Method.post,
    ),
    GetPage(
      name: Routes.DELETE_PATCH,
      page: () => DeletePatchPage(),
      method: Method.post,
    ),
    GetPage(
      name: Routes.CHANGE_PATCH_STATUS,
      page: () => ChangePatchStatusPage(),
      method: Method.post,
    ),
    GetPage(
      name: Routes.OPERATING_RECORD, //获取操作记录
      page: () => GetRecordPage(),
      method: Method.post,
    ),

    // Storage
    GetPage(
      name: Routes.UPLOAD,
      page: () => UploadPage(),
      method: Method.post,
    ),
    GetPage(
      name: Routes.STORAGE,
      page: () => StorageServePage(),
      method: Method.get,
    ),
  ];
}
