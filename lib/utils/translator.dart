Map<String, String> dictionary = {
// expenses
  "SALE": "Savdo",
  "INCOME": "Kirim",
  "TOTAL": "Umumiy",
  "OUTGOING": "Chiqim",
  "CONSUMPTION": "Xarajat",
// transfer status
  "RETURN": "Qaytarish(Vazvrat)",
  "COMPLETED": "Tugallangan",
  "CANCELED": "Bekor qilingan",
  "IN_PROGRESS": "Jarayonda",
  "PENDING": "Kutilmoqda",
// roles
  "STOREKEEPER": "Skladchi",
  "ADMIN": "Admin",
  "MANAGER": "Menejer",
  "CASHIER": "Kassir",
  "USER": "Foydalanuvchi",
  "DIRECTOR": "Direktor",
  "MODERATOR": "Moderator",
  "SUPERVISOR": "Supervisor",
  "ANALYST": "Analitik",
  "FINANCE": "Moliya",
  "FINANCE_SUPERVISOR": "Moliya supervisor",
  "ANALYST_SUPERVISOR": "Analitik supervisor",
  "RETAIL": "Donalik",
  "WHOLESALE": "Ulgurji ( Optom )",
  "DISCOUNT": "Chegirma",
  "COST": "Oprexod",
  "PIECE": "Dona",
  "METRE": "Metr",
  "KG": "Kg",
  "LITRE": "Litr",
  "ALL": "Umumiy",
  "CARD": "Karta",
  "CASH": "Naqd",
  "TRANSFER": "O'tkazma",
  "POS_TRANSFER": "Kassadan Pul o'tkazma",
  "SPRING": "Bahor",
  "SUMMER": "Yoz",
  "AUTUMN": "Kuz",
  "WINTER": "Qish",
  "REGIONAL": "Regional",
  "FACTORY": "Fabrika",
  "FOREIGN": "Xorijiy",
  "KIT": "Set uchun",
// finance out
  "PAY_TO_SUPPLIER": "Taminotchiga to'lov",
  "PAY_TO_OTHER_ORG": "Boshqa organizatsiya to'lov",
  "ISSUANCE_TO_ANOTHER_CASH": "Boshqa kassaga chiqarish",
  "ISSUANCE_TO_COUNTERPARTY": "Kontragentga zaym berish",
  "OTHER_EXPENSE": "Boshqa xarajat",
  "PAY_SALARY_DISTRIBUTOR": "Distributorga maosh chiqarish",
  "PAY_SALARY_EMPLOYEE": "Hodimga maosh chiqarish",
  "PAY_TO_BANK": "Bankga chiqim",
  "PAY_TO_BANK_COLLECTION": "Bank inkassatsiya chqim",
  "PAY_TO_DEBTS_AND_CREDITS": "Qarz va kreditlarga chiqim",
  "PAY_GIVE_DEBT_TO_EMPLOYEE": "Hodimga qarz berish",

// finance in
  "PAY_FROM_CLIENT": "Mijozdan kirim",
  "PAY_FROM_OTHER_ORG": "Boshqa organizatsiyadan kirim",
  "PAY_FROM_OTHER_CASH": "Boshqa kassadan kirim",
  "PAY_FROM_BANK": "Bankdan kirim",
  "PAY_FROM_CREDIT": "Kreditdan kirim",
  "PAY_FROM_COUNTERPARTY": "Kontragentdan kirim",
  "PAY_FROM_EMPLOYEE": "Hodimdan kirim",
  "PAY_OTHER": "Boshqa kirimlar",
  "RETURN_FROM_SUPPLIER": "Taminotchiga qaytarish",
  "RETURN_FROM_ACCOUNTABLE": "Ma'sul dan qaytarish",
// regions
  "COUNTRY": "Mamlakat",
  "STATE": "Shtat",
  "REGION": "Viloyat",
  "CITY": "Shahar",
  "DISTRICT": "Tuman",
  "TOWN": "Shaharcha",
// shop type
  "WAREHOUSE_ADMINISTRATION": "Sklad boshqaruv",
  "MIXED": "Aralash",
  "WAREHOUSE": "Sklad",
  "WAREHOUSE_SHOP": "Sklad do'koni",
// pos type
  "SHOP": "Do'kon",
  "SHOP_MAIN": "Asosiy do'kon",
  "MAIN": "Asosiy",
  // PRINTER
  'BARCODE': 'Shtrixkod',
  'PRICE': 'Narx',
  'PRICELABEL': 'Narx etiketi',
  // Trade status
  'SUCCESS': "Tugallangan",
  'DELETED': 'O\'chirilgan',
  'RETURNED': 'Qaytarilgan',
};

String translate(String key) {
  return dictionary[key] ?? key;
}

String unTranslate(String value) {
  return dictionary.keys.firstWhere((key) => dictionary[key] == value, orElse: () => value);
}
