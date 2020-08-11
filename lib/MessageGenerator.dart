import 'dart:math';

class MessageGeneratorPlugin {
  var _seriousReminders = [
    "Be aware of your posture",
    "Sit straight, you will thank yourself a few years down the line",
    "Straighten your back",
    "Straighten your neck, put your shoulders back",
    "Try stretching a little. You will feel better afterwards",
    "Great posture looks good on you!"
  ];
  var _sarcasticReminders = [
    "It would be a shame if you'd get bad posture for sitting like a banana...",
    "I'd rather be someone else, if I had a curved neck like you do",
    "Wanna be a boomerang or damn human being?",
    "Thats exactly how you get backpain a few years down the road",
    "You probably did not stretch today. Not even once, right?",
    "If you continue like this, it will only get worse. Maybe thats what you are trying to achieve.."
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
