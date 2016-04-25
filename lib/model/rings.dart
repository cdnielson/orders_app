library rings;




class Ring {
  final String sku;
  final String finish;
  final int price;
  final String image;

  Ring(String this.sku, String this.finish, int this.price, String this.image);

  Ring.fromMap(Map<String, Object> map) : this(map["sku"], map["finish"], map["price"], map["image"]);

}
