enum UploadTypes {
  SESSIONS,
  CATEGORIES,
  PRODUCTS,
  CUSTOMERS,
  TRADES,
  REGIONS,
}

enum DownloadTypes { REGION, EMPLOYEE, CATEGORY, PRODUCT, SUPPLIER, PRICE, CUSTOMER, BARCODE, SHOP, INCOME }

class DownloadProgress {
  int total;
  int current;
  String status;
  bool isFinished;
  bool isActivate;

  DownloadProgress({
    required this.total,
    required this.current,
    required this.status,
    required this.isFinished,
    required this.isActivate,
  });
}

class DownloadProgressWrapper {
  DownloadProgress? downloadProgressList =
      DownloadProgress(total: 0, current: 0, status: '', isFinished: false, isActivate: false);
  DownloadTypes name;

  DownloadProgressWrapper({required this.name, this.downloadProgressList});
}
