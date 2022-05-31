class TextUtil {
  String getFormattedAmount(double amount) {
    if (amount == 0) {
      return amount.toString();
    }
    return '${amount >= 0 ? '+' : '-'} ${amount.abs()}';
  }
}
