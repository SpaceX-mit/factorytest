/*
 * Copyright (c) 2022 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
import promptAction from '@ohos.promptAction';
import router from '@ohos.router';
import xml from '@ohos.xml';
import fs from '@ohos.file.fs';
import util from '@ohos.util';
import data_preferences from '@ohos.data.preferences';
import { FactorytestData } from '../../utils/FactorytestData';
// import common from '@ohos.app.ability.common';

const TAG: string = 'ParseXML';
let path: string = globalThis.dir;
let path1: string = path + '/ArkUI';

let letColor: Object[] = [];
let ColorBackPath: string = path + '/ArkUIColorBack.txt';
let txtPath: string = path1 + '/ArkUIReport.txt';
let xmlPath: string = path1 + '/ArkUITest.xml';

class TestCase {
  title: string = '';
  title_ch: string = '';
  uri: string = '';
}

@Entry
@Component
struct IndexPage {
  @State ClearAll: boolean = false;
  private current: number = 0;
  @State count: number = 0;
  @State result: string = '';
  @State TEST: number = 0;
  @State name: string = 'ArkUI';
  @State Vue: boolean = false;
  @State Url: string = '';
  private TestCaseList: TestCase[] = [
    { title: 'ScrollingList', title_ch: '菜单滑动测试', uri: 'pages/ArkUI/ScrollListTest' },
    { title: 'PinchGesture', title_ch: '手动缩放测试', uri: 'pages/ArkUI/PinchGestureTest' },
    { title: 'RotationGesture', title_ch: '待补充', uri: 'pages/ArkUI/RotationGestureTest' },
    { title: 'SwipeGesture', title_ch: '待补充', uri: 'pages/ArkUI/SwipeGestureTest' },
    { title: 'LongPressGesture', title_ch: '待补充', uri: 'pages/ArkUI/LongPressGesture' },
    { title: 'TapGesture', title_ch: '待补充', uri: 'pages/ArkUI/TapGesture' },
    { title: 'PanGesture', title_ch: '待补充', uri: 'pages/ArkUI/PanGesture' },
    { title: 'CanvasFillStyle', title_ch: '填充测试', uri: 'pages/ArkUI/CanvasFillStyle' },
    { title: 'CanvasLineWidth', title_ch: '线框测试', uri: 'pages/ArkUI/CanvasLineWidth' },
    { title: 'CanvasStrokeStyle', title_ch: '待补充', uri: 'pages/ArkUI/CanvasStrokeStyle' },
    { title: 'CanvasLineCap', title_ch: '待补充', uri: 'pages/ArkUI/CanvasLineCap' },
    { title: 'CanvasLineJoin', title_ch: '待补充', uri: 'pages/ArkUI/CanvasLineJoin' },
    { title: 'CanvasFont', title_ch: '待补充', uri: 'pages/ArkUI/CanvasFont' },
    { title: 'CanvasTextAlign', title_ch: '待补充', uri: 'pages/ArkUI/CanvasTextAlign' },
    { title: 'CanvasTextBaseline', title_ch: '待补充', uri: 'pages/ArkUI/CanvasTextBaseline' },
    { title: 'CanvasGlobalAlpha', title_ch: '透明度测试', uri: 'pages/ArkUI/CanvasGlobalAlpha' },
    { title: 'CanvasLineDashOffset', title_ch: '待补充', uri: 'pages/ArkUI/CanvasLineDashOffset' },
    { title: 'CanvasGlobalCompositeOperation', title_ch: '待补充', uri: 'pages/ArkUI/CanvasGlobalCompositeOperation' },
    { title: 'CanvasShadowBlur', title_ch: '阴影测试', uri: 'pages/ArkUI/CanvasShadowBlur' },
    { title: 'CanvasShadowColor', title_ch: '待补充', uri: 'pages/ArkUI/CanvasShadowColor' },
    { title: 'CanvasShadowOffsetX', title_ch: '待补充', uri: 'pages/ArkUI/CanvasShadowOffsetX' },
    { title: 'CanvasShadowOffsetY', title_ch: '待补充', uri: 'pages/ArkUI/CanvasShadowOffsetY' },
    { title: 'DatePickerDialog', title_ch: '待补充', uri: 'pages/ArkUI/DatePickerDialog' },
    { title: 'Marquee', title_ch: '待补充', uri: 'pages/ArkUI/Marquee' },
    { title: 'PatternLock', title_ch: '待补充', uri: 'pages/ArkUI/PatternLock' },
    { title: 'TextPicker', title_ch: '待补充', uri: 'pages/ArkUI/TextPicker' },
    { title: 'TimePicker', title_ch: '待补充', uri: 'pages/ArkUI/TimePicker' },
    { title: 'TimePickerDialog', title_ch: '待补充', uri: 'pages/ArkUI/TimePickerDialog' },
    { title: 'Progress', title_ch: '进度条测试', uri: 'pages/ArkUI/Progress' },
    { title: 'Rating', title_ch: '待补充', uri: 'pages/ArkUI/Rating' },
    { title: 'Search', title_ch: '待补充', uri: 'pages/ArkUI/Search' },
    { title: 'SharedTransition', title_ch: '待补充', uri: 'pages/ArkUI/SharedTransition' },
    { title: 'Swiper', title_ch: '待补充', uri: 'pages/ArkUI/Swiper' },
    { title: 'Gauge', title_ch: '待补充', uri: 'pages/ArkUI/Gauge' },
    { title: 'ImageAnimator', title_ch: '待补充', uri: 'pages/ArkUI/ImageAnimator' },
    { title: 'TextPickerDialog', title_ch: '待补充', uri: 'pages/ArkUI/TextPickerDialog' },
    { title: 'Refresh', title_ch: '待补充', uri: 'pages/ArkUI/Refresh' },
    { title: 'onAccessibilityHover', title_ch: '待补充', uri: 'pages/ArkUI/AccessBilityHover' },
  ]
  @State ColorObject: Object[] = letColor;
  @State ColorTrue: number[] = [];
  @State ColorTrue2: number[] = [];

  async aboutToAppear() {
    FactorytestData.loadConfigs();
    console.error('bububu get =' + FactorytestData.getConfig().ArkUI_menu);
  }

  async onPageShow() {
    let Test : data_preferences.Preferences | number = 0;
    let context: Context | null;
    context = globalThis.getContext();
    let preferences: ESObject;

    let promise = data_preferences.getPreferences(context, 'mystore');
    await promise.then((object) => {
      preferences = object;
    });

    promise = preferences.get('ArkUI', 0);
    await promise.then((data) => {
      Test = data;
      console.info("Succeeded in getting value of 'ArkUI'. Data: " + data);
    });

    if (Test != 1) {
      let fd = fs.openSync(ColorBackPath, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
      for (let i = 0; i < this.TestCaseList.length; i++) {
        let log = (this.TestCaseList[i].title + ';' + 'none ' + ';').toString();
        fs.writeSync(fd.fd, log);
      }
      fs.closeSync(fd);
    }
    promise = preferences.put('ArkUI', 1);
    promise.then(() => {
      console.info("Succeeded in putting value of 'ArkUI'.");
    });
    promise = preferences.flush();
    promise.then(() => {
      console.info("Succeeded in flushing.");
    });
    this.TEST = Test;

    let opt = fs.openSync(ColorBackPath, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
    let buff = new ArrayBuffer(40960);
    let RD = fs.readSync(opt.fd, buff);
    let uint8Array = new Uint8Array(buff, 0, RD);
    let ColorBack: string = String.fromCharCode(...uint8Array);
    let TestList: string[] = ColorBack.split(';');
    for (let i = 0; i < Math.floor(TestList.length / 2); i++) {
      letColor[i] = TestList[i * 2+1];
    }
    fs.closeSync(opt);

    if (this.count === 1) {
      let myRouter = router.getParams() as Record<string, string | number>
      this.result = myRouter.result as string
      let titles: string = myRouter.title as string;
      let name1: string = '刚刚点进了哪个用例：' + titles;
      let results = this.result;
      let WriteTitle = (titles).toString();
      let number = WriteTitle.length + 7;
      let Index = ColorBack.indexOf(WriteTitle);

      if (this.result === 'true ') {
        this.ColorObject[this.current] = 'true ';
        let Log = (titles + ';' + 'true ' + ';');
        let key = ColorBack.substring(Index, Index + number);
        let FD = fs.openSync(ColorBackPath, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
        ColorBack = ColorBack.replace(key, Log);
        let buffer = new ArrayBuffer(4096);
        let rd = fs.readSync(FD.fd, buffer);
        let Report = ColorBack.substring(0, rd);
        fs.closeSync(FD);
        let Fd = fs.openSync(ColorBackPath, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
        fs.writeSync(Fd.fd, Report);
        filewrite(name1, results, titles);
      }
      else if (this.result === 'false') {
        this.ColorObject[this.current] = 'false';
        let Log = (titles + ';' + 'false' + ';');
        let key = ColorBack.substring(Index, Index + number);
        let FD = fs.openSync(ColorBackPath, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
        ColorBack = ColorBack.replace(key, Log);
        let buffer = new ArrayBuffer(4096);
        let rd = fs.readSync(FD.fd, buffer);
        let Report = ColorBack.substring(0, rd);
        fs.closeSync(FD);
        let Fd = fs.openSync(ColorBackPath, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
        fs.writeSync(Fd.fd, Report);
        filewrite(name1, results, titles);
      }
      else {
        this.ColorObject[this.current] = this.ColorObject[this.current];
      }
    }

    let temp = 0;
    for (let i = 0; i < this.TestCaseList.length; i++) {
      if (this.ColorObject[i] === 'true ') {
        this.ColorTrue[i] = 0x263526
        this.ColorTrue2[i] = 0x0CB60C
        temp ++;

      }
      else if (this.ColorObject[i] === 'false') {
        this.ColorTrue[i] = 0x380303
        this.ColorTrue2[i] = 0xd60a0a
      }
      else {
        this.ColorTrue[i] = 0x000000
        this.ColorTrue2[i] = 0x000000
      }
    }

    if(temp === FactorytestData.getConfig().ArkUI_menu.length/*this.TestCaseList.length*/) {
      console.error('xxxxxxxxxxxxxxxx ohohohohohohohohohohoh')
      this.Vue = true;
    }

  }

  build() {
    Column() {
      Row() {
        Button() {
          Image($r('app.media.ic_public_back'))
            .width('20vp')
            .height('18vp')
        }
        .backgroundColor(Color.Black)
        .size({ width: '40vp', height: '30vp' })
        .onClick(() => {
          router.back();
        })

        Row() {
          Text('UI测试')
            .fontColor(Color.White)
            .fontSize('22fp')
        }
        .justifyContent(FlexAlign.SpaceAround)
        .backgroundColor(Color.Black)

        Row() {
          Button() {
            Image($r('app.media.ic_public_delete'))
              .width('30vp')
              .height('30vp')
          }.backgroundColor(Color.Black)
          .onClick(() => {
            AlertDialog.show(
              {
                message: "是否删除所有记录",
                primaryButton: {
                  value: 'Yes',
                  action: () => {
                    this.ClearAll = true;
                    this.ColorObject.forEach((value, index) => {
                      this.ColorObject[index] = 'none ';
                    });
                    this.ClearText();
                    router.replaceUrl({
                      url: 'pages/ArkUI/ArkUI_index',
                    })
                    promptAction.showToast({
                      message: '结果已删除', duration: 1000
                    });
                  }
                },
                secondaryButton: {
                  value: 'No',
                  action: () => {

                  }
                },
                cancel: () => {

                }
              }
            )
          })

          Button() {
            Image($r('app.media.ic_public_save'))
              .width('30vp')
              .height('30vp')
              .margin({ left: 30 })
          }.backgroundColor(Color.Black)
          .onClick(() => {
            this.ReadTextParseXml();
            AlertDialog.show({
              message: "报告已生成，如需查看通过命令行输入'hdc_std file recv /data/app/el2/100/base/com.example.actsvalidator/haps/entry/files/ArkUI/ArkUITest.xml -本地路径'",
              confirm: {
                value: 'OK',
                action: () => {
                  promptAction.showToast({
                    message: '报告已生成', duration: 1000
                  })
                }
              },
              cancel: () => {
                promptAction.showToast({
                  message: '报告已生成', duration: 1000
                });
              }
            })
          })
        }
      }
      .width('100%')
      .justifyContent(FlexAlign.SpaceAround)
      .margin({ top: '15vp' })
      .height('6%')
      .backgroundColor(Color.Black)

      Blank().height(40)
      Line()
        .width('100%')
        .height(3)
        .backgroundColor('#FFFFFF')

      List({}) {
        ForEach(this.TestCaseList, (item: TestCase, index) => {
          if(FactorytestData.getConfig().ArkUI_menu.includes(index)) {
            ListItem() {
              Row() {
                Text(item.title_ch)
                  .fontSize(20)
                  .fontColor(Color.White)
              }
              .width('100%')
              .height(50)
              .alignItems(VerticalAlign.Center)
              .linearGradient(this.count === 0 && this.TEST === 0 ? {
                angle: 90,
                colors: [[0x000000, 0.0], [0x000000, 1.0]]
              } : { angle: 90, colors: [[this.ColorTrue[index], 0.0], [this.ColorTrue2[index], 0.618]] })
              .onClick(() => {
                this.count = 1;
                this.ClearAll = false;
                this.current = index;
                router.push({
                  url: item.uri,
                })
              })
            }
          }
        }, (item: TestCase) => item.title)
      }
      .width('100%')
      .height('70%')
      .divider({ strokeWidth: 1, color: Color.Grey })

      Row() {
        Blank()
        Button() {
          Image($r('app.media.ic_public_pass')).width('20vp').height('20vp')
        }
        .width('40%')
        .height('60vp')
        .backgroundColor(Color.Grey)
        .enabled(this.Vue)
        .opacity(this.Vue ? 1 : 0.4)
        .onClick(() => {
          router.back({
            url: 'pages/index',
            params: { result: 'true ', title: this.name,
            }
          })
          promptAction.showToast({
            message: '通过', duration: 1000
          });
        })

        Blank().width(40)
        Button() {
          Image($r('app.media.ic_public_fail')).width('20vp').height('20vp')
        }.width('40%').height('60vp').backgroundColor(Color.Grey)
        .onClick(() => {
          router.back({
            url: 'pages/index',
            params: { result: 'false', title: this.name,
            }
          })
          console.log('wwwwwwwwww' + this.Url)
          promptAction.showToast({
            message: '失败', duration: 1000
          });
        })

        Blank()
      }.width('100%').height('14%').backgroundColor(Color.Black).justifyContent(FlexAlign.Center)
    }
    .width('100%')
    .height('100%')
    .backgroundColor(Color.Black)
  }

  ClearText() {
    fs.rmdirSync(path1);
    fs.mkdirSync(path1);
    let fd = fs.openSync(ColorBackPath, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
    for (let i = 0; i < this.TestCaseList.length; i++) {
      let log = (this.TestCaseList[i].title + ';' + 'none ' + ';').toString();
      fs.writeSync(fd.fd, log);
    }
  }

  ReadTextParseXml() {
    let ReportPath = path1 + '/ArkUIReport.txt';
    let dir = fs.listFileSync(path1);
    console.info("ssssss" + dir);
    while (dir) {
      let OP = fs.openSync(ReportPath, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
      let buf = new ArrayBuffer(40960);
      let RD = fs.readSync(OP.fd, buf);
      console.info("ddddd" + RD);
      let report: string = String.fromCharCode(...new Uint8Array(buf));

      let str1: string[] = report.split(";");
      let title: string[] = [];
      let result: string[] = [];
      for (let i = 0; i < Math.floor(str1.length / 2); i++) {
        title[i] = str1[i*2];
        result[i] = str1[i * 2+1];
      }
      let FailIndex: number = report.indexOf('false');
      let FailNum = 0;
      while (FailIndex != -1) {
        console.log(FailIndex.toString());
        FailNum++;
        FailIndex = report.indexOf('false', FailIndex + 1);
      }
      let failNum = (FailNum).toString();
      let PassIndex: number = report.indexOf('true ');
      let PassNum = 0;
      while (PassIndex != -1) {
        console.log(PassIndex.toString());
        PassNum++;
        PassIndex = report.indexOf('true ', PassIndex + 1);
      }
      let TestNum = FailNum + PassNum;
      let testNum = (TestNum).toString();
      let arrayBuffer = new ArrayBuffer(40960);
      let bufView = new DataView(arrayBuffer);
      let serializer = new xml.XmlSerializer(bufView);
      serializer.setDeclaration();
      serializer.startElement("testsuite");
      serializer.setAttributes("name", "ActsArkUITest");
      //serializer.setAttributes("time", "*");
      //serializer.setAttributes("errors", "0");
      serializer.setAttributes("disabled", "0");
      serializer.setAttributes("failures", failNum);
      serializer.setAttributes("ignored", "0");
      serializer.setAttributes("tests", testNum);
      serializer.setAttributes("message", "*");
      serializer.setAttributes("modulename", "ActsArkUITest");
      for (let i = 0; i < title.length; i++) {
        serializer.startElement("testcase");
        serializer.setAttributes("name", String(title[i]));
        //serializer.setAttributes("time", "*");
        //serializer.setAttributes("classname", "ActsArkUITest");
        serializer.setAttributes("result", String(result[i]));
        //serializer.setAttributes("level", "*");
        //serializer.setAttributes("message", "*");
        serializer.endElement();
      }
      serializer.endElement();

      let that = new util.TextDecoder('utf-8');
      let array = new Uint8Array(arrayBuffer);
      let serializerStr = that.decode(array);
      console.info(xmlPath);
      let xmlfd: fs.File | null = null;
      try {
        console.error(TAG, "write xmlPath =" + xmlPath);
        xmlfd = fs.openSync(xmlPath, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
        fs.writeSync(xmlfd.fd, serializerStr);
      } catch (err) {
        console.error(TAG, "read xmlPath =" + xmlPath + "error:" + err);
      } finally {
        if (xmlfd !== null) {
          fs.closeSync(xmlfd)
        }
      }
      return;
    }
  }
}

function filewrite(name1: string, results: string, titles: string) {
  let fd = fs.openSync(txtPath, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
  let buf = new ArrayBuffer(4096);
  let RD = fs.readSync(fd.fd, buf);
  let uint8Array = new Uint8Array(buf, 0, RD);
  console.info("RRRRRRRRRRd" + RD);
  let report: ESObject = String.fromCharCode(...uint8Array);
  let WriteTitle = (titles).toString();
  let WriteResult = (results).toString();
  let number = WriteTitle.length + WriteResult.length + 2;
  let Index: number = report.indexOf(WriteTitle);
  let Log = (titles + ";" + results + ";").toString();
  if (Index == -1) {
    fs.writeSync(fd.fd, Log);
  }
  else if (Index != -1) {
    let key: string = report.substring(Index, Index + number);
    let FD = fs.openSync(txtPath, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
    report = report.replace(key, Log);
    let buffer = new ArrayBuffer(4096);
    let rd = fs.readSync(FD.fd, buffer);
    let Report: string = report.substring(0, rd);
    fs.closeSync(FD);
    let Fd = fs.openSync(txtPath, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
    fs.writeSync(Fd.fd, Report);
  }
}