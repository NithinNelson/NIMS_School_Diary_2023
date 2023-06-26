import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../Models/Filter/filter_data.dart';
import '../../Models/Filter/filter_item.dart';
import '../../Models/downloadmodel.dart';
import '../../Services/getfiles.dart';
import '../../Util/color_util.dart';
import '../../Widgets/circulardwnldwidget.dart';
class ExamDownloads extends StatefulWidget {
  const ExamDownloads({Key? key}) : super(key: key);

  @override
  State<ExamDownloads> createState() => _ExamDownloadsState();
}

class _ExamDownloadsState extends State<ExamDownloads> {
  List<DownloadModel> halltkt = [];
  List<DownloadModel> rCards = [];
  List<DownloadModel> totList = [];
  var _isloading = false;
  void onSelected(BuildContext context, FilterMenuItem item) {
    switch (item) {
      case FilterMenu.sortByName:
        setState((){
          totList.sort((a,b) => a.title!.toLowerCase().compareTo(b.title!.toLowerCase()));
        });
        break;
      case FilterMenu.sortByDate:
        setState((){
          totList.sort((a,b){
            DateTime aa = DateTime.parse("${a.date!.split('-').last}-${a.date!.split('-')[1]}-${a.date!.split('-').first}");
            DateTime bb = DateTime.parse("${b.date!.split('-').last}-${b.date!.split('-')[1]}-${b.date!.split('-').first}");
            return -1 * aa.compareTo(bb);
          });
        });
        break;
      default:
        throw Error();
    }
  }
  getHallTkt() async {
    setState((){
      _isloading = true;
    });
    halltkt = await getFiles('HallTicket');
    totList.addAll(halltkt);
   // print(halltkt.length);
    setState((){
      _isloading = false;
    });
  }
  getReportCards() async {
    setState((){
      _isloading = true;
    });
    rCards = await getFiles('Report');
    totList.addAll(rCards);
    //print(rCards.length);
    print('length of total-------${totList.length}');
    setState((){
      _isloading = false;
    });
  }
  @override
  void initState() {
    getHallTkt();
    getReportCards();
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1.sw,
      height: 1.sh - 200,
     // color: Colors.blue,
      child:
          Column(
            children: [
              Container(
                color: ColorUtil.mainBg,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'Filter',
                      style: TextStyle(
                        color: Color(0xff6e6e6e),
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'Axiforma',
                      ),
                    ),
                    // SizedBox(
                    //   width: 5,
                    // ),
                    PopupMenuButton<FilterMenuItem>(
                      onSelected: (item) => onSelected(context, item),
                      icon: Icon(Icons.arrow_drop_down),
                      itemBuilder: (context) => [
                        ...FilterMenu.theFilter.map(buildItem).toList(),
                      ],
                    ),
                  ],
                ),
              ),
              totList.isEmpty ? SizedBox(
                width: 1.sw,
                  height: 1.sh /2,
                  child: Center(child: Text('No Exam Downloads'))) : Expanded(
                child: MediaQuery.removePadding(
                  context: context,
                  removeTop: true,
                  child: ListView.builder(
                    physics: BouncingScrollPhysics(),
                      itemCount: totList.length,
                      itemBuilder: (ctx,index)=>CircularDwnldWidget(title: totList[index].title,date: totList[index].date,type: totList[index].type,filePath: totList[index].path,)),
                ),
              ),
            ],
          )

    )  ;
  }
  PopupMenuItem<FilterMenuItem> buildItem(FilterMenuItem item) =>
      PopupMenuItem<FilterMenuItem>(
        child: Text(item.text),
        value: item,
      );
}
