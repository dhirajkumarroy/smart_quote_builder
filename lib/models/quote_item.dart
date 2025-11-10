class QuoteItem {
  String name;
  int quantity;
  double rate;
  double discount;
  double tax;

  QuoteItem({
    this.name = '',
    this.quantity = 1,
    this.rate = 0.0,
    this.discount = 0.0,
    this.tax = 0.0,
  });

  double getTotal({bool taxInclusive = false}) {
    final discounted = rate - discount;
    double base = discounted * quantity;
    if (taxInclusive) {
      // Extract tax if already included
      base = base / (1 + tax / 100);
    }
    final taxed = base + (base * (tax / 100));
    return taxed;
  }
}
