class UserInfo {
  String? id;
  String? email;
  String? photoUrl;
  String? role;
  String? roleInTeam;
  String? stripeCustomerId;
  String? xStripeCustomerId;
  bool? emailVerified;
  String? phoneNumber;
  bool? phoneVerified;
  String? firstName;
  String? lastName;

  UserInfo(
      {this.id,
        this.email,
        this.photoUrl,
        this.role,
        this.roleInTeam,
        this.stripeCustomerId,
        this.xStripeCustomerId,
        this.emailVerified,
        this.phoneNumber,
        this.phoneVerified,
        this.firstName,
        this.lastName});

  UserInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    email = json['email'];
    photoUrl = json['photo_url'];
    role = json['role'];
    roleInTeam = json['role_in_team'];
    stripeCustomerId = json['stripe_customer_id'];
    xStripeCustomerId = json['x_stripe_customer_id'];
    emailVerified = json['email_verified'];
    phoneNumber = json['phone_number'];
    phoneVerified = json['phone_verified'];
    firstName = json['firstName'];
    lastName = json['lastName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['email'] = this.email;
    data['photo_url'] = this.photoUrl;
    data['role'] = this.role;
    data['role_in_team'] = this.roleInTeam;
    data['stripe_customer_id'] = this.stripeCustomerId;
    data['x_stripe_customer_id'] = this.xStripeCustomerId;
    data['email_verified'] = this.emailVerified;
    data['phone_number'] = this.phoneNumber;
    data['phone_verified'] = this.phoneVerified;
    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    return data;
  }
}