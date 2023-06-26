import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../Models/user_model.dart';
import '../Util/api_constants.dart';
import '../Util/color_util.dart';

class ProfileScreen extends StatelessWidget {
  final String? userPhoto;
  final String? username;
  final String? emailId;
  final String? address;
  final String? mobileNo;
  final List<StudentDetail>? studentList;
  const ProfileScreen(
      {Key? key,
        this.userPhoto,
      this.username,
      this.address,
      this.emailId,
      this.studentList,
      this.mobileNo})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(userPhoto);
    return Column(
      children: [
        Container(
          width: 1.sw,
        //height:1.sh/2 + 140,
          height: (studentList!.length >2) ? 1.sh/2 + 140 :1.sh/2 + 15 + (studentList!.length * 40) ,
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          //color: Colors.red,
          margin: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          decoration: BoxDecoration(
            color: Color(0xffffffff),
            borderRadius: BorderRadius.all(Radius.circular(15)),
            boxShadow: [
              BoxShadow(
                  color: Colors.black12,
                  offset: Offset(0, 0),
                  blurRadius: 1,
                  spreadRadius: 0),
              BoxShadow(
                  color: Colors.black12,
                  offset: Offset(0, 2),
                  blurRadius: 6,
                  spreadRadius: 0),
              BoxShadow(
                  color: Colors.black12,
                  offset: Offset(0, 10),
                  blurRadius: 20,
                  spreadRadius: 0)
            ],
          ),
          child: Column(
            //mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Hello,",
                        textScaleFactor: 1.0,
                        style: TextStyle(
                            color: Color(0xffe8a420),
                            fontWeight: FontWeight.w300,
                            //fontFamily: "Axiforma",
                            //fontStyle: FontStyle.normal,
                            fontSize: 18.sp),
                      ),
                      AutoSizeText(username!,
                        textScaleFactor: 1.0,
                        style: TextStyle(
                          color: ColorUtil.profName,
                          fontWeight: FontWeight.w500,
                         // fontFamily: "Axiforma",
                         // fontStyle:  FontStyle.normal,
                          fontSize: 19.sp
                      ),),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            //mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              indicators(
                                  emailId!, 'assets/images/EmailLogo.png'),
                              indicators(
                                  mobileNo!, 'assets/images/ContactLogo.png'),
                              indicators(
                                  address!, 'assets/images/LocationLogo.png')
                            ],
                          ),
                          CircleAvatar(
                            radius: 30,
                            backgroundColor: ColorUtil.studName,
                            child: ClipRRect(
                              borderRadius: BorderRadius.all(Radius.circular(60)),
                              child: CachedNetworkImage(
                                imageUrl: '${ApiConstants.downloadUrl}$userPhoto',
                                // placeholder: (context, url) => SizedBox(
                                //   width: 20,
                                //   height: 20,
                                //   child: CircularProgressIndicator(),
                                // ),
                                placeholder: (context, url) => Image.asset(
                                  'assets/images/userImage.png',
                                  width: 50,
                                  height: 50,
                                ),
                                errorWidget: (context, url, error) => Image.asset(
                                  'assets/images/userImage.png',
                                  width: 50,
                                  height: 50,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                      Container(
                        width: 1.sw - 60,
                        height: 1.sh / 4 ,
                       // height: 200,
                        //color: Colors.red,
                        child: ListView.separated(
                          physics: BouncingScrollPhysics(),
                          separatorBuilder: (ctx,i) => Divider(),
                          itemCount: studentList!.length,
                          itemBuilder: (ctx, i) => ListTile(
                            title: AutoSizeText('${studentList![i].name}',maxFontSize: 16,maxLines: 1,style: TextStyle(
                                color:  ColorUtil.studName,
                                fontWeight: FontWeight.w500,

                            ),),
                            subtitle: Text('Grade ${studentList![i].studentDetailClass}${studentList![i].batch}',textScaleFactor: 1.0,),

                            trailing: CircleAvatar(
                              radius: 25,
                              backgroundColor: Colors.white,
                              child: ClipRRect(
                                borderRadius: BorderRadius.all(Radius.circular(60)),
                                child: CachedNetworkImage(
                                  imageUrl: '${ApiConstants.downloadUrl}${studentList![i].photo}',
                                  fit: BoxFit.cover,
                                  width: 50,
                                  height: 50,
                                  // placeholder: (context, url) => SizedBox(
                                  //   width: 20,
                                  //   height: 20,
                                  //   child: CircularProgressIndicator(),
                                  // ),
                                  placeholder: (context, url) => SizedBox(

                                    child: Image.asset(
                                      'assets/images/userImage.png',
                                      width: 50,
                                      height: 50,
                                    ),
                                  ),
                                  errorWidget: (context, url, error) => Image.asset(
                                    'assets/images/userImage.png',
                                    width: 50,
                                    height: 50,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  )
                ],
              )
            ],
          ),
        )
      ],
    );
  }

  Widget indicators(String title, String img) => Container(
        width: 1.sw / 2 + 50,
        height: 50,
        //color: Colors.red,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              img,
              width: 25,
              height: 25,
            ),
            SizedBox(
              width: 10,
            ),
            SizedBox(
              width: 1.sw / 2,
              height: 50,
              child: AutoSizeText(
                title,
                textScaleFactor: 1.0,
                maxLines: 2,
              ),
            )
          ],
        ),
      );
}
