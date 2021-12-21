import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Holepage extends StatefulWidget {
  @override
  HolepageState createState() => HolepageState();
}

class HolepageState extends State<Holepage> {
  String formattedDate;
  final firestoreInstance = FirebaseFirestore.instance;
  List list = [];

  String formattedyesterday;
  final TextEditingController myController = new TextEditingController();
  String englishlocation;
  String holename;

  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('坑洞資料'),
        ),
        body: Center(
          child: list.isEmpty
              ? Container(
                  margin:
                      EdgeInsets.only(left: 25, top: 5, right: 25, bottom: 5),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          '請輸入欲查詢日期或區域',
                          style: TextStyle(fontSize: 20),
                        ),
                        TextField(
                          controller: myController,
                          decoration: InputDecoration(hintText: 'EX:平溪區/0101'),
                        ),
                        ElevatedButton(
                            onPressed: () async {
                              if (myController.text.isEmpty == true) {
                                Fluttertoast.showToast(
                                    msg: "請輸入欲查詢日期或區域再查詢",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.CENTER,
                                    timeInSecForIosWeb: 3,
                                    backgroundColor: Colors.black,
                                    textColor: Colors.white,
                                    fontSize: 16.0);
                              }
                              list.clear();
                              var result = await firestoreInstance
                                  .collection(myController.text)
                                  .get();
                              result.docs.forEach((res) {
                                if (res.data()["hole"] == "yes") {
                                  setState(() {
                                    list.add(res.data());
                                  });
                                }
                              });
                              if (list.isEmpty == true) {
                                Fluttertoast.showToast(
                                    msg: "該日/該區並無坑洞資料",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.CENTER,
                                    timeInSecForIosWeb: 3,
                                    backgroundColor: Colors.black,
                                    textColor: Colors.white,
                                    fontSize: 16.0);
                              }
                            },
                            child: Text('查詢')),
                      ]))
              : ListView.separated(
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    return Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.only(
                            left: 15, top: 5, right: 15, bottom: 5),
                        decoration: BoxDecoration(
                            gradient: LinearGradient(colors: [
                              Colors.lightBlue.shade300,
                              Colors.lightBlue.shade200,
                              Colors.lightBlue.shade100
                            ]),
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.all(Radius.circular(30)),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.blue, offset: Offset(2, 2)),
                              BoxShadow(color: Colors.grey)
                            ]),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              '位置：${list[index]['address']}', style: TextStyle(fontSize: 15),
                            ),
                            Text(
                              '類型：${list[index]['type']}', style: TextStyle(fontSize: 17),
                            ),
                            Text(
                              '信心值：${list[index]['confidences']}', style: TextStyle(fontSize: 17),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Container(),
                                Container(),
                                ElevatedButton.icon(
                                  label: Text('查看此坑洞'),
                                  icon: Icon(Icons.visibility),
                                  onPressed: () async {
                                    var url = '${list[index]['url']}';
                                    if (await canLaunch(url)) {
                                      await launch(url);
                                    } else {
                                      throw 'Could not launch $url';
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.blue,
                                  ),
                                ),
                                IconButton(
                                    onPressed: () async {
                                      Future<bool> showDeleteConfirmDialog1() {
                                        return showDialog<bool>(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              title: Text("警告"),
                                              content: Text("確定要刪除此坑洞嗎?"),
                                              actions: <Widget>[
                                                TextButton(
                                                  child: Text("確認"),
                                                  onPressed: () async {
                                                    holename =
                                                        list[index]['date'];
                                                    await firestoreInstance
                                                        .collection(myController.text)
                                                        .doc(holename)
                                                        .update({"hole": "no"
                                                    }).then((_) {});
                                                    setState(() async {
                                                      list.clear();
                                                      var result =
                                                          await firestoreInstance.collection(myController.text)
                                                              .get();
                                                      result.docs.forEach((res) {
                                                        if (res.data()["hole"] == "yes") {
                                                          setState(() {
                                                            list.add(res.data());
                                                          });
                                                        }
                                                      });
                                                      Navigator.of(context).pop();
                                                      setState(() {
                                                        Fluttertoast.showToast(
                                                            msg: "刪除成功",
                                                            toastLength: Toast.LENGTH_SHORT,
                                                            gravity: ToastGravity.CENTER,
                                                            timeInSecForIosWeb: 3,
                                                            backgroundColor: Colors.black,
                                                            textColor: Colors.white,
                                                            fontSize: 16.0);
                                                      });
                                                    });
                                                  },
                                                ),
                                                TextButton(
                                                  child: Text("取消"),
                                                  onPressed: () {Navigator.of(context).pop();
                                                  },
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      }
                                      await showDeleteConfirmDialog1();
                                    },
                                    icon: Icon(
                                      Icons.delete,
                                      color: Colors.black,
                                    ))
                              ],
                            ),
                          ],
                        ));
                  },
                  separatorBuilder: (context, index) {
                    return Divider();
                  }),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.refresh_outlined),
          onPressed: () async {
            setState(() {
              list.clear();
            });
          },
        ));
  }
}
