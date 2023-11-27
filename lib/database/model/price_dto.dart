class PriceDTO {
  double? wholesalePrice;
  double? retailPrice;
  double? discountPrice;
  bool? isSynced;
  DateTime? syncedAt;
  DateTime? createdAt;
  DateTime? updatedAt;

  PriceDTO({
    this.wholesalePrice,
    this.retailPrice,
    this.discountPrice,
    this.isSynced,
    this.syncedAt,
    this.createdAt,
    this.updatedAt,
  });
}
