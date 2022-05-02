// ignore_for_file: public_member_api_docs

part of 'chrome_dino_cubit.dart';

enum ChromeDinoStatus {
  idle,
  chomping,
}

class ChromeDinoState extends Equatable {
  const ChromeDinoState({
    required this.status,
    required this.isMouthOpen,
    this.ball,
  });

  const ChromeDinoState.inital()
      : this(
          status: ChromeDinoStatus.idle,
          isMouthOpen: false,
        );

  final ChromeDinoStatus status;
  final bool isMouthOpen;
  final Ball? ball;

  ChromeDinoState copyWith({
    ChromeDinoStatus? status,
    bool? isMouthOpen,
    Ball? ball,
  }) {
    final state = ChromeDinoState(
      status: status ?? this.status,
      isMouthOpen: isMouthOpen ?? this.isMouthOpen,
      ball: ball ?? this.ball,
    );
    return state;
  }

  @override
  List<Object?> get props => [
        status,
        isMouthOpen,
        ball,
      ];
}
