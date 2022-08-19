import 'package:equatable/equatable.dart';
import 'package:gorlaeus_bookings/data/time_block.dart';

class BookingEntry extends Equatable {
  const BookingEntry({
    required this.time,
    required this.room,
    required this.personCount,
    required this.bookedOnBehalfOf,
    required this.activity,
    required this.user,
  });

  final TimeBlock? time;
  final String room;
  final int? personCount;
  final String bookedOnBehalfOf;
  final String activity;
  final String user;

  @override
  List<Object?> get props => <Object?>[
        time,
        room,
        personCount,
        bookedOnBehalfOf,
        activity,
        user,
      ];
}
