import 'dart:convert';

import 'package:dartz/dartz.dart';


import 'package:http/http.dart' as http;
import 'package:trys_1/src/check_internet.dart';
import 'package:trys_1/src/status_request.dart';

class Crud {

  Future<Either<StatusRequest , Map>> postData(String linkurl, Map data)async{
    try {
      if(await checkInternet()){
        var response = await http.post(Uri.parse(linkurl), body: data);
        print(response.statusCode);
        if(response.statusCode == 200 || response.statusCode == 201){
          Map responsebody = jsonDecode(response.body);
          print(responsebody);
          return Right(responsebody);
        }else{
          return const Left(StatusRequest.serverfailure);

        }
      }else{
        return const Left(StatusRequest.offlinefailure);
      }
    }catch(_){
      print("==========");
      print(_);
      print("==========");
      return const Left(StatusRequest.serverException );
    }
  }
}