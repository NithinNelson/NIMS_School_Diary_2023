import 'dart:io';

import 'package:external_path/external_path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../Models/downloadmodel.dart';

Future<List<DownloadModel>> getFiles(String location) async{
  List<FileSystemEntity> file = [];
  List<DownloadModel> lists = [];
  var status = await Permission.storage.status;
  bool checkPermission1 = status.isGranted;
  //final path = await ExternalPath.getExternalStoragePublicDirectory(ExternalPath.DIRECTORY_DOWNLOADS);
  final path = (await getApplicationDocumentsDirectory()).path;
  var dir = await Directory('$path/SchoolDiary/$location');
  if (checkPermission1 == true) {
    String dirloc = "";
    if (Platform.isAndroid) {
     // dirloc = '$path/SchoolDiary/$location';


    } else {
      // switch(location){
      //   case "Circular":
      //     location = "${AppConstants.DOWNLOAD_FOLDER}/$location";
      //     break;
      //   case "Academic":
      //     location = "${AppConstants.DOWNLOAD_FOLDER}/$location";
      //     break;
      //   case "Exam":
      //     break;
      // }
      dirloc = (await getApplicationDocumentsDirectory()).path+"/"+location;
    }
    try {
      file = dir.listSync();
      file.forEach((element) {
        print(element.path);
        lists.add( DownloadModel.map(
      filePath: element.path,
 filename: element.path.split('/').last
        ));
      });
    } catch (e) {
      print(e);
    }
  }
  return lists;
}