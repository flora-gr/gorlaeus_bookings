class Rooms {
  const Rooms._();

  // Gorlaeus Building
  static const String room1 = 'DM009PC';
  static const String room2 = 'DM013';
  static const String room3 = 'DM017PC';
  static const String room4 = 'DM021PC';
  static const String room5 = 'DM109';
  static const String room6 = 'DM115';
  static const String room7 = 'DM119';
  static const String room8 = 'EM1.17';
  static const String room9 = 'EM1.19';
  static const String room10 = 'EM1.21';
  static const String room11 = 'EM109';
  static const String room12 = 'GM4.13';
  static const String room13 = 'HALL GOB'; // Not lecture room, default hidden

  // Gorlaeus Schotel
  static const String room14 = 'BS.1.17';
  static const String room15 = '04.28 LMUY';
  static const String room16 = 'HAVZ';
  static const String room17 = '01';
  static const String room18 = '02';
  static const String room19 = '03';
  static const String room20 = '04/5';
  static const String room21 = 'HALL'; // Not lecture room, default hidden

  // Huygens
  static const String room22 = 'SITTERZAAL';
  static const String room23 = '106-109';
  static const String room24 = '131';
  static const String room25 = '204';
  static const String room26 = '207';
  static const String room27 = '211/214';
  static const String room28 = '226';
  static const String room29 = '305';
  static const String room30 = '312';
  static const String room31 = '314';
  static const String room32 = '323';
  static const String room33 = '411';

  static const Iterable<String> building1 = <String>[
    room1,
    room2,
    room3,
    room4,
    room5,
    room6,
    room7,
    room8,
    room9,
    room10,
    room11,
    room12,
    room13,
  ];

  static const Iterable<String> building2 = <String>[
    room14,
    room15,
    room16,
    room17,
    room18,
    room19,
    room20,
    room21,
  ];

  static const Iterable<String> building3 = <String>[
    room22,
    room23,
    room24,
    room25,
    room26,
    room27,
    room28,
    room29,
    room30,
    room31,
    room32,
    room33,
  ];

  static const Iterable<String> all = <String>[
    ...building1,
    ...building2,
    ...building3,
  ];
}
