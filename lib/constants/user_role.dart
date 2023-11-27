enum UserRole {
  SUPER_ADMIN,
  USER,
  ADMIN,
  SUPERVISOR,
  STOREKEEPER,
  CASHIER,
  MODERATOR,
  DIRECTOR,
  MANAGER,
  FINANCE,
  FINANCE_SUPERVISOR,
  ANALYST,
  ANALYST_SUPERVISOR;

  static UserRole fromString(String value) {
    switch (value) {
      case "SUPER_ADMIN":
        return UserRole.SUPER_ADMIN;
      case "USER":
        return UserRole.USER;
      case "ADMIN":
        return UserRole.ADMIN;
      case "SUPERVISOR":
        return UserRole.SUPERVISOR;
      case "STOREKEEPER":
        return UserRole.STOREKEEPER;
      case "CASHIER":
        return UserRole.CASHIER;
      case "MODERATOR":
        return UserRole.MODERATOR;
      case "DIRECTOR":
        return UserRole.DIRECTOR;
      case "MANAGER":
        return UserRole.MANAGER;
      case "FINANCE":
        return UserRole.FINANCE;
      case "ANALYST":
        return UserRole.ANALYST;
      case "FINANCE_SUPERVISOR":
        return UserRole.FINANCE_SUPERVISOR;
      case "ANALYST_SUPERVISOR":
        return UserRole.ANALYST_SUPERVISOR;
      default:
        return UserRole.USER;
    }
  }
}
