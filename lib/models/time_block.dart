import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class TimeBlock extends Equatable {
  const TimeBlock({
    required this.startTime,
    required this.endTime,
  });

  final TimeOfDay startTime;
  final TimeOfDay endTime;

  @override
  List<Object?> get props => <Object>[startTime, endTime];
}
