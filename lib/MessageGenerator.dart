import 'dart:math';

class MessageGeneratorPlugin {
  var _seriousReminders = ["Be aware of your posture"];
  var _sarcasticReminders = [
    "It would be a shame if you'd get bad posture for sitting like a banana...",
    "I'd rather be someone else, if I had a curved neck like you do",
    "Wanna be a boomerang or damn human being?",
  ];
  MessageGeneratorPlugin._();

  getMessage(bool isSerious) {
    var rng = new Random();
    if (isSerious) {
      return _seriousReminders[rng.nextInt(_seriousReminders.length)];
    } else {
      return _sarcasticReminders[rng.nextInt(_sarcasticReminders.length)];
    }
  }
}

MessageGeneratorPlugin messageGeneratorPlugin = MessageGeneratorPlugin._();
