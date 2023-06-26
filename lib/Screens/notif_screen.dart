import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../Models/notif_model.dart';
import '../Provider/user_provider.dart';
import '../Util/color_util.dart';
import '../Util/spinkit.dart';

class NotifWidget extends StatefulWidget {
  final String? parentId;
  const NotifWidget({Key? key, this.parentId}) : super(key: key);

  @override
  State<NotifWidget> createState() => _NotifWidgetState();
}

class _NotifWidgetState extends State<NotifWidget> {
  var _isloading = false;
  var _notif = Notifications();
  List<AllNotification> _allNotif = [];
  List<int> _items = [];
  int counter = 0;
  final GlobalKey<AnimatedListState> listKey = GlobalKey<AnimatedListState>();
  _getNotif(String parentId) async {
    try {
      setState(() {
        _isloading = true;
      });
      var resp = await Provider.of<UserProvider>(context, listen: false)
          .getNotification(parentId);
      // print(resp.runtimeType);
      _notif = Notifications.fromJson(resp);
      print(_notif.status!.message);
      print('staus code-------------->${resp['status']['code']}');

      if (resp['status']['code'] == 200) {
        setState(() {
          _isloading = false;
        });
        print('its working');

        _notif.data!.details!.allNotifications!.forEach((notific) {
       //  print(counter);
          // listKey.currentState!.insertItem(
          //   counter,
          //   duration: Duration(milliseconds: 500),
          // );

          _allNotif.add(
            AllNotification(
              date: notific.date,
              genDate: notific.genDate,
              iconType: notific.iconType,
              id: notific.id,
              msg: notific.msg,
              recipient: notific.recipient,
              references: notific.references,
              senderId: notific.senderId,
              status: notific.status,
              type: notific.type,
              updatedBy: notific.updatedBy,
              updatedOn: notific.updatedOn,
            ),
          );
         // listKey.currentState!.insertItem(49);
          //counter++;
          // listKey.currentState!.insertItem(
          //   counter,
          //   duration: Duration(milliseconds: 500),
          // );
         //counter++;
        });
        //add(_notif.data!.details!.allNotifications!);
        print('length of notifications ------>${_allNotif.length}');
        //   _circularList = Circular.fromJson(resp);
        //print(_circularList.data!.details!.first.title);
        setState(() {
          //_ciculars = _circularList.data!.details!;
        });
      } else {
        setState(() {
          _isloading = false;
        });
      }
    } catch (e) {}
  }

  void add(List<AllNotification> allno) {
    print(allno.length);
    for (int i = 0; i < 50; i++) {
      print('insi----->$i');
      listKey.currentState!.insertItem(
        0,
        duration: Duration(milliseconds: 800),
      );
     // print('insi33----->$i');
      // print('ff---');
      // _allNotif.add(AllNotification(
      //   date: allno[i].date,
      //   genDate: allno[i].genDate,
      //   iconType: allno[i].iconType,
      //   id: allno[i].id,
      //   msg: allno[i].msg,
      //   recipient: allno[i].recipient,
      //   references: allno[i].references,
      //   senderId: allno[i].senderId,
      //   status: allno[i].status,
      //   type: allno[i].type,
      //   updatedBy: allno[i].updatedBy,
      //   updatedOn: allno[i].updatedOn,
      // ));
      //_items.add(i);
    }

    listKey.currentState!.insertItem(0,
        duration: const Duration(milliseconds: 500));
    _items = []
      ..add(counter++)
      ..addAll(_items);
  }

  @override
  void initState() {
    _getNotif(widget.parentId!);

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notification'),
        centerTitle: true ,
        backgroundColor: ColorUtil.white,
        foregroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(icon: Icon(Icons.arrow_back),onPressed: (){
          Navigator.of(context).pop();
        },),
      ),
      body: _isloading
          ? ListView.builder(itemCount: 6, itemBuilder: (ctx, _) => skeleton)
          : AnimatedList(
              key: listKey,
              initialItemCount: _allNotif.length,
              itemBuilder: (context, index, animation) {
                return slideIt(context, index, animation); // Refer step 3
              },
            ),
    );
  }

  Widget slideIt(BuildContext context, int index, animation) {
    // print(_allNotif[index].msg);
    //int item = _items[index];
    // TextStyle textStyle = Theme.of(context).textTheme.headline4;
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(1.5, 0),
        end: Offset(0, 0),
      ).animate(animation),
      // child: SizedBox( // Actual widget to display
      //   height: 128.0,
      //   child: Card(
      //     color: Colors.primaries[item % Colors.primaries.length],
      //     child: Center(
      //       child: Text('Item $item', style: TextStyle()),
      //     ),
      //   ),
      // ),
      child: eachNotification(_allNotif[index].msg!),
    );
  }

  Widget eachNotification(String msg) => Container(
        margin: EdgeInsets.only(bottom: 10, right: 15, left: 15),
        width: 1.sw,
        height: 100,
        child: Row(
          children: [
            Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 70),
                  child: Container(
                    padding: EdgeInsets.all(15),
                    height: 90,
                    width: 260,
                    decoration: BoxDecoration(
                      color: Color(0xfff7fbfe),
                      borderRadius: BorderRadius.all(
                        Radius.circular(8),
                      ),
                    ),
                    child: Container(
                      width: 250,
                      child: Text(
                        //'HS - Periodic Test -II Report has been published for your child MOHAMED ARSHAD BIN SAMIR',
                        msg,
                        textScaleFactor: 1.0,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15, top: 14),
                  child: Container(
                    height: 60,
                    width: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                      color: Color(0xffe8f2f3),
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: Image(
                            image: AssetImage(
                                'assets/images/notificationlogo.png'),
                            height: 50,
                            width: 50,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      );
}
