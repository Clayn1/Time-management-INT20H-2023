class Invite {
  int? invitationId;
  String? status;
  String? email;
  int? eventId;
  String? eventName;
  String? category;
  String? dateStart;
  String? dateEnd;

  Invite(
      {this.invitationId,
      this.status,
      this.email,
      this.eventId,
      this.eventName,
      this.category,
      this.dateStart,
      this.dateEnd});
}
