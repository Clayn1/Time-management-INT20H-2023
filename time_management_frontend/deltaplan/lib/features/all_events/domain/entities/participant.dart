import 'package:deltaplan/features/profile/domain/entities/user.dart';

class Participant {
  int? id;
  String? status;
  User? user;
  String? issuedWhen;

  Participant({this.id, this.status, this.user, this.issuedWhen});
}
