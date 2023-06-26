import 'package:auto_size_text/auto_size_text.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:external_app_launcher/external_app_launcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../Models/fee_model.dart';
import '../Provider/user_provider.dart';
import '../Util/color_util.dart';
import '../Util/spinkit.dart';
import '../Widgets/feePaid.dart';
import '../Widgets/feePending.dart';

class FeeScreen extends StatefulWidget {
  final String? parentEmail;
  final String? admnNo;
  final String? dataToken;
  const FeeScreen({Key? key, this.admnNo, this.dataToken, this.parentEmail})
      : super(key: key);

  @override
  State<FeeScreen> createState() => _FeeScreenState();
}

class _FeeScreenState extends State<FeeScreen> {
  var selectedTab = 1;
  var _isloading = false;
  var fee = FeeDetails();
  List<dynamic> feeDe = [];
  Map<String, dynamic> feePaid = {};
  List<FeeTotalDetails>? pending = [];
  List<String> voucherList = [];
  _getFee(String admnNo, String dataToken) async {
    try {
      setState(() {
        feeDe.clear();
        feePaid.clear();
        _isloading = true;
      });
      var resp = await Provider.of<UserProvider>(context, listen: false)
          .getFeeDetail(admnNo, dataToken);
      print(resp.runtimeType);
      print('staus code-------------->${resp['status']['code']}');
      if (resp['status']['code'] == 200) {
        setState(() {
          _isloading = false;
        });
        print('its working');
        print(resp['data']['message']);
        // fee = FeeDetails.fromJson(resp);
        // print(fee.data!.details!.first.feeStatus);
        //pending = fee.data!.details;
        feeDe = resp['data']['details'];
        feePaid = resp['data']['fee_paid_data'];
        voucherList = feePaid.keys.toList();
        //print(resp['data']['fee_paid_data'].runtimeType);
        print('length of fee paid------${feePaid.length}');
        //print('length of fee paid------${feePaid.length}');
        // print('length of pending ---------->${pending!.length}');
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

  String paidAmout(String keyy) {
    if (feePaid.containsKey(keyy)) {
      // print('OK');
      //print(keyy);
      return feePaid[keyy]['voucher_total_amount'].toString();
    } else {
      return ' ';
    }
  }

  String transDate(String keyy) {
    if (feePaid.containsKey(keyy)) {
      // print('OK');
      //print(keyy);
      return feePaid[keyy]['transaction_date'].toString();
    } else {
      return ' ';
    }
  }

  List<dynamic> getDetailedFee(String keyy) {
    if (feePaid.containsKey(keyy)) {
      // print('OK');
      //print(keyy);
      return feePaid[keyy]['details'];
    } else {
      return [];
    }
  }

  _makePayment() {
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              actionsAlignment: MainAxisAlignment.center,
              title: Text('Notice'),
              content: Text(
                  "Your Payment will be processed through Skiply. It may take "
                      "2 working days to reflect in your ward's account. In Skyply, "
                      "format to enter admission number is ${widget.admnNo!.replaceAll("/", "Y")}"),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Cancel'),
                ),
                ElevatedButton(
                    onPressed: () async {
                      Navigator.of(context).pop();
                      await LaunchApp.openApp(
                        androidPackageName: 'ae.skiply.rakbank',
                        iosUrlScheme: 'skiply://',
                        appStoreLink:
                            'https://play.google.com/store/apps/details?id=ae.skiply.rakbank&hl=en',
                        // openStore: false
                      );
                    },
                    child: Text('Proceed'))
              ],
            ));
  }

  @override
  void didUpdateWidget(covariant FeeScreen oldWidget) {
    _getFee(widget.admnNo!, widget.dataToken!);
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
  }

  @override
  void didChangeDependencies() {
    _getFee(widget.admnNo!, widget.dataToken!);
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 1.sw,
          height: 50,
          padding: EdgeInsets.symmetric(horizontal: 15),
          // color: Colors.green,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(15),
              bottomRight: Radius.circular(15),
            ),
            boxShadow: [
              BoxShadow(
                  color: const Color(0xccaeaed8),
                  offset: Offset(0, 10),
                  blurRadius: 32,
                  spreadRadius: 0)
            ],
          ),
          child: Row(
            children: [tabItem('Pending', 1), tabItem('Paid', 2)],
          ),
        ),
        Stack(
          children: [
            Container(
                width: 1.sw,
                height: 1.sh - 200,
                padding: EdgeInsets.only(bottom: (selectedTab == 1) ? 90 : 20),
                color: ColorUtil.mainBg,
                child: _isloading
                    ? ListView.builder(
                        itemCount: (1.sh - 200 / 150).round(),
                        itemBuilder: (ctx, _) => skeleton)
                    : selectedTab == 1
                        ? (feeDe.isNotEmpty
                            ? Container(
                                child: MediaQuery.removePadding(
                                  context: context,
                                  removeTop: true,
                                  child: ListView.builder(
                                    physics: BouncingScrollPhysics(),
                                    itemCount: feeDe.length,
                                    itemBuilder: (ctx, i) => FeePending(
                                      amountdue: feeDe[i]['total_demanded'],
                                      feeMonth: feeDe[i]['fee_month'],
                                      amountPaid: feeDe[i]['total_paid'],
                                      balance: feeDe[i]['balance'],
                                      duedate: feeDe[i]['fee_last_date'],
                                      feeDetail: feeDe[i]['details'],
                                    ),
                                  ),
                                ),
                              )
                            : Center(child: Text('No Pending Fee')))
                        : voucherList.isNotEmpty
                            ? MediaQuery.removePadding(
                                context: context,
                                removeTop: true,
                                child: ListView.builder(
                                    physics: BouncingScrollPhysics(),
                                    itemCount: voucherList.length,
                                    itemBuilder: (ctx, i) => FeePaid(
                                          token: widget.dataToken,
                                          admsnNo: widget.admnNo,
                                          parentEmail: widget.parentEmail,
                                          detailList:
                                              getDetailedFee(voucherList[i]),
                                          transactionDate:
                                              transDate(voucherList[i]),
                                          voucherNo: voucherList[i],
                                          totalAmount: paidAmout(
                                            voucherList[i],
                                          ),
                                        )),
                              )
                            : Center(child: Text('No Fee Details Found'))),
            if (selectedTab == 1)
              feeDe.isNotEmpty
                  ? Positioned(
                      bottom: 40,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                primary: ColorUtil.feegreen,
                                minimumSize: Size(1.sw - 30, 50)),
                            onPressed: () {
                              _makePayment();
                            },
                            child: Text('Make Payment')),
                      ))
                  : Container(),
          ],
        )
      ],
    );
  }

  Widget tabItem(String tabName, int activeIndex) => InkWell(
        onTap: () {
          setState(() {
            selectedTab = activeIndex;
            //selectedWid(selectedTab);
          });
        },
        child: Container(
          width: 1.sw / 3 - 10,
          height: 50,
          //color: Colors.blue,
          child: Column(
            children: [
              SizedBox(
                height: 10,
              ),
              SizedBox(
                height: 25,
                child: Text(
                  tabName,
                  textScaleFactor: 1,
                  style: TextStyle(
                      color: selectedTab == activeIndex
                          ? ColorUtil.tabIndicator
                          : ColorUtil.tabIndicator.withOpacity(0.5),
                      fontWeight: FontWeight.w600,
                      //fontFamily: "Axiforma",
                      //fontStyle:  FontStyle.normal,
                      fontSize: 16),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              selectedTab == activeIndex
                  ? Container(
                      width: 1.sw / 3,
                      height: 5,
                      decoration: BoxDecoration(
                          color: ColorUtil.tabIndicator,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10))),
                    )
                  : Container()
            ],
          ),
        ),
      );

  // Widget exp(Map<dynamic,dynamic> amap) {
  //   amap.map((key, value){
  //     return TableRow
  //   } );
  // }
}

class TicketClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();

    path.lineTo(0.0, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0.0);

    path.addOval(
        Rect.fromCircle(center: Offset(size.width * 0.3, 0), radius: 15.0));
    path.addOval(Rect.fromCircle(
        center: Offset(size.width * 0.3, size.height), radius: 15.0));

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class TicketClipper2 extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();

    path.lineTo(0.0, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0.0);

    path.addOval(
        Rect.fromCircle(center: Offset(size.width * 0.3, 0), radius: 15.0));
    path.addOval(Rect.fromCircle(
        center: Offset(size.width * 0.3, size.height), radius: 15.0));

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

@immutable
class ClipShadowPath extends StatelessWidget {
  final Shadow shadow;
  final CustomClipper<Path> clipper;
  final Widget child;

  ClipShadowPath({
    required this.shadow,
    required this.clipper,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      key: UniqueKey(),
      painter: _ClipShadowShadowPainter(
        clipper: this.clipper,
        shadow: this.shadow,
      ),
      child: ClipPath(child: child, clipper: this.clipper),
    );
  }
}

class _ClipShadowShadowPainter extends CustomPainter {
  final Shadow shadow;
  final CustomClipper<Path> clipper;

  _ClipShadowShadowPainter({required this.shadow, required this.clipper});

  @override
  void paint(Canvas canvas, Size size) {
    var paint = shadow.toPaint();
    var clipPath = clipper.getClip(size);
    canvas.drawPath(clipPath, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
