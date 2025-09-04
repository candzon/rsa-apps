class Prediction {
  final int? id;
  final String datetime;
  final double suhuC;
  final double curahHujanMm;
  final int kodeCuaca;
  final double yPred;
  final String unit;
  final DateTime createdAt;

  Prediction({
    this.id,
    required this.datetime,
    required this.suhuC,
    required this.curahHujanMm,
    required this.kodeCuaca,
    required this.yPred,
    required this.unit,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'datetime': datetime,
      'suhu_c': suhuC,
      'curah_hujan_mm': curahHujanMm,
      'kode_cuaca': kodeCuaca,
      'y_pred': yPred,
      'unit': unit,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory Prediction.fromMap(Map<String, dynamic> map) {
    return Prediction(
      id: map['id']?.toInt(),
      datetime: map['datetime'] ?? '',
      suhuC: map['suhu_c']?.toDouble() ?? 0.0,
      curahHujanMm: map['curah_hujan_mm']?.toDouble() ?? 0.0,
      kodeCuaca: map['kode_cuaca']?.toInt() ?? 0,
      yPred: map['y_pred']?.toDouble() ?? 0.0,
      unit: map['unit'] ?? '',
      createdAt: DateTime.parse(map['created_at'] ?? DateTime.now().toIso8601String()),
    );
  }

  String get formattedPrediction => "${yPred.round()} $unit";
}
