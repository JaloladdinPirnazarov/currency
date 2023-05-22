class CurrencyModel {
  String title = "";
  String code = "";
  String cb_price = "";
  String date = "";

  CurrencyModel(this.title, this.code, this.cb_price, this.date, );

  factory CurrencyModel.fromJson(Map<String, dynamic> json) {
    String title = json["title"] ?? "No data";
    String code = json["code"] ?? "No data";
    String cb_price = json["cb_price"] ?? "No data";
    String date = json["date"] ?? "No data";

    return CurrencyModel(
        title, code, cb_price, date);
  }
}
