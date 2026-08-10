import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pantau/core/error/error.dart';
import 'package:pantau/features/map/data/datasources/datasources.dart';
import 'package:pantau/features/map/data/model/model.dart';
import 'package:pantau/features/map/data/repository/repository.dart';
import 'package:pantau/features/map/domain/entity/entity.dart';

class MockMapRemoteDataSource extends Mock implements MapRemoteDataSource {}

void main() {
  late MockMapRemoteDataSource dataSource;
  late PlaceRepositoryImpl repository;

  setUp(() {
    dataSource = MockMapRemoteDataSource();
    repository = PlaceRepositoryImpl(mapRemoteDataSource: dataSource);
  });

  group('searchPlaces', () {
    test('returns Right of mapped entities on success', () async {
      when(
        () => dataSource.searchPlaces(
          query: any(named: 'query'),
          viewBox: any(named: 'viewBox'),
          limit: any(named: 'limit'),
        ),
      ).thenAnswer(
        (_) async => const [
          PlaceModel(lat: '-6.2', lon: '106.8', name: 'Monas'),
        ],
      );

      final result = await repository.searchPlaces(query: 'Monas');

      expect(result.isRight(), isTrue);
      result.fold(
        (l) => fail('expected Right, got Left($l)'),
        (r) => expect(r.single.name, 'Monas'),
      );
    });

    test(
      'formats the viewBox as minLon,minLat,maxLon,maxLat before delegating',
      () async {
        when(
          () => dataSource.searchPlaces(
            query: any(named: 'query'),
            viewBox: any(named: 'viewBox'),
            limit: any(named: 'limit'),
          ),
        ).thenAnswer((_) async => const []);

        const viewBox = PlaceViewBox(
          minLatitude: 1,
          minLongitude: 2,
          maxLatitude: 3,
          maxLongitude: 4,
        );

        await repository.searchPlaces(query: 'Monas', viewBox: viewBox);

        verify(
          () => dataSource.searchPlaces(
            query: 'Monas',
            viewBox: '2.0,1.0,4.0,3.0',
            limit: 6,
          ),
        ).called(1);
      },
    );

    test('passes a null viewBox through as null', () async {
      when(
        () => dataSource.searchPlaces(
          query: any(named: 'query'),
          viewBox: any(named: 'viewBox'),
          limit: any(named: 'limit'),
        ),
      ).thenAnswer((_) async => const []);

      await repository.searchPlaces(query: 'Monas');

      verify(
        () => dataSource.searchPlaces(query: 'Monas', viewBox: null, limit: 6),
      ).called(1);
    });

    test('returns Left(Failure) when the data source throws', () async {
      when(
        () => dataSource.searchPlaces(
          query: any(named: 'query'),
          viewBox: any(named: 'viewBox'),
          limit: any(named: 'limit'),
        ),
      ).thenThrow(const NetworkException());

      final result = await repository.searchPlaces(query: 'Monas');

      expect(result.isLeft(), isTrue);
      result.fold(
        (l) => expect(l, isA<NetworkFailure>()),
        (r) => fail('expected Left, got Right($r)'),
      );
    });
  });

  group('reverseGeocode', () {
    test('returns Right of the mapped place on success', () async {
      when(
        () => dataSource.reverseGeocode(
          latitude: any(named: 'latitude'),
          longitude: any(named: 'longitude'),
        ),
      ).thenAnswer(
        (_) async => const PlaceModel(lat: '-6.2', lon: '106.8', name: 'Monas'),
      );

      final result = await repository.reverseGeocode(
        latitude: -6.2,
        longitude: 106.8,
      );

      expect(result.isRight(), isTrue);
      result.fold(
        (l) => fail('expected Right, got Left($l)'),
        (r) => expect(r?.name, 'Monas'),
      );
    });

    test('returns Right(null) when the data source finds no address', () async {
      when(
        () => dataSource.reverseGeocode(
          latitude: any(named: 'latitude'),
          longitude: any(named: 'longitude'),
        ),
      ).thenAnswer((_) async => null);

      final result = await repository.reverseGeocode(latitude: 0, longitude: 0);

      expect(result.isRight(), isTrue);
      result.fold(
        (l) => fail('expected Right, got Left($l)'),
        (r) => expect(r, isNull),
      );
    });

    test('returns Left(Failure) when the data source throws', () async {
      when(
        () => dataSource.reverseGeocode(
          latitude: any(named: 'latitude'),
          longitude: any(named: 'longitude'),
        ),
      ).thenThrow(const TimeoutException());

      final result = await repository.reverseGeocode(latitude: 0, longitude: 0);

      expect(result.isLeft(), isTrue);
      result.fold(
        (l) => expect(l, isA<TimeoutFailure>()),
        (r) => fail('expected Left, got Right($r)'),
      );
    });
  });
}
