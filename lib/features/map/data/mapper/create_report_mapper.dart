import '../../../../core/error/error.dart';
import '../../../../core/utils/enums/enums.dart';
import '../../domain/entity/entity.dart';
import '../model/model.dart';
import 'date_parser.dart';

extension CreateReportModelMapper on CreateReportModel {
  ReportDetail toEntity() {
    final data = this.data;
    if (data == null) {
      throw const UnknownException('Report was not created');
    }

    return data.toEntity();
  }
}

extension CreateReportDataModelMapper on CreateReportDataModel {
  ReportDetail toEntity() {
    return ReportDetail(
      id: id,
      category: category?.toEntity(),
      description: description,
      photoUrl: photoUrl,
      latitude: latitude,
      longitude: longitude,
      status: ReportStatus.fromSlug(status),
      createdAt: parseDate(createdAt),
      updatedAt: parseDate(updatedAt),
    );
  }
}

extension CreateReportCategoryModelMapper on CreateReportCategoryModel {
  ReportCategory toEntity() {
    return ReportCategory(id: id, name: name, slug: slug, isActive: isActive);
  }
}
