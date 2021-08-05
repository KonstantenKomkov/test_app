import 'package:shared_preferences/shared_preferences.dart';


class Company {
  String name = "";
  String catchPhrase = "";
  String bs = "";

  Company(this.name, this.catchPhrase, this.bs);

  Company.fromJson(Map<String, dynamic> json) {
    Company(
      name = json["name"] as String,
      catchPhrase = json["catchPhrase"] as String,
      bs = json["bs"] as String,
    );
  }
}

class Geo {
  double latitude = 0;
  double longitude = 0;

  Geo(this.latitude, this.longitude);

  Geo.fromJson(Map<String, dynamic> json) {
    Geo(latitude = double.parse(json["lat"]),
        longitude = double.parse(json["lng"]));
  }
}

class Address {
  String street = "";
  String suite = "";
  String city = "";
  String zipcode = "";
  Geo geo = Geo(0, 0);

  Address(this.street, this.suite, this.city, this.zipcode, this.geo);

  Address.fromJson(Map<String, dynamic> json) {
    Address(
        street = json["street"] as String,
        suite = json["suite"] as String,
        city = json["city"] as String,
        zipcode = json["zipcode"] as String,
        geo = Geo.fromJson(json["geo"]));
  }
}

class User {
  String name = "";
  String userName = "";
  String email = "";
  String phone = "";
  String website = "";
  Company company = Company("", "", "");
  Address address = Address("", "", "", "", Geo(0, 0));

  User(this.name, this.userName, this.email, this.phone, this.website,
      this.company, this.address);

  User.fromJson(Map<String, dynamic> json) {
    User(
        name = json["name"] as String,
        userName = json["username"] as String,
        email = json["email"] as String,
        phone = json["phone"] as String,
        website = json["website"] as String,
        company = Company.fromJson(json["company"]),
        address = Address.fromJson(json["address"]));
  }
}

class SharedPrefs {
  late SharedPreferences _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

}
