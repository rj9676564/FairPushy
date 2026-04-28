class Routes {
  /**
   * APP-获取补丁文件
   */
  static const GET_APP_PATCH = '/app/patch'; //获取补丁文件

  /**
   * WEB-配置平台相关接口
   */
  static const LOGIN = '/web/login';
  static const REGISTER = '/web/register';
  static const GET_PROJECT = '/web/project'; //获取项目
  static const CREATE_PROJECT = '/web/createApp'; //创建项目
  static const UPDATE_PROJECT = '/web/updateApp'; //更新项目
  static const DELETE_PROJECT = '/web/deleteApp'; //删除项目
  static const PROJECT_LIST = '/web/getAppList'; //获取项目列表
  static const GET_APP_PATCH_LIST = '/web/module_patch'; //获取补丁列表
  static const CREATE_APP_PATCH = '/web/create_patch'; //创建补丁
  static const UPDATE_PATCH = '/web/update_patch'; //更新补丁
  static const DELETE_PATCH = '/web/delete_patch'; //删除补丁
  static const CHANGE_PATCH_STATUS = '/web/patch_status'; //发布、回滚、下线
  static const OPERATING_RECORD = '/web/operating_record'; //获取操作记录

  /**
   * Storage
   */
  static const UPLOAD = '/web/upload';
  static const STORAGE = '/storage/:filename';
}
