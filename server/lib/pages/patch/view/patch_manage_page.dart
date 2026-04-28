import 'package:HotUpdateService/pages/patch/data/data_dao/patch_model_dao.dart';
import 'package:HotUpdateService/pages/patch/data/data_model/patch_model.dart';
import 'package:HotUpdateService/server/fair_server_response.dart';
import 'package:HotUpdateService/server/fair_server_widget.dart';
import 'package:simple_mysql_orm/simple_mysql_orm.dart';

class UpdatePatchPage extends AuthenticatedFairServiceWidget {
  @override
  Future<ResponseBaseModel> service(Map? request_params) async {
    final bundleId = request_params?["bundleId"];
    if (bundleId == null) {
      return ParamsError(msg: "bundleId is required");
    }

    try {
      await withTransaction<void>(() async {
        final dao = PatchDao();
        final patch = await dao.getPatchByBundleId(int.parse(bundleId.toString()));
        if (patch == null) {
          throw Exception("Patch not found");
        }

        if (request_params?["patchUrl"] != null) patch.patch_url = request_params!["patchUrl"];
        if (request_params?["status"] != null) patch.status = request_params!["status"].toString();
        if (request_params?["remark"] != null) patch.remark = request_params!["remark"];
        if (request_params?["bundleName"] != null) patch.bundleName = request_params!["bundleName"];
        if (request_params?["bundleVersion"] != null) patch.bundleVersion = request_params!["bundleVersion"];
        
        patch.update_time = DateTime.now().toString();
        await dao.updateByPatch(patch);
      });
      return ResponseSuccess(data: {"desc": "Patch updated successfully"});
    } catch (e) {
      return ResponseError(msg: e.toString());
    }
  }
}

class ChangePatchStatusPage extends AuthenticatedFairServiceWidget {
  @override
  Future<ResponseBaseModel> service(Map? request_params) async {
    final bundleId = request_params?["bundleId"];
    final status = request_params?["status"]; // 1: published, 2: rollback, 3: offline

    if (bundleId == null || status == null) {
      return ParamsError(msg: "bundleId and status are required");
    }

    try {
      await withTransaction<void>(() async {
        final dao = PatchDao();
        final patch = await dao.getPatchByBundleId(int.parse(bundleId.toString()));
        if (patch == null) {
          throw Exception("Patch not found");
        }

        patch.status = status.toString();
        patch.update_time = DateTime.now().toString();
        await dao.updateByPatch(patch);
      });
      return ResponseSuccess(data: {"desc": "Status updated successfully"});
    } catch (e) {
      return ResponseError(msg: e.toString());
    }
  }
}

class DeletePatchPage extends AuthenticatedFairServiceWidget {
  @override
  Future<ResponseBaseModel> service(Map? request_params) async {
    final bundleId = request_params?["bundleId"];
    if (bundleId == null) {
      return ParamsError(msg: "bundleId is required");
    }

    try {
      await withTransaction<void>(() async {
        final dao = PatchDao();
        final sql = 'delete from patch_info where bundle_id = ?';
        await dao.db.query(sql, [bundleId]);
      });
      return ResponseSuccess(data: {"desc": "Patch deleted successfully"});
    } catch (e) {
      return ResponseError(msg: e.toString());
    }
  }
}
