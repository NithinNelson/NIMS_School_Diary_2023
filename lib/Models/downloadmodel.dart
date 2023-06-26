class DownloadModel {
  String? title;
  String? date;
  String? type;
  String? childId;
  String? path;
 DownloadModel({this.childId,this.path,this.title,this.date,this.type});
 DownloadModel.map({String? filename,String? filePath}){
    title = filename!.split('_')[0];
    childId = filename.split('_')[1];
    date = filename.split('_')[2];
    type = filename.split('_').last.split('.')[0];
    path = filePath;
 }
}