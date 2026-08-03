import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../core/base/base.dart';
import '../../../../core/error/error.dart';
import '../entity/entity.dart';
import '../repository/repository.dart';

class CreateReportParams extends Equatable {
  const CreateReportParams({
    required this.categoryId,
    required this.description,
    required this.photoPath,
    required this.latitude,
    required this.longitude,
  });

  final int categoryId;
  final String description;
  final String photoPath;
  final double latitude;
  final double longitude;

  @override
  List<Object?> get props => [
    categoryId,
    description,
    photoPath,
    latitude,
    longitude,
  ];
}

class CreateReportUsecase extends UseCase<ReportDetail, CreateReportParams> {
  CreateReportUsecase({required this._mapRepository});

  final MapRepository _mapRepository;

  @override
  Future<Either<Failure, ReportDetail>> call(CreateReportParams params) =>
      _mapRepository.createReport(
        categoryId: params.categoryId,
        description: params.description,
        photoPath: params.photoPath,
        latitude: params.latitude,
        longitude: params.longitude,
      );
}
