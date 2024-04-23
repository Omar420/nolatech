// Import the test package and Counter class
import 'package:flutter_nolatech/counter.dart';
import 'package:test/test.dart';

void main() {
  test('Counter value should be incremented', () {
    // setup
    final counter = Counter();
    // do
    counter.increment();
    // test
    expect(counter.value, 1);
  });
}
