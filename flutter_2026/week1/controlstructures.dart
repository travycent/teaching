void main() {
  int score = 75;

  if (score >= 90) {
    print('A');
  } else if (score >= 70) {
    print('B');
  } else {
    print('C');
  }

  for (int i = 0; i < 3; i++) {
    print('Count: $i');
  }

  int n = 3;
  while (n > 0) {
    print(n);
    n--;
  }
}