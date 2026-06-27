import '../../core/constants/app_constants.dart';
import '../models/tariff_model.dart';

class BillCalculatorService {
  BillBreakdown calculate({
    required DiscoTariff tariff,
    required ConsumerCategory category,
    required int units,
    required bool ratesStale,
  }) {
    final categoryTariff = tariff.forCategory(category);

    final energyCharges = _calculateEnergyCharges(units, categoryTariff.slabs);
    final fixedCharges = categoryTariff.fixedCharge;
    final taxableBase = energyCharges + fixedCharges;
    final gst = taxableBase * (categoryTariff.gstPercent / 100);
    final fpa = units * categoryTariff.fpaPerUnit;
    final electricityDuty =
        energyCharges * (categoryTariff.electricityDutyPercent / 100);
    final total = energyCharges + fixedCharges + gst + fpa + electricityDuty;

    return BillBreakdown(
      disco: tariff.disco,
      category: category,
      units: units,
      energyCharges: energyCharges,
      fixedCharges: fixedCharges,
      gst: gst,
      fpa: fpa,
      electricityDuty: electricityDuty,
      total: total,
      lastUpdated: tariff.lastUpdated,
      ratesStale: ratesStale,
    );
  }

  double _calculateEnergyCharges(int units, List<TariffSlab> slabs) {
    if (units <= 0 || slabs.isEmpty) return 0;

    double total = 0;
    var previousUpto = 0;

    for (final slab in slabs) {
      if (units <= previousUpto) break;

      final upper = slab.upto;
      final unitsInSlab = (units < upper ? units : upper) - previousUpto;
      if (unitsInSlab > 0) {
        total += unitsInSlab * slab.rate;
      }
      previousUpto = upper;
    }

    return total;
  }
}
