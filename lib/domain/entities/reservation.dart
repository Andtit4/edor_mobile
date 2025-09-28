import 'package:freezed_annotation/freezed_annotation.dart';

part 'reservation.freezed.dart';
part 'reservation.g.dart';

enum ReservationStatus { pending, confirmed, inProgress, completed, cancelled }

@freezed
class Reservation with _$Reservation {
  const factory Reservation({
    required String id,
    required String clientId,
    required String prestataireId,
    required String service,
    required DateTime scheduledDate,
    required int duration, // en minutes
    required int totalPrice,
    required ReservationStatus status,
    String? description,
    String? clientNotes,
    String? prestataireNotes,
    String? address,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _Reservation;

  factory Reservation.fromJson(Map<String, dynamic> json) =>
      _$ReservationFromJson(json);
}
