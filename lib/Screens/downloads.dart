import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../Models/Filter/filter_data.dart';
import '../Models/Filter/filter_item.dart';
import '../Util/color_util.dart';
import 'DownloadSubScreens/academicdwnlds.dart';
import 'DownloadSubScreens/circulardwnlds.dart';
import 'DownloadSubScreens/examdwnlds.dart';
class DownloadScreen extends StatefulWidget {
  const DownloadScreen({Key? key}) : super(key: key);

  @override
  State<DownloadScreen> createState() => _DownloadScreenState();
}

class _DownloadScreenState extends State<DownloadScreen> with TickerProviderStateMixin  {
  void onSelected(BuildContext context, FilterMenuItem item) {
    switch (item) {
      case FilterMenu.sortByName:
        print('sort by name');
        break;
      case FilterMenu.sortByDate:
        print('sort by date');
        break;
      default:
        throw Error();
    }
  }
  @override
  Widget build(BuildContext context) {
    TabController _tabController = TabController(length: 3, vsync: this);
    return Container(
      width: 1.sw,
      height: 1.sh - 150,
      color: ColorUtil.mainBg,
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: 10),
            width: 1.sw,
            height: 40,
            //margin: EdgeInsets.symmetric(vertical: 10),
            //margin: EdgeInsets.only(top: 15),
            padding: EdgeInsets.symmetric(horizontal: 10),
            color: ColorUtil.mainBg,
            child: TabBar(
              controller: _tabController,
              //isScrollable: true,
              labelColor: Colors.white,
              labelStyle: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w700,
                fontFamily: 'Axiforma',
              ),
              indicator: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Color(0xff25dbdc),
              ),
              //indicatorColor: Colors.white,
              // indicatorSize: TabBarIndicatorSize.tab,
              unselectedLabelColor: Color(0xFF414D55).withOpacity(0.36),
              tabs: [
                Tab(
                  text: 'Circular',
                ),
                Tab(
                  text: 'Academic',
                ),
                Tab(
                  text: 'Exam',
                )
              ],
            ),
          ),
          // Container(
          //   color: Colors.grey.shade200,
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.end,
          //     children: [
          //       Text(
          //         'Filter',
          //         style: TextStyle(
          //           color: Color(0xff6e6e6e),
          //           fontSize: 12.sp,
          //           fontWeight: FontWeight.w400,
          //           fontFamily: 'Axiforma',
          //         ),
          //       ),
          //       SizedBox(
          //         width: 5,
          //       ),
          //       PopupMenuButton<FilterMenuItem>(
          //         onSelected: (item) => onSelected(context, item),
          //         icon: Icon(Icons.arrow_drop_down),
          //         itemBuilder: (context) => [
          //           ...FilterMenu.theFilter.map(buildItem).toList(),
          //         ],
          //       ),
          //     ],
          //   ),
          // ),
          Container(
            width: 1.sw,
            height: 1.sh -200,
            padding: const EdgeInsets.only(bottom: 20),
            child: TabBarView(
              controller: _tabController,
              children: [
                CircularDownloads(),
                AcademicDownloads(),
                ExamDownloads()
              ],
            ),
          )
        ],
      ),
    );
  }
  PopupMenuItem<FilterMenuItem> buildItem(FilterMenuItem item) =>
      PopupMenuItem<FilterMenuItem>(
        child: Text(item.text),
        value: item,
      );
}
