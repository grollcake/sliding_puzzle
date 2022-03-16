import 'dart:async';

void main() {
  final streamTest = StreamTest();
  streamTest.test();
}

class StreamTest {
  StreamTest() {}

  void test() async {
    final StreamController<String> streamController = StreamController<String>();
    final StreamSubscription subscription = streamController.stream.listen((event) {
      print(event);
    });
    streamController.add('0');
    streamController.add('1');
    streamController.add('2');


    await Future.delayed(Duration(milliseconds: 100));
    subscription.cancel();
    streamController.close();

    await Future.delayed(Duration(milliseconds: 100));

    final StreamSubscription subscription2 = streamController.stream.listen((event) {
      print('This is subscription2: $event');
    });

    streamController.add('3');
    streamController.add('4');



    // streamController.add('new');
  }
}
