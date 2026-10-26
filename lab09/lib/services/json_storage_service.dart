import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class JsonStorageService{
  Future<File> getLocalFile() async{
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/product.json');
  }
  Future<List<Map<String, dynamic>>> loadProducts() async{
    final file = await getLocalFile();
    if(!await file.exists()){
      await file.writeAsString('[]');
      return [];
    }
    final jsonString = await file.readAsString();
    if(jsonString.trim().isEmpty){
      return [];
    }
    final List<dynamic> data=jsonDecode(jsonString);
    return data.map((item)=>Map<String, dynamic>.from(item)).toList();
  }
  Future<void> saveProducts(List<Map<String, dynamic>>products,) async{
    final file = await getLocalFile();
    final jsonString = jsonEncode(products);
    await file.writeAsString(jsonString, flush: true);
  }
}