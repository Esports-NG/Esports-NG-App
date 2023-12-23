import 'package:equatable/equatable.dart';

abstract class CreateEventState extends Equatable {
  CreateEventState();

  @override
  List<Object> get props => [];
}

/// UnInitialized
class UnCreateEventState extends CreateEventState {

  UnCreateEventState();

  @override
  String toString() => 'UnCreateEventState';
}

/// Initialized
class InCreateEventState extends CreateEventState {
  InCreateEventState(this.hello);
  
  final String hello;

  @override
  String toString() => 'InCreateEventState $hello';

  @override
  List<Object> get props => [hello];
}

class ErrorCreateEventState extends CreateEventState {
  ErrorCreateEventState(this.errorMessage);
 
  final String errorMessage;
  
  @override
  String toString() => 'ErrorCreateEventState';

  @override
  List<Object> get props => [errorMessage];
}
