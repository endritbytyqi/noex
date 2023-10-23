import 'package:noexis_task/data/models/user_model.dart';

class ResponseWrapper {
  bool isSuccess = false;
  String? error;
  UserModel? userModel;

  ResponseWrapper(this.isSuccess, this.error, this.userModel);
}
