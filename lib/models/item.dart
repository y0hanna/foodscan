class Item {
  final String name;
  final double price;
  String category;
  bool isChecked;

  Item(
      {this.name, this.price, this.isChecked = false, this.category = "Keine"});

  void toggleChecked() {
    isChecked = !isChecked;
  }
}
