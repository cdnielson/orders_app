library orders;


class Order {
  final String order_idx;
  final String order_name;
  final String rep;

  Order(String this.order_idx, String this.order_name, String this.rep);

  Order.fromMap(Map<String, Object> map) : this(map["order_idx"], map["order_name"], map["rep"]);

}
