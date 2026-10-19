// Run me with:  dart run controlstructures.dart

void main() {
  int score = 75;

//ANSWER 2
//score =95: we predicted A. it printed A,because 95 >=90 is true.
//score =40: we predicted C. it printed C because 40 is not >= 90 and not >= 70 so the else block runs.
//loop prints Count: 0,1,2 because i starts at 0 and increases by 1until it reaches 3. 
//the while loop prints 3,2,1 because n starts at 3 and decreases by 1 until it reaches 0.

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