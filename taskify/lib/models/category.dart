enum Category {
  work,
  personal,
  shopping,
  health,
  education,
  other,
}

extension CategoryExtension on Category {
  String get displayName {
    switch (this) {
      case Category.work:
        return 'Work';
      case Category.personal:
        return 'Personal';
      case Category.shopping:
        return 'Shopping';
      case Category.health:
        return 'Health';
      case Category.education:
        return 'Education';
      case Category.other:
        return 'Other';
    }
  }
}