enum PostgresErrorType {
  insufficientPrivilege,
  unknown;

  PostgresErrorType fromCode(int code) {
    switch (code) {
      case 42501:
        return PostgresErrorType.insufficientPrivilege;
      default:
        return PostgresErrorType.unknown;
    }
  }
}
