class UserModel {

  String uuid,  fullname, raiting, city, email, lat, lng, picture, street,state, postal_code, phone_number;

  static const String TABLENAME = "users";

  UserModel({this.uuid,this.fullname, this.raiting, this.city, this.email, this.lat, this.lng, this.picture, this.street, this.state, this.postal_code, this.phone_number});



  UserModel.fromJson(Map<String, dynamic> json )
        :uuid = json['login']['uuid'],
        fullname  = json['name']['first'] + json['name']['last'],
        raiting = "4.5",
        city = json['location']['city'],
        email = json['email'],
        lat = json['location']['coordinates']['latitude'],
        lng = json['location']['coordinates']['longitude'],
        picture = json['picture']['thumbnail'],
        street = json['location']['street']["name"],
        state =  json['location']['state'],
        postal_code  = json['location']['postcode'].toString(),
        phone_number  = json['phone'];

  Map<String, dynamic> toMap() {
    return {'uuid': uuid, 'fullname': fullname, 'raiting': raiting, 'city': city , 'email': email, 'lat': lat ,'lng': lng, 'picture':picture, 'street':street, 'state':state, 'postal_code':postal_code, 'phone_number':phone_number};
  }

}