import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();
}

class HomeInitEvent extends HomeEvent {
  const HomeInitEvent();

  @override
  List<Object?> get props => <Object?>[];
}

class HomeThemeModeChangedEvent extends HomeEvent {
  const HomeThemeModeChangedEvent(this.themeMode);

  final ThemeMode themeMode;

  @override
  List<Object?> get props => <Object?>[themeMode];
}

class HomeDateChangedEvent extends HomeEvent {
  const HomeDateChangedEvent(this.date);

  final DateTime date;

  @override
  List<Object?> get props => <Object?>[date];
}
