import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:auto_size_text/auto_size_text.dart';
import '../Provider/user_provider.dart';
import '../Models/circular_model.dart';
import '../Util/color_util.dart';
import '../Widgets/circular_widget.dart';

class CircularScreen extends StatefulWidget {
  final bool? isClicked;
  final String? circularId;
  final String? parentId;
  final String? childId;
  final String? acadYear;
  const CircularScreen(
      {Key? key,
      this.isClicked,
      this.parentId,
      this.childId,
      this.acadYear,
      this.circularId})
      : super(key: key);

  @override
  State<CircularScreen> createState() => _CircularScreenState();
}

class _CircularScreenState extends State<CircularScreen> {
  var _circularList = Circular();
  var _isloading = false;
  List<Detail> _ciculars = [];
  // List<Detail> _totalCiculars = [];
  DateFormat _examformatter = DateFormat('dd MMMM');
  var _isOpen = false;
  var _isCheck = false;

  _getCircular(String parentId, String childId, String acadYear) async {
    try {
      setState(() {
        _isloading = true;
      });
      var resp = await Provider.of<UserProvider>(context, listen: false)
          .getCircular(parentId, childId, acadYear);
      print(resp.runtimeType);
      print('staus code-------------->${resp['status']['code']}');
      if (resp['status']['code'] == 200) {
        print('its working');
        _circularList = Circular.fromJson(resp);
        _ciculars = _circularList.data!.details!;
        // _ciculars.forEach((circ) {
        //   _totalCiculars.add(Detail(id: circ.id,title: circ.title,type: circ.type,description: circ.description,attachments: circ.attachments,dateAdded: circ.dateAdded,file: circ.file,sendBy: circ.sendBy,senderName: circ.senderName,weblink: circ.weblink));
        // });
        // _circularList.data!.parent!.forEach((pcirc) {
        //   _totalCiculars.add(Detail(
        //     id: pcirc.id,
        //     title: pcirc.title,
        //     type: pcirc.type,
        //     description: pcirc.description,
        //     attachments: pcirc.attachments,
        //     dateAdded: pcirc.dateAdded,
        //     weblink: pcirc.weblink,
        //     senderName: pcirc.senderName,
        //     sendBy: pcirc.sendBy,
        //     file: pcirc.file
        //   ));
        // });
        // _circularList.data!.child!.forEach((ccirc) {
        //   _totalCiculars.add(Detail(
        //       id: ccirc.id,
        //       title: ccirc.title,
        //       type: ccirc.type,
        //       description: ccirc.description,
        //       attachments: ccirc.attachments,
        //       dateAdded: ccirc.dateAdded,
        //       weblink: ccirc.weblink,
        //       senderName: ccirc.senderName,
        //       sendBy: ccirc.sendBy,
        //       file: ccirc.file
        //   ));
        // });
        _ciculars.sort((a, b) {
          DateTime aa = a.dateAdded!;
          DateTime bb = b.dateAdded!;
          return -1 * aa.compareTo(bb);
        });
        print('parent data-------------->${_circularList.data!.parent}');
        print('child data-------------->${_circularList.data!.child}');
        // print('circular web link -----------${_ciculars.first.weblink}');
        _isCheck = false;
        //print(_circularList.data!.details!.first.title);
        // setState(() {
        //   _ciculars = _circularList.data!.details!;
        // });
        print('cii from wid----${widget.circularId}');
        if (_ciculars.isNotEmpty && (widget.circularId != null)) {
          print('cond true');
          _circularList.data!.details!.forEach((cir) {
            print('id from api---${cir.id}');
            print('id from constructor---${widget.circularId}');
            if (cir.id == widget.circularId) {
              print('enter co');
              _isCheck = true;
              // setState((){
              //   _isCheck = true;
              // });
              print('isopen --->$_isCheck');
            }
          });
        } else {
          print('cond false');
        }
        setState(() {
          _isloading = false;
        });
      } else {
        setState(() {
          _isloading = false;
        });
      }
    } catch (e) {}
  }
  // openCircular(){
  //   _circularList.data!.details!.forEach((cir) {
  //     print('id from api---${cir.id}');
  //     print('id from constructor---${widget.circularId}');
  //     if(cir.id == widget.circularId){
  //
  //       print('isopen --->$_isOpen');
  //       setState((){
  //         _isOpen = true;
  //       });
  //     }else{
  //       setState((){
  //         _isOpen = false;
  //       });
  //       print('isopen --->$_isOpen');
  //     }
  //   });
  // }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    _getCircular(widget.parentId!, widget.childId!, widget.acadYear!);
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(covariant CircularScreen oldWidget) {
    _getCircular(widget.parentId!, widget.childId!, widget.acadYear!);
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {
    // print(widget.isClicked);
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () =>
          _getCircular(widget.parentId!, widget.childId!, widget.acadYear!),
      child: Container(
        height: 1.sh - 150,
        padding: const EdgeInsets.only(top: 10, bottom: 20),
        //margin: EdgeInsets.only(bottom: 20),
        color: ColorUtil.mainBg,
        child: _isloading
            ? ListView.builder(
                itemCount: (1.sh / 150).round(),
                itemBuilder: (ctx, _) => shimmerLoader())
            : MediaQuery.removePadding(
                context: context,
                removeTop: true,
                child: ListView.builder(
                  physics: BouncingScrollPhysics(),
                  itemCount: _ciculars.length,
                  // itemBuilder: (ctx, index) => circularShowWidget(
                  //     date: _ciculars[index].dateAdded!,
                  //     title: _ciculars[index].title,sender: _ciculars[index].sendBy,desc: _ciculars[index].description,attachment: _ciculars),
                  itemBuilder: (ctx, index) => CircularWidget(
                      webLink: _ciculars[index].weblink,
                      circId: _ciculars[index].id,
                      // isOpen: _isCheck,
                      //isOpen:( _ciculars[index].id == widget.circularId) ?true : false,
                      typeCorA: 'Circular',
                      childId: widget.childId,
                      cicularTitle: _ciculars[index].title!.replaceAll("/", "#").replaceAll("_", "#"),
                      circularDesc: _ciculars[index].description,
                      circularDate: _ciculars[index].dateAdded,
                      senderName: _ciculars[index].senderName,
                      attachment: _ciculars[index].attachments),
                ),
              ),
      ),
    );
  }

  Widget shimmerLoader() => Shimmer.fromColors(
        baseColor: Color(0xffcda4de),
        highlightColor: Color(0xffc3d0be),
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          width: 1.sw,
          height: 100,
          decoration: BoxDecoration(
              color: Colors.grey, borderRadius: BorderRadius.circular(10)),
        ),
      );

  Widget circularShowWidget(
          {DateTime? date,
          String? title,
          String? desc,
          String? sender,
          List<Detail>? attachment}) =>
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Container(
              width: 1.sw,
              height: 100,
              padding: EdgeInsets.all(15),
              // margin: EdgeInsets.all(15),
              decoration: BoxDecoration(
                  // border: Border(bottom: BorderSide(width: 1,color: ColorUtil.borderSep.withOpacity(0.1))),
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(10),
                      topLeft: Radius.circular(10)),
                  boxShadow: [
                    BoxShadow(
                        color: const Color(0x1f324dab),
                        offset: Offset(0, 32),
                        blurRadius: 22,
                        spreadRadius: -8)
                  ],
                  gradient: LinearGradient(
                      begin: Alignment(0.5, -3),
                      end: Alignment(0.5, 1),
                      colors: [Colors.white, const Color(0xfff8f9ff)])),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.all(8),
                    height: 62,
                    width: 62,
                    decoration: BoxDecoration(
                      color: ColorUtil.blue,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    child: Center(
                        child: Text(
                      _examformatter.format(date!),
                      textScaleFactor: 1.0,
                      style: TextStyle(color: ColorUtil.white, fontSize: 12.sp),
                    )),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Container(
                    width: 1.sw - 170,
                    height: 50,
                    child: AutoSizeText(
                      title!,
                      maxLines: 2,
                      style: TextStyle(
                          color: ColorUtil.blue, fontWeight: FontWeight.w700),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Icon(
                    Icons.arrow_drop_down_outlined,
                    color: Colors.grey,
                  )
                ],
              ),
            ),
            Container(
              width: 1.sw,
              height: 200,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(10),
                      bottomLeft: Radius.circular(10)),
                  boxShadow: [
                    BoxShadow(
                        color: const Color(0x1f324dab),
                        offset: Offset(0, 32),
                        blurRadius: 22,
                        spreadRadius: -8)
                  ],
                  gradient: LinearGradient(
                      begin: Alignment(0.5, -3),
                      end: Alignment(0.5, 1),
                      colors: [Colors.white, const Color(0xfff8f9ff)])),
              child: Column(
                children: [
                  Text(
                    desc!,
                    textScaleFactor: 1.0,
                  ),
                  Expanded(
                      child: ListView.builder(
                          itemCount:
                              attachment!.isEmpty ? 0 : attachment.length,
                          itemBuilder: (ctx, i) => Text('atta$i'))),
                  Text(
                    sender!,
                    textScaleFactor: 1.0,
                  )
                ],
              ),
            )
          ],
        ),
      );
}
