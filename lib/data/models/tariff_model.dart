import '../../core/constants/app_constants.dart';

class TariffSlab {
  const TariffSlab({required this.upto, required this.rate});

  final int upto;
  final double rate;

  factory TariffSlab.fromJson(Map<String, dynamic> json) {
    return TariffSlab(
      upto: (json['upto'] as num).toInt(),
      rate: (json['rate'] as num).toDouble(),
    );
  }
}

class CategoryTariff {
  const CategoryTariff({
    required this.slabs,
    required this.fixedCharge,
    required this.gstPercent,
    required this.fpaPerUnit,
    required this.electricityDutyPercent,
  });

  final List<TariffSlab> slabs;
  final double fixedCharge;
  final double gstPercent;
  final double fpaPerUnit;
  final double electricityDutyPercent;

  factory CategoryTariff.fromJson(Map<String, dynamic> json) {
    return CategoryTariff(
      slabs: (json['slabs'] as List)
          .map((e) => TariffSlab.fromJson(e as Map<String, dynamic>))
          .toList(),
      fixedCharge: (json['fixed_charge'] as num).toDouble(),
      gstPercent: (json['gst_percent'] as num).toDouble(),
      fpaPerUnit: (json['fpa_per_unit'] as num).toDouble(),
      electricityDutyPercent:
          (json['electricity_duty_percent'] as num).toDouble(),
    );
  }
}

class DiscoTariff {
  const DiscoTariff({
    required this.disco,
    required this.protected,
    required this.unprotected,
    required this.lastUpdated,
  });

  final String disco;
  final CategoryTariff protected;
  final CategoryTariff unprotected;
  final String lastUpdated;

  CategoryTariff forCategory(ConsumerCategory category) {
    return category == ConsumerCategory.protected ? protected : unprotected;
  }

  factory DiscoTariff.fromJson(String disco, Map<String, dynamic> json) {
    return DiscoTariff(
      disco: disco,
      protected: CategoryTariff.fromJson(
        json['protected'] as Map<String, dynamic>,
      ),
      unprotected: CategoryTariff.fromJson(
        json['unprotected'] as Map<String, dynamic>,
      ),
      lastUpdated: json['last_updated'] as String,
    );
  }
}

class BillBreakdown {
  const BillBreakdown({
    required this.disco,
    required this.category,
    required this.units,
    required this.energyCharges,
    required this.fixedCharges,
    required this.gst,
    required this.fpa,
    required this.electricityDuty,
    required this.total,
    required this.lastUpdated,
    required this.ratesStale,
  });

  final String disco;
  final ConsumerCategory category;
  final int units;
  final double energyCharges;
  final double fixedCharges;
  final double gst;
  final double fpa;
  final double electricityDuty;
  final double total;
  final String lastUpdated;
  final bool ratesStale;
}
