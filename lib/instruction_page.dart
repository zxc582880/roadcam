import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Instructionspage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('使用說明')),
      // Wait until the controller is initialized before displaying the
      // camera preview. Use a FutureBuilder to display a loading spinner
      // until the controller has finished initializing.
      body: Column(children: [
        Container(
          alignment: Alignment.center,
          margin: EdgeInsets.only(left: 15, top: 5, right: 15, bottom: 5),
          child: Text(
            '相機',
            style: TextStyle(fontSize: 35),
          ),
        ),
        Container(
          alignment: Alignment.center,
          margin: EdgeInsets.only(left: 15, top: 5, right: 15, bottom: 20),
          child: Text(
            '拍攝鍵分兩個功能:\n短按:開啟連拍，再按一次關閉連拍\n長按:開啟檔案並選擇圖片上傳',
            style: TextStyle(fontSize: 20),
          ),
        ),
        Container(
          alignment: Alignment.center,
          margin: EdgeInsets.only(left: 15, top: 10, right: 15, bottom: 5),
          child: Text(
            '坑洞說明',
            style: TextStyle(fontSize: 35),
          ),
        ),
        Container(
          alignment: Alignment.center,
          margin: EdgeInsets.only(left: 50, top: 5, right: 50, bottom: 20),
          child: Text(
              '將欲查詢之日期或地區輸入後，按下查詢即可查詢，按下每項中"查看此坑洞"會導向外部瀏覽器開啟該坑洞圖片。按右下角按鈕可清除搜尋結果',
              style: TextStyle(fontSize: 20)),
        ),
        Image.network("https://i.imgur.com/H4UyhnC.png"),
      ]),
    );
  }
}
