void nullsafety() {
  String? nickname; // the ? means "this can be null"
  // String nickname2 = null; // ERROR: non-nullable types can't be null

  nickname = 'Al';

  // Safe access
  print(nickname?.length); // ?. means "only call this if not null"

  // Give a fallback if null
  String displayName = nickname ?? 'Anonymous'; // ?? means "use this if left side is null"
  print(displayName);
}