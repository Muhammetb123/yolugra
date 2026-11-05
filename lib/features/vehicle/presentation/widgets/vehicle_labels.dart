import '../../../../app/localization/l10n.dart';
import '../../domain/vehicle.dart';

extension VehicleLabels on AppLocalizations {
  String vehicleTypeLabel(VehicleType t) => switch (t) {
        VehicleType.sedan => vehicleTypeSedan,
        VehicleType.hatchback => vehicleTypeHatchback,
        VehicleType.wagon => vehicleTypeWagon,
        VehicleType.suv => vehicleTypeSuv,
        VehicleType.minivan => vehicleTypeMinivan,
        VehicleType.minibus => vehicleTypeMinibus,
        VehicleType.other => vehicleTypeOther,
      };
}
