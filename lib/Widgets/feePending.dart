import 'package:auto_size_text/auto_size_text.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../Util/color_util.dart';

class FeePending extends StatefulWidget {
  final String? feeMonth;
  final String? amountdue;
  final String? amountPaid;
  final String? balance;
  final String? duedate;
  final Map<dynamic,dynamic>? feeDetail;
  const FeePending({Key? key,this.feeMonth,this.amountdue,this.amountPaid,this.balance,this.duedate,this.feeDetail}) : super(key: key);

  @override
  State<FeePending> createState() => _FeePendingState();
}

class _FeePendingState extends State<FeePending> {
  var _isExpanded = false;
  var detailKey;
  List<String> keyList = [];
  var totaldue;
  var totalpaid;
  details(){
    widget.feeDetail!.forEach((key, value) {
      if(key== 'total' || key == 'late_fee'){
        return;
      }else{
        keyList.add(key);
      }

    });

  }
    String dueAmt(String keyy){
    if(widget.feeDetail!.containsKey(keyy)){
     // print('OK');
      //print(keyy);
      return widget.feeDetail![keyy]['demanded_amount'].toString();
    }else{
      return ' ';
    }
  }
  String paidAmt(String keyy){
    if(widget.feeDetail!.containsKey(keyy)){
      //print('OK');
      //print(keyy);
      return widget.feeDetail![keyy]['paid_amount'].toString();
    }else{
      return ' ';
    }
  }
  // String dueAmount(String keyy){
  //   if(widget.feeDetail!.containsKey(keyy)){
  //     widget.feeDetail!.forEach((key, value) {
  //       if(key == keyy){
  //        return value;
  //       }
  //     });
  //   }else{
  //     return '';
  //   }
  //   return '';
  // }
  @override
  void initState() {
    keyList.clear();
    details();

    //print('length ${widget.feeDetail!.length}');
    widget.feeDetail!.forEach((key, value) {
      // print('keee----->$value');
      // print(value.runtimeType);
      // print(value[0]['balance_amount']);
     // keyList.addAll(key);
    });
    // print('list length------>${keyList.length}');
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1.sw,
      //height: 450,
      // color: Colors.red,
      margin: EdgeInsets.symmetric(horizontal: 15,vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
              color: Colors.black12,
              offset: Offset(0,0),
              blurRadius: 1,
              spreadRadius: 0
          ), BoxShadow(
              color: Colors.black12,
              offset: Offset(0,2),
              blurRadius: 6,
              spreadRadius: 0
          ), BoxShadow(
              color: Colors.black12,
              offset: Offset(0,10),
              blurRadius: 20,
              spreadRadius: 0
          )
        ],),

      child: Column(

        children: [
          GestureDetector(
            onTap: (){
              setState((){
                _isExpanded = !_isExpanded;
              });
            },
            child: Container(
              width: 1.sw,

              height: 180,
              decoration: BoxDecoration(
                 //color: Colors.red,

                  borderRadius: BorderRadius.circular(15)
              ),
              child: Column(
                children: [
                  Container(
                    width: 1.sw,
                    height: 50,
                    decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(15),
                            topLeft: Radius.circular(15)
                        )
                    ),
                    child: Center(child: Text('${widget.feeMonth}',textScaleFactor:1.0,style: TextStyle(
                        color:  Colors.white,
                        fontWeight: FontWeight.w500,
                        fontFamily: "Montserrat",
                        //fontStyle:  FontStyle.normal,
                        fontSize: 16.sp
                    ))),
                  ),
                  feePendingTab('Amount Due', 'AED  ${widget.amountdue}'),
                  feePendingTab('Amount Paid','AED  ${widget.amountPaid}'),
                  feePendingTab('Balance',    'AED  ${widget.balance}'),
                  feePendingTab('Due Date',    '${DateFormat('dd MMMM yyyy').format(DateTime.parse(widget.duedate!))}'),
                  _isExpanded ? Image.asset('assets/images/up_arrow.png',width: 20,height: 20,) : Image.asset('assets/images/down_arrow.png',width: 20,height: 20,)
                ],
              ),
            ),
          ),
          if(_isExpanded)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5,vertical: 15),
            child: Stack(
              children: [
                // Container(
                //   width: 1.sw,
                //   height: 50 * double.parse(keyList.length.toString()),
                // ),
                // Container(
                //   width: 1.sw,
                //  height: 60 * double.parse(keyList.length.toString()) +130,
                //     decoration: BoxDecoration(
                //         // color: ColorUtil.feegrlt,
                //         borderRadius: BorderRadius.circular(15)
                //     ),
                //
                //   margin: EdgeInsets.symmetric(horizontal: 10),
                //
                //   child: Text(''),
                // ),
                Container(
                  width: 1.sw,
                  //height: 150,

                  decoration: BoxDecoration(
                      color: ColorUtil.feebluelt,
                    borderRadius: BorderRadius.circular(15)
                  ),
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  child: DottedBorder(
                    radius: Radius.circular(12),
                    borderType: BorderType.RRect,
                    color: ColorUtil.feeblue,
                    child: Table(
                        columnWidths: {
                          0: FlexColumnWidth(2.8),
                          1: FlexColumnWidth(2.5),
                          2: FlexColumnWidth(2),
                        },
                      //defaultVerticalAlignment: TableCellVerticalAlignment.middle,

                      children: [
                        TableRow(
                          decoration: BoxDecoration(
                            color: ColorUtil.feetitle.withOpacity(0.1)
                          ),
                            children: [
                              Container(
                                  height: 60,
                                  padding: EdgeInsets.only(left: 10),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Description',textScaleFactor: 0.95,style: TextStyle(
                                          fontFamily: 'Axiforma',
                                        fontSize: 15,
                                        fontWeight: FontWeight.w700
                                      ),),
                                    ],
                                  )),
                              Container(
                                  height: 60,
                                  padding: EdgeInsets.only(left: 3.5),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Due',textScaleFactor:0.95,style: TextStyle(
                                          fontFamily: 'Axiforma',
                                          fontSize: 15,
                                          fontWeight: FontWeight.w700
                                      ),),
                                    ],
                                  )),
                              Container(
                                height: 60,

                                  child: Container(
                                      height: 60,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text('Paid',textScaleFactor:0.95,style: TextStyle(
                                              fontFamily: 'Axiforma',
                                              fontSize: 15,
                                              fontWeight: FontWeight.w700
                                          ),),
                                        ],
                                      )))
                            ]
                        ),
                        ...keyList.asMap().map((ind,e) => MapEntry(ind, TableRow(
                            decoration: BoxDecoration(
                                color:(ind % 2 ==0) ? Colors.transparent:ColorUtil.feeblue.withOpacity(0.1)
                            ),
                            children: [
                              Container(
                                constraints: BoxConstraints(
                                  minHeight: 60
                                ),
                                padding: EdgeInsets.only(left: 10),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(e,
                                    textScaleFactor:0.95,
                                      style:  TextStyle(
                                        fontFamily: 'Axiforma',
                                        color: ColorUtil.feeblue,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w400,
                                        //fontStyle: FontStyle.normal,
                                        // letterSpacing: 0,

                                      ),),
                                  ],
                                ),
                              ),
                              Container(
                                constraints: BoxConstraints(
                                  minHeight: 60
                                ),
                                padding: EdgeInsets.only(left: 3.5),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('AED ${dueAmt(e)}',textScaleFactor:0.95,style:  TextStyle(
                                      fontFamily: 'Axiforma',
                                      color: ColorUtil.feeblue,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w400,
                                      //fontStyle: FontStyle.normal,
                                      // letterSpacing: 0,

                                    ),),
                                  ],
                                ),
                              ),
                              Container(
                                constraints: BoxConstraints(
                                  minHeight: 60
                                ),

                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('AED ${paidAmt(e)}',textScaleFactor:0.95,style:  TextStyle(
                                      fontFamily: 'Axiforma',
                                      color: ColorUtil.feeblue,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w400,
                                      //fontStyle: FontStyle.normal,
                                      // letterSpacing: 0,

                                    ),),
                                  ],
                                ),
                              )
                            ]
                        ))).values.toList()
                        // TableRow(
                        //   children: [
                        //     ...keyList!.map((e) => Text(e)).toList()
                        //   ]
                        // )

                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (_isExpanded)
            Container(
              width: 1.sw,
              //height: 50,
              //color: Colors.blue,
              // margin: EdgeInsets.symmetric(horizontal: 10),
              child: Padding(
                padding: const EdgeInsets.only(left: 15, right: 15),
                child: Container(
                  decoration: BoxDecoration(
                      color: ColorUtil.feebluelt,
                      borderRadius: BorderRadius.circular(15)
                  ),
                  child: DottedBorder(
                    radius: Radius.circular(12),
                    borderType: BorderType.RRect,
                    color: ColorUtil.feeblue,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Table(
                        columnWidths: {
                          0: FlexColumnWidth(2.8),
                          1: FlexColumnWidth(2.5),
                          2: FlexColumnWidth(2),
                        },
                        children: [
                          TableRow(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Text('Total',textScaleFactor:1.0,style: TextStyle(
                                    fontFamily: 'Axiforma',
                                    color: ColorUtil.feegreen,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    //fontStyle: FontStyle.normal,
                                    //letterSpacing: 0,

                                  )),
                                ),
                                Text('AED ${widget.amountdue}',textScaleFactor:1.0,style: TextStyle(
                                  fontFamily: 'Axiforma',
                                  color: ColorUtil.feegreen,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  //fontStyle: FontStyle.normal,
                                  //letterSpacing: 0,

                                )),
                                Text('AED ${widget.amountPaid}',textScaleFactor:1.0,style: TextStyle(
                                  fontFamily: 'Axiforma',
                                  color: ColorUtil.feegreen,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  //fontStyle: FontStyle.normal,
                                  //letterSpacing: 0,

                                ))
                              ]
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          if(_isExpanded)
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15,vertical: 10),
            child: DottedBorder(
              borderType: BorderType.RRect,
                radius: Radius.circular(12),
                color: ColorUtil.feegreen,
                child: Container(
                  decoration: BoxDecoration(
                      color: ColorUtil.feegrlt,
                      borderRadius: BorderRadius.circular(15)
                  ),
              width: 1.sw,
              height: 50,
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Balance To Pay' ,textScaleFactor:1.0,style: TextStyle(
                    fontFamily: 'Axiforma',
                    color: ColorUtil.feegreen,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    //fontStyle: FontStyle.normal,
                    //letterSpacing: 0,

                  ),),
                          Text(':',style: TextStyle(
                          fontFamily: 'Axiforma',
                            color: ColorUtil.feegreen,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            //fontStyle: FontStyle.normal,
                            //letterSpacing: 0,

                          ),),
                      Text('AED ${widget.balance}',textScaleFactor:1.0,style: TextStyle(
                        fontFamily: 'Axiforma',
                        color: ColorUtil.feegreen,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        //fontStyle: FontStyle.normal,
                        //letterSpacing: 0,

                      ),)

                    ],
                  ),
            )),
          )

        ],
      ),
    );
  }
  Widget feePendingTab(String left,String right) => Container(
    width: 1.sw,
    height: 20,
    margin: EdgeInsets.symmetric(horizontal: 15,vertical: 2),
    //color: Colors.grey,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          width: 1.sw/2 - 50,
          // color: Colors.green,
          child: AutoSizeText(left,textAlign: TextAlign.left,),
        ),
        Text(':'),
        Container(
          width: 1.sw/2 - 50,
          // color: Colors.green,
          child: AutoSizeText(

            right,textAlign: TextAlign.left,),
        ),

      ],
    ),
  );
}
