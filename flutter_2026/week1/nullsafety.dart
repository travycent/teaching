// Run me with:  dart run nullsafety.dart

// A function that might return null (e.g. a user who hasn't set a nickname)
String? findNickname(String name) {
  if (name == 'Alice') return 'Al';
  return null;
}

void nullsafety() {
  String? nickname = findNickname('Bob'); // the ? means "this can be null"
  // String nickname2 = null; // ERROR: non-nullable types can't be null

  // Safe access
  print(nickname?.length); // ?. means "only call this if not null" -> prints null

  // Give a fallback if null
  String displayName = nickname ?? 'Anonymous'; // ?? means "use this if left side is null"
  print(displayName); // Anonymous

  nickname = findNickname('Alice');

  // Check for null first, and inside the if Dart knows nickname is a String,
  // so we can use .length directly (this is called "type promotion")
  if (nickname != null) {
    print(nickname.length); // 2
  }

  //ANSWER5
  //It printed null because findNickname only knows the name 'Alice'.
  //for any other name it returns null, meaning "no nickname found ". 
  //dart's nullsafety allows this because the return type is String?, where the ? means the value can be null. 
  print(findNickname('Shau_faizah_faith'));
}

void main() {
  nullsafety();
}
