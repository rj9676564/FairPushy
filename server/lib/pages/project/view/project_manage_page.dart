import 'package:HotUpdateService/pages/project/data/data_dao/project_model_dao.dart';
import 'package:HotUpdateService/pages/project/data/data_model/project_model.dart';
import 'package:HotUpdateService/server/fair_server_response.dart';
import 'package:HotUpdateService/server/fair_server_widget.dart';
import 'package:simple_mysql_orm/simple_mysql_orm.dart';

class UpdateProjectPage extends AuthenticatedFairServiceWidget {
  @override
  Future<ResponseBaseModel> service(Map? request_params) async {
    final appId = request_params?["appId"];
    final appName = request_params?["appName"];
    final appInfo = request_params?["appInfo"];
    final appLogoUrl = request_params?["appLogoUrl"];

    if (appId == null) {
      return ParamsError(msg: "appId is required");
    }

    try {
      await withTransaction<void>(() async {
        final dao = ProjectDao();
        final project = await dao.getProjectByAppId(int.parse(appId.toString()));
        if (project == null) {
          throw Exception("Project not found");
        }

        if (appName != null) project.app_name = appName;
        if (appInfo != null) project.app_description = appInfo;
        if (appLogoUrl != null) project.app_pic_url = appLogoUrl;
        project.update_time = DateTime.now();

        await dao.updateByProject(project);
      });
      return ResponseSuccess(data: {"desc": "Project updated successfully"});
    } catch (e) {
      return ResponseError(msg: e.toString());
    }
  }
}

class DeleteProjectPage extends AuthenticatedFairServiceWidget {
  @override
  Future<ResponseBaseModel> service(Map? request_params) async {
    final appId = request_params?["appId"];
    if (appId == null) {
      return ParamsError(msg: "appId is required");
    }

    try {
      await withTransaction<void>(() async {
        final dao = ProjectDao();
        final sql = 'delete from app_info where app_id = ?';
        await dao.db.query(sql, [appId]);
      });
      return ResponseSuccess(data: {"desc": "Project deleted successfully"});
    } catch (e) {
      return ResponseError(msg: e.toString());
    }
  }
}
