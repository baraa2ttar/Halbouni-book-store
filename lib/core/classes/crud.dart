import 'package:adv/core/classes/status_class.dart';
import 'package:adv/core/classes/check_internet.dart';
import 'package:http/http.dart' as http;
import 'package:dartz/dartz.dart';
import 'dart:convert';

class Crud {
  Future<Either<Status_Classes, dynamic>> postData(
    String link,
    Map body,
    Map<String, String> headers,
  ) async {
    try {
      if (await Check_Internet()) {
        print('Making POST request to: $link');
        print('Request body: ${jsonEncode(body)}');
        print('Request headers: $headers');

        var response = await http.post(
          Uri.parse(link),
          body: jsonEncode(body),
          headers: headers,
        );

        print('Response status code: ${response.statusCode}');
        print('Response body: ${response.body}');

        if (response.statusCode == 200 || response.statusCode == 201) {
          // Handle empty response body (common with Prefer: return=minimal)
          if (response.body.isEmpty) {
            print('Success with empty response body');
            return Right({'success': true, 'status': response.statusCode});
          }

          var responseBody = jsonDecode(response.body);
          print('Parsed response: $responseBody');
          return Right(responseBody);
        } else {
          print('Server error: ${response.statusCode} - ${response.body}');
          return Left(Status_Classes.Server_Error);
        }
      } else {
        print('No internet connection');
        return Left(Status_Classes.Offline_Error);
      }
    } catch (e) {
      print('Exception in postData: $e');
      return Left(Status_Classes.Server_Error);
    }
  }

  Future<Either<Status_Classes, dynamic>> getData(
    String link,
    Map<String, String> headers,
  ) async {
    try {
      if (await Check_Internet()) {
        var response = await http.get(Uri.parse(link), headers: headers);
        if (response.statusCode == 200) {
          var responseBody = jsonDecode(response.body);
          print(responseBody);
          return Right(responseBody);
        } else {
          return Left(Status_Classes.Server_Error);
        }
      } else {
        return Left(Status_Classes.Offline_Error);
      }
    } catch (e) {
      return Left(Status_Classes.Server_Error);
    }
  }

  Future<Either<Status_Classes, Map>> putData(
    String link,
    Map body,
    Map<String, String> headers,
  ) async {
    try {
      if (await Check_Internet()) {
        var response = await http.put(
          Uri.parse(link),
          body: jsonEncode(body),
          headers: headers,
        );
        if (response.statusCode == 200 || response.statusCode == 204) {
          Map responseBody = jsonDecode(
            response.body.isNotEmpty ? response.body : '{}',
          );
          print(responseBody);
          return Right(responseBody);
        } else {
          return Left(Status_Classes.Server_Error);
        }
      } else {
        return Left(Status_Classes.Offline_Error);
      }
    } catch (e) {
      return Left(Status_Classes.Server_Error);
    }
  }

  Future<Either<Status_Classes, Map>> deleteData(
    String link,
    Map<String, String> headers,
  ) async {
    try {
      if (await Check_Internet()) {
        var response = await http.delete(Uri.parse(link), headers: headers);
        if (response.statusCode == 200 || response.statusCode == 204) {
          Map responseBody =
              response.body.isNotEmpty ? jsonDecode(response.body) : {};
          print(responseBody);
          return Right(responseBody);
        } else {
          return Left(Status_Classes.Server_Error);
        }
      } else {
        return Left(Status_Classes.Offline_Error);
      }
    } catch (e) {
      return Left(Status_Classes.Server_Error);
    }
  }
}
