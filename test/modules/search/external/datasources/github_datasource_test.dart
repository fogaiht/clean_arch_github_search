import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:github_search/modules/search/domain/errors/errors.dart';
import 'package:github_search/modules/search/external/datasources/github_datasource.dart';
import 'package:mockito/mockito.dart';

import '../../utils/github_response.dart';

class DioMock extends Mock implements Dio {}

main() {
  final dio = DioMock();
  final datasource = GithubDatasource(dio);

  test("deve retornar uma lista de ResultModel", () async {
    when(dio.get(any)).thenAnswer((_) async => Response(data: jsonDecode(githubResult), statusCode: 200));

    final result = datasource.getSearch("searchText");
    expect(result, completes);
  });

  test("deve retornar um erro se o código não for 200", () async {
    when(dio.get(any)).thenAnswer((_) async => Response(data: null, statusCode: 401));

    final result = datasource.getSearch("searchText");
    expect(result, throwsA(isA<DatasourceError>()));
  });
  
  test("deve retornar uma Exception se tiver um erro no Dio", () async {
    when(dio.get(any)).thenThrow(Exception());

    final result = datasource.getSearch("searchText");
    expect(result, throwsA(isA<Exception>()));
  });
}
