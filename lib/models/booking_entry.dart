import 'package:equatable/equatable.dart';
import 'package:gorlaeus_bookings/models/time_block.dart';

class BookingEntry extends Equatable {
  const BookingEntry({
    required this.time,
    required this.room,
    required this.activity,
    required this.user,
  });

  final TimeBlock? time;
  final String room;
  final String activity;
  final String user;

  @override
  List<Object?> get props => <Object?>[
        time,
        room,
        activity,
        user,
      ];
}
