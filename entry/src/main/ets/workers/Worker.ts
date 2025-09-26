//Worker.ts
import { worker, MessageEvents, ErrorEvent, util, xml } from '@kit.ArkTS';
import fs from '@ohos.file.fs';
import { hilog } from '@kit.PerformanceAnalysisKit';
import DateTimeUtil from '../pages/model/DateTimeUtil';
//import FlushData from '../pages/model/FlushData';

const TAG = 'ParseXML';

let path = '';
let path1 = '';
let path2 = '';
let path3 = '';
let path4 = '';
let path5 = '';
let path6 = '';
let path8 = '';
let path9 = '';
let path10 = '';
let path1_1 = '';
let path1_2 = '';
let path1_3 = '';
let path1_4 = '';
let path1_5 = '';
let path1_6 = '';
let picturePath = '';
let ExperienceDataPath = '';
let VarColor: Object[] = [];
let ColorBackPath = '';
let ArkUIColorBackPath = '';
let AudioColorBackPath = '';
let CameraColorBackPath = '';
let PlayerColorBackPath = '';
let SensorColorBackPath = ''; // 传感器
let ScreenColorBackPath = ''; // 屏幕
let MultimodalInputColorBackPath = ''; // 多模输入
let PowerColorBackPath = ''; // 电源管理
let NotificationColorBackPath = ''; // 通知管理
let WifiColorBackPath = path + ''; // wifi管理
let BluetoothColorBackPath = ''; // bluetooth管理
let PCSColorBackPath = ''; // PCS自动化
let InterfaceColorBackPath = ''; // Interface测试
let AgingColorBackPath = path + ''; // 老化测试
let PlayerNetWorkColorBackPath = ''; // 播放网络视频
let PlayerAudioColorBackPath = '';
let PlayerVideoColorBackPath = '';
let ExperienceColorBackPath = '';

let TimePath = '';
let xmlPath ='';

let path11 = '';
let path22 = '';
let path33 = '';
let path44 = '';
let PlayerAudioTxtPath = '';
let PlayerVideoTxtPath = '';
let PlayerNetWorkTxtPath = '';
let path55 = '';
let path66 = '';
let path88 = ''; // 屏幕
let path99 = ''; // 多模输入
let pathPower = '';
let pathNotification = '';
let pathWifi = '';
let pathBluetooth = '';
let pathPCS = '';
let pathInterface = '';
let pathAging = '';
let msgValue = '';
let msgType = '';
///////////////////////////////////////////////////////////////////////

// 创建worker线程中与宿主线程通信的对象
const workerPort = worker.workerPort

// worker线程接收宿主线程信息
workerPort.onmessage = (e: MessageEvents): void => {
  // data：宿主线程发送的信息
  msgType = e.data.msgType;
  msgValue = e.data.value;
  console.error('testTag workerPort.onmessage msgType: ' + msgType + ' value: ' + msgValue);
 // hilog.info(0x0000, 'testTag', 'workerPort.onmessage %{public}d', data);
  // 往收到的buffer里写入数据
  // worker线程向宿主线程发送信息
  if (msgType == "initFilePath") {
    initFilePath(msgValue);
  } else if (msgType == "saveXML") {
    SaveXmlFile(msgValue);
    workerPort.postMessage('saveDone');
  }else if (e.data == "clearText"){

  }


}

// worker线程发生error的回调
workerPort.onerror = (err: ErrorEvent) => {
  console.log("worker.ets onerror" + err.message);
}

function initFilePath(filePath: string) {
  path = filePath;
  path1 = path + '/ArkUI';
  path2 = path + '/Audio';
  path3 = path + '/Camera';
  path4 = path + '/Player';
  path5 = path + '/Experience';
  path6 = path + '/Sensor';
  path8 = path + '/Screen';
  path9 = path + '/MultimodalInput';
  path10 = path + '/Power';
  path1_1 = path + '/Notification';
  path1_2 = path + '/Wifi';
  path1_3 = path + '/Bluetooth';
  path1_4 = path + '/PCS';
  path1_5 = path + '/Interface';
  path1_6 = path + '/Aging';
  picturePath = path + '/screenshot';
  ExperienceDataPath = path + '/ExperienceData';
 // VarColor: Object[] = [];
  ColorBackPath = path + '/ColorBack.txt';
  ArkUIColorBackPath = path + '/ArkUIColorBack.txt';
  AudioColorBackPath = path + '/AudioColorBack.txt';
  CameraColorBackPath = path + '/CameraColorBack.txt';
  PlayerColorBackPath = path + '/PlayerColorBack.txt';
  SensorColorBackPath = path + '/SensorColorBack.txt'; // 传感器
  ScreenColorBackPath = path + '/ScreenColorBack.txt'; // 屏幕
  MultimodalInputColorBackPath = path + '/MultimodalInputColorBack.txt'; // 多模输入
  PowerColorBackPath = path + '/PowerColorBack.txt'; // 电源管理
  NotificationColorBackPath = path + '/NotificationColorBack.txt'; // 通知管理
  WifiColorBackPath = path + '/WifiColorBack.txt'; // wifi管理
  BluetoothColorBackPath = path + '/BluetoothColorBack.txt'; // bluetooth管理
  PCSColorBackPath = path + '/PCSColorBack.txt'; // PCS自动化
  InterfaceColorBackPath = path + '/InterfaceColorBack.txt'; // Interface测试
  AgingColorBackPath = path + '/AgingColorBack.txt'; // 老化测试
  PlayerNetWorkColorBackPath = path4 + '/PlayerNetWorkColorBack.txt'; // 播放网络视频
  PlayerAudioColorBackPath = path4 + '/PlayerAudioColorBack.txt';
  PlayerVideoColorBackPath = path4 + '/PlayerVideoColorBack.txt';
  ExperienceColorBackPath = path + '/ExperienceColorBack.txt';

  fs.openSync(ColorBackPath, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
  fs.openSync(ArkUIColorBackPath, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
  fs.openSync(AudioColorBackPath, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
  fs.openSync(CameraColorBackPath, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
  fs.openSync(PlayerColorBackPath, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
  fs.openSync(ExperienceColorBackPath, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
  fs.openSync(SensorColorBackPath, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
  fs.openSync(ScreenColorBackPath, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
  fs.openSync(MultimodalInputColorBackPath, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
  fs.openSync(PowerColorBackPath, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
  fs.openSync(NotificationColorBackPath, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
  fs.openSync(WifiColorBackPath, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
  fs.openSync(BluetoothColorBackPath, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
  fs.openSync(PCSColorBackPath, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
  fs.openSync(InterfaceColorBackPath, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
  fs.openSync(AgingColorBackPath, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);

  TimePath = path + '/Time.txt';
  fs.openSync(TimePath, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
  xmlPath = path + '/Test.xml';
  fs.openSync(xmlPath, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);

  path11 = path1 + '/ArkUIReport.txt';
  path22 = path2 + '/AudioReport.txt';
  path33 = path3 + '/CameraReport.txt';
  path44 = path4 + '/PlayerReport.txt';
  PlayerAudioTxtPath = path4 + '/PlayerAudioReport.txt';
  PlayerVideoTxtPath = path4 + '/PlayerVideoReport.txt';
  PlayerNetWorkTxtPath = path4 + '/PlayerNetWorkReport.txt';
  path55 = path5 + '/ExperienceReport.txt';
  path66 = path6 + '/SensorReport.txt';
  path88 = path8 + '/ScreenReport.txt'; // 屏幕
  path99 = path9 + '/MultimodalInputReport.txt'; // 多模输入
  pathPower = path10 + '/PowerReport.txt';
  pathNotification = path1_1 + '/NotificationReport.txt';
  pathWifi = path1_2 + '/WifiReport.txt';
  pathBluetooth = path1_3 + '/BluetoothReport.txt';
  pathPCS = path1_4 + '/PCSReport.txt';
  pathInterface = path1_5 + '/InterfaceReport.txt';
  pathAging = path1_6 + '/AgingReport.txt';

}


function ClearText() {

  fs.unlinkSync(TimePath);
  fs.unlinkSync(xmlPath);
  fs.unlinkSync(path11);
  fs.unlinkSync(path22);
  fs.unlinkSync(path33);
  fs.unlinkSync(path44);
  fs.unlinkSync(PlayerAudioTxtPath);
  fs.unlinkSync(PlayerVideoTxtPath);
  fs.unlinkSync(PlayerNetWorkTxtPath);
  fs.unlinkSync(path55);
  fs.unlinkSync(path66);
  fs.unlinkSync(path88);
  fs.unlinkSync(path99);
  fs.unlinkSync(pathPower);
  fs.unlinkSync(pathNotification);
  fs.unlinkSync(pathWifi);
  fs.unlinkSync(pathBluetooth);
  fs.unlinkSync(pathPCS);
  fs.unlinkSync(pathInterface);
  fs.unlinkSync(pathAging);
  fs.unlinkSync(ColorBackPath);
  fs.unlinkSync(ArkUIColorBackPath);
  fs.unlinkSync(AudioColorBackPath);
  fs.unlinkSync(CameraColorBackPath);
  fs.unlinkSync(PlayerColorBackPath);
  fs.unlinkSync(PlayerAudioColorBackPath);
  fs.unlinkSync(PlayerVideoColorBackPath);
  fs.unlinkSync(PlayerNetWorkColorBackPath);
  fs.unlinkSync(ExperienceColorBackPath);
  fs.unlinkSync(SensorColorBackPath);
  fs.unlinkSync(ScreenColorBackPath);
  fs.unlinkSync(MultimodalInputColorBackPath);
  fs.unlinkSync(PowerColorBackPath);
  fs.unlinkSync(NotificationColorBackPath);
  fs.unlinkSync(WifiColorBackPath);
  fs.unlinkSync(BluetoothColorBackPath);
  fs.unlinkSync(PCSColorBackPath);
  fs.unlinkSync(InterfaceColorBackPath);
  fs.unlinkSync(AgingColorBackPath);
  fs.rmdirSync(picturePath);
  fs.mkdirSync(picturePath);
  fs.rmdirSync(ExperienceDataPath);
  fs.mkdirSync(ExperienceDataPath);
  fs.openSync(TimePath, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
  fs.openSync(xmlPath, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
  fs.openSync(path11, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
  fs.openSync(path22, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
  fs.openSync(path33, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
  fs.openSync(path44, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
  fs.openSync(PlayerAudioTxtPath, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
  fs.openSync(PlayerVideoTxtPath, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
  fs.openSync(PlayerNetWorkTxtPath, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
  fs.openSync(path55, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
  fs.openSync(path66, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
  fs.openSync(path88, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
  fs.openSync(path99, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
  fs.openSync(pathPower, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
  fs.openSync(pathNotification, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
  fs.openSync(pathWifi, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
  fs.openSync(pathBluetooth, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
  fs.openSync(pathPCS, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
  fs.openSync(pathInterface, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
  fs.openSync(pathAging, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
  fs.openSync(ColorBackPath, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
  fs.openSync(ArkUIColorBackPath, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
  fs.openSync(AudioColorBackPath, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
  fs.openSync(CameraColorBackPath, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
  fs.openSync(PlayerColorBackPath, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
  fs.openSync(PlayerAudioColorBackPath, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
  fs.openSync(PlayerVideoColorBackPath, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
  fs.openSync(PlayerNetWorkColorBackPath, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
  fs.openSync(ExperienceColorBackPath, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
  fs.openSync(SensorColorBackPath, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
  fs.openSync(ScreenColorBackPath, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
  fs.openSync(MultimodalInputColorBackPath, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
  fs.openSync(PowerColorBackPath, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
  fs.openSync(NotificationColorBackPath, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
  fs.openSync(WifiColorBackPath, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
  fs.openSync(BluetoothColorBackPath, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
  fs.openSync(PCSColorBackPath, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
  fs.openSync(InterfaceColorBackPath, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
  fs.openSync(AgingColorBackPath, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);

  // FlushData.ResetArkUI();
  // FlushData.ResetAudio();
  // FlushData.ResetCamera();
  // FlushData.ResetPlayer();
  // FlushData.ResetExperience();
  // FlushData.ResetPlayerAudio();
  // FlushData.ResetPlayerVideo();
  // FlushData.ResetPlayNetworkVideo();
  // FlushData.ResetSensor();
  // FlushData.ResetMultimodalInput();
  // FlushData.ResetPower();
  // FlushData.ResetNotification();
  // FlushData.ResetWifi();
  // FlushData.ResetBluetooth();
  // FlushData.ResetPCS();
  // FlushData.ResetInterface();
  // FlushData.ResetAging();
}


function SaveXmlFile(filePath :string) {

  let dateTimeUtil = new DateTimeUtil();
  let endtime = `${dateTimeUtil.getFullYear()}-${dateTimeUtil.getMonth()}-${dateTimeUtil.getDay()} ${dateTimeUtil.getHour()}:${dateTimeUtil.getMinute()}:${dateTimeUtil.getSecond()}`;
  let fd = fs.openSync(TimePath, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
  let buf = new ArrayBuffer(40960);
  fs.readSync(fd.fd, buf)
  let StartTime = String.fromCharCode(...new Uint8Array(buf));
  let Index = StartTime.indexOf(';');
  let starttime = StartTime.substring(0, Index);
  if (starttime === '') {
    starttime = '*'
  }
  let ArkUIReport: string;
  let AudioReport: string;
  let CameraReport: string;
  let PlayerReport: string;
  let ExperienceReport: string;
  let SensorReport: string; // 传感器
  let ScreenReport: string; // 屏幕
  let MultimodalInputReport: string; // 多模输入
  let PowerReport: string; // 电源管理
  let NotificationReport: string; // 通知
  let WifiReport: string; // wifi管理
  let BluetoothReport: string; // bluetooth管理
  let PCSReport: string; // PCS
  let InterfaceReport: string; // Interface
  let AgingReport: string; // Aging
  /*
   * ArkUI
   */
  let OP1 = fs.openSync(path11, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
  let buf1 = new ArrayBuffer(40960);
  fs.readSync(OP1.fd, buf1);
  ArkUIReport = String.fromCharCode(...new Uint8Array(buf1));
  let str1 = ArkUIReport.split(";");
  let title1: string[] = [];
  let result1: string[] = [];
  for (let i = 0; i < Math.floor(str1.length / 2); i++) {
    title1[i] = str1[i * 2];
    result1[i] = str1[i * 2 + 1];
  }
  /*
   * Audio
   */
  let OP2 = fs.openSync(path22, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
  let buf2 = new ArrayBuffer(40960);
  fs.readSync(OP2.fd, buf2);
  AudioReport = String.fromCharCode(...new Uint8Array(buf2));
  let str2 = AudioReport.split(";");
  let title2: string[] = [];
  let result2: string[] = [];
  for (let i = 0; i < Math.floor(str2.length / 2); i++) {
    title2[i] = str2[i * 2];
    result2[i] = str2[i * 2 + 1];
  }
  /*
   * Camera
   */
  let OP3 = fs.openSync(path33, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
  let buf3 = new ArrayBuffer(40960);
  fs.readSync(OP3.fd, buf3);
  CameraReport = String.fromCharCode(...new Uint8Array(buf3));
  let str3 = CameraReport.split(";");
  let title3: string[] = [];
  let result3: string[] = [];
  for (let i = 0; i < Math.floor(str3.length / 2); i++) {
    title3[i] = str3[i * 2];
    result3[i] = str3[i * 2 + 1];
  }
  /*
* Player
*/
  let OP4 = fs.openSync(path44, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
  let buf4 = new ArrayBuffer(40960);
  fs.readSync(OP4.fd, buf4);
  PlayerReport = String.fromCharCode(...new Uint8Array(buf4));
  let str4 = PlayerReport.split(";");
  let title4: string[] = [];
  let result4: string[] = [];
  for (let i = 0; i < Math.floor(str4.length / 2); i++) {
    title4[i] = str4[i * 2];
    result4[i] = str4[i * 2 + 1];
  }
  /*
* Experience
*/
  let OP5 = fs.openSync(path55, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
  let buf5 = new ArrayBuffer(40960);
  fs.readSync(OP5.fd, buf5);
  ExperienceReport = String.fromCharCode(...new Uint8Array(buf5));
  let str5 = ExperienceReport.split(";");
  let title5: string[] = [];
  let result5: string[] = [];
  for (let i = 0; i < Math.floor(str5.length / 2); i++) {
    title5[i] = str5[i * 2];
    result5[i] = str5[i * 2 + 1];
  }

  /**
   * Sensor 传感器
   */
  let OP6 = fs.openSync(path66, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
  let buf6 = new ArrayBuffer(40960);
  fs.readSync(OP6.fd, buf6);
  SensorReport = String.fromCharCode(...new Uint8Array(buf6));
  let str6 = SensorReport.split(";");
  let title6 : string[] = [];
  let result6 : string[] = [];
  for (let i = 0; i < Math.floor(str6.length / 2); i++) {
    title6[i] = str6[i * 2];
    result6[i] = str6[i * 2 + 1];
  }

  /**
   * Screen 屏幕
   */
  let OP8 = fs.openSync(path88, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
  let buf8 = new ArrayBuffer(40960);
  fs.readSync(OP8.fd, buf8);
  ScreenReport = String.fromCharCode(...new Uint8Array(buf8));
  let str8 = ScreenReport.split(";");
  let title8: string[] = [];
  let result8: string[] = [];
  for (let i = 0; i < Math.floor(str8.length / 2); i++) {
    title8[i] = str8[i * 2];
    result8[i] = str8[i * 2 + 1];
  }

  /**
   * MultimodalInput 多模输入
   */
  let OP9 = fs.openSync(path99, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
  let buf9 = new ArrayBuffer(40960);
  fs.readSync(OP9.fd, buf9);
  MultimodalInputReport = String.fromCharCode(...new Uint8Array(buf9));
  let str9 = MultimodalInputReport.split(";");
  let title9: string[] = [];
  let result9: string[] = [];
  for (let i = 0; i < Math.floor(str9.length / 2); i++) {
    title9[i] = str9[i * 2];
    result9[i] = str9[i * 2 + 1];
  }

  /**
   * Power 电源管理
   */
  let OP10 = fs.openSync(pathPower, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
  let buf10 = new ArrayBuffer(40960);
  fs.readSync(OP10.fd, buf10);
  PowerReport = String.fromCharCode(...new Uint8Array(buf10));
  let str10 = PowerReport.split(";");
  let title10: string[] = [];
  let result10: string[] = [];
  for (let i = 0; i < Math.floor(str10.length / 2); i++) {
    title10[i] = str10[i * 2];
    result10[i] = str10[i * 2 + 1];
  }

  /**
   * Notification 通知
   */
  let OP11 = fs.openSync(pathNotification, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
  let buf11 = new ArrayBuffer(40960);
  fs.readSync(OP11.fd, buf11);
  NotificationReport = String.fromCharCode(...new Uint8Array(buf11));
  let str11 = NotificationReport.split(";");
  let title11: string[] = [];
  let result11: string[] = [];
  for (let i = 0; i < Math.floor(str11.length / 2); i++) {
    title11[i] = str11[i * 2];
    result11[i] = str11[i * 2 + 1];
  }

  /**
   * wifi 通知
   */
  let OP12 = fs.openSync(pathWifi, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
  let buf12 = new ArrayBuffer(40960);
  fs.readSync(OP12.fd, buf12);
  WifiReport = String.fromCharCode(...new Uint8Array(buf12));
  let str12 = WifiReport.split(";");
  let title12: string[] = [];
  let result12: string[] = [];
  for (let i = 0; i < Math.floor(str12.length / 2); i++) {
    title12[i] = str12[i * 2];
    result12[i] = str12[i * 2 + 1];
  }

  /**
   * Bluetooth 通知
   */
  let OP13 = fs.openSync(pathBluetooth, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
  let buf13 = new ArrayBuffer(40960);
  fs.readSync(OP13.fd, buf13);
  BluetoothReport = String.fromCharCode(...new Uint8Array(buf13));
  let str13 = BluetoothReport.split(";");
  let title13: string[] = [];
  let result13: string[] = [];
  for (let i = 0; i < Math.floor(str13.length / 2); i++) {
    title13[i] = str13[i * 2];
    result13[i] = str13[i * 2 + 1];
  }

  /**
   * PCS
   */
  let OP14 = fs.openSync(pathPCS, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
  let buf14 = new ArrayBuffer(40960);
  fs.readSync(OP14.fd, buf14);
  PCSReport = String.fromCharCode(...new Uint8Array(buf14));
  let str14 = PCSReport.split(";");
  let title14: string[] = [];
  let result14: string[] = [];
  for (let i = 0; i < Math.floor(str14.length / 2); i++) {
    title14[i] = str14[i * 2];
    result14[i] = str14[i * 2 + 1];
  }

  /**
   * Interface
   */
  let OP15 = fs.openSync(pathInterface, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
  let buf15 = new ArrayBuffer(40960);
  fs.readSync(OP15.fd, buf15);
  InterfaceReport = String.fromCharCode(...new Uint8Array(buf15));
  let str15 = InterfaceReport.split(";");
  let title15: string[] = [];
  let result15: string[] = [];
  for (let i = 0; i < Math.floor(str15.length / 2); i++) {
    title15[i] = str15[i * 2];
    result15[i] = str15[i * 2 + 1];
  }

  /**
   * Aging
   */
  let OP16 = fs.openSync(pathAging, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
  let buf16 = new ArrayBuffer(40960);
  fs.readSync(OP14.fd, buf14);
  AgingReport = String.fromCharCode(...new Uint8Array(buf14));
  let str16 = AgingReport.split(";");
  let title16: string[] = [];
  let result16: string[] = [];
  for (let i = 0; i < Math.floor(str14.length / 2); i++) {
    title16[i] = str16[i * 2];
    result16[i] = str16[i * 2 + 1];
  }

  let report = ArkUIReport + AudioReport + CameraReport + PlayerReport +
    ExperienceReport + SensorReport + ScreenReport + MultimodalInputReport
    + PowerReport + NotificationReport + BluetoothReport + WifiReport + PCSReport
    + InterfaceReport + AgingReport;
  let FailIndex = report.indexOf('false');
  let FailNum = 0;
  while (FailIndex != -1) {
    console.log(FailIndex.toString());
    FailNum++;
    FailIndex = report.indexOf('false', FailIndex + 1);
  }
  let failNum = (FailNum).toString();
  let PassIndex = report.indexOf('true ');
  let PassNum = 0;
  while (PassIndex != -1) {
    console.log(PassIndex.toString());
    PassNum++;
    PassIndex = report.indexOf('true ', PassIndex + 1);
  }
  let TestNum = FailNum + PassNum;
  let testNum = (TestNum).toString();
  /*
   * ArkUI
   */
  let ArkUIFailIndex = ArkUIReport.indexOf('false');
  let ArkUIFailNum = 0;
  while (ArkUIFailIndex != -1) {
    console.log(ArkUIFailIndex.toString());
    ArkUIFailNum++;
    ArkUIFailIndex = ArkUIReport.indexOf('false', ArkUIFailIndex + 1);
  }
  let ArkuiFailNum = (ArkUIFailNum).toString();
  let ArkUIPassIndex = ArkUIReport.indexOf('true ');
  let ArkUIPassNum = 0;
  while (ArkUIPassIndex != -1) {
    console.log(ArkUIPassIndex.toString());
    ArkUIPassNum++;
    ArkUIPassIndex = ArkUIReport.indexOf('true ', ArkUIPassIndex + 1);
  }
  let ArkUITestNum = ArkUIFailNum + ArkUIPassNum;
  let ArkuiTestNum = (ArkUITestNum).toString();
  /*
   * Audio
   */
  let AudioFailIndex = AudioReport.indexOf('false');
  let AudioFailNum = 0;
  while (AudioFailIndex != -1) {
    console.log(AudioFailIndex.toString());
    AudioFailNum++;
    AudioFailIndex = AudioReport.indexOf('false', AudioFailIndex + 1);
  }
  let audioFailNum = (AudioFailNum).toString();
  let AudioPassIndex = AudioReport.indexOf('true ');
  let AudioPassNum = 0;
  while (AudioPassIndex != -1) {
    console.log(AudioPassIndex.toString());
    AudioPassNum++;
    AudioPassIndex = AudioReport.indexOf('true ', AudioPassIndex + 1);
  }
  let AudioTestNum = AudioFailNum + AudioPassNum;
  let audioTestNum = (AudioTestNum).toString();
  /*
   * Camera
   */
  let CameraFailIndex = CameraReport.indexOf('false');
  let CameraFailNum = 0;
  while (CameraFailIndex != -1) {
    console.log(CameraFailIndex.toString());
    CameraFailNum++;
    CameraFailIndex = CameraReport.indexOf('false', CameraFailIndex + 1);
  }
  let cameraFailNum = (CameraFailNum).toString();
  let CameraPassIndex = CameraReport.indexOf('true ');
  let CameraPassNum = 0;
  while (CameraPassIndex != -1) {
    console.log(CameraPassIndex.toString());
    CameraPassNum++;
    CameraPassIndex = CameraReport.indexOf('true ', CameraPassIndex + 1);
  }
  let CameraTestNum = CameraFailNum + CameraPassNum;
  let cameraTestNum = (CameraTestNum).toString();
  /*
* Player
*/
  let PlayerFailIndex = PlayerReport.indexOf('false');
  let PlayerFailNum = 0;
  while (PlayerFailIndex != -1) {
    console.log(PlayerFailIndex.toString());
    PlayerFailNum++;
    PlayerFailIndex = PlayerReport.indexOf('false', PlayerFailIndex + 1);
  }
  let playerFailNum = (PlayerFailNum).toString();
  let PlayerPassIndex = PlayerReport.indexOf('true ');
  let PlayerPassNum = 0;
  while (PlayerPassIndex != -1) {
    console.log(PlayerPassIndex.toString());
    PlayerPassNum++;
    PlayerPassIndex = PlayerReport.indexOf('true ', PlayerPassIndex + 1);
  }
  let PlayerTestNum = PlayerFailNum + PlayerPassNum;
  let playerTestNum = (PlayerTestNum).toString();
  /*
* Experience
*/
  let ExperienceFailIndex = ExperienceReport.indexOf('false');
  let ExperienceFailNum = 0;
  while (ExperienceFailIndex != -1) {
    console.log(ExperienceFailIndex.toString());
    ExperienceFailNum++;
    ExperienceFailIndex = ExperienceReport.indexOf('false', ExperienceFailIndex + 1);
  }
  let experienceFailNum = (ExperienceFailNum).toString();
  let ExperiencePassIndex = ExperienceReport.indexOf('true ');
  let ExperiencePassNum = 0;
  while (ExperiencePassIndex != -1) {
    console.log(ExperiencePassIndex.toString());
    ExperiencePassNum++;
    ExperiencePassIndex = ExperienceReport.indexOf('true ', ExperiencePassIndex + 1);
  }
  let ExperienceTestNum = ExperienceFailNum + ExperiencePassNum;
  let experienceTestNum = (ExperienceTestNum).toString();

  /**
   * Sensor
   */
  let SensorFailIndex = SensorReport.indexOf('false');
  let SensorFailNum = 0;
  while (SensorFailIndex != -1) {
    console.log(SensorFailIndex.toString());
    SensorFailNum++;
    SensorFailIndex = SensorReport.indexOf('false', SensorFailIndex + 1);
  }
  let sensorFailNum = (SensorFailNum).toString();
  let SensorPassIndex = SensorReport.indexOf('true ');
  let SensorPassNum = 0;
  while (SensorPassIndex != -1) {
    console.log(SensorPassIndex.toString());
    SensorPassNum++;
    SensorPassIndex = SensorReport.indexOf('true ', SensorPassIndex + 1);
  }
  let SensorTestNum = SensorFailNum + SensorPassNum;
  let sensorTestNum = (SensorTestNum).toString();

  /**
   * Screen
   */
  let ScreenFailIndex = ScreenReport.indexOf('false');
  let ScreenFailNum = 0;
  while (SensorFailIndex != -1) {
    console.log(SensorFailIndex);
    ScreenFailNum++;
    ScreenFailIndex = ScreenReport.indexOf('false', ScreenFailIndex + 1);
  }
  let screenFailNum = (ScreenFailNum).toString();
  let ScreenPassIndex = ScreenReport.indexOf('true ');
  let ScreenPassNum = 0;
  while (ScreenPassIndex != -1) {
    console.log(ScreenPassIndex.toString());
    ScreenPassNum++;
    ScreenPassIndex = ScreenReport.indexOf('true ', ScreenPassIndex + 1);
  }
  let ScreenTestNum = ScreenFailNum + ScreenPassNum;
  let screenTestNum = (ScreenTestNum).toString();

  /**
   * MultimodalInput 多模输入
   */
  let MultimodalInputFailIndex = MultimodalInputReport.indexOf('false');
  let MultimodalInputFailNum = 0;
  while (MultimodalInputFailIndex != -1) {
    console.log(MultimodalInputFailIndex.toString());
    MultimodalInputFailNum++;
    MultimodalInputFailIndex = MultimodalInputReport.indexOf('false', MultimodalInputFailIndex + 1);
  }
  let multimodalInputFailNum = (MultimodalInputFailNum).toString();
  let MultimodalInputPassIndex = MultimodalInputReport.indexOf('true ');
  let MultimodalInputPassNum = 0;
  while (MultimodalInputPassIndex != -1) {
    console.log(MultimodalInputPassIndex.toString());
    MultimodalInputPassNum++;
    MultimodalInputPassIndex = MultimodalInputReport.indexOf('true ', MultimodalInputPassIndex + 1);
  }
  let MultimodalInputTestNum = MultimodalInputFailNum + MultimodalInputPassNum;
  let multimodalInputTestNum = (MultimodalInputTestNum).toString();

  /**
   * Power 电源管理
   */
  let PowerFailIndex = PowerReport.indexOf('false');
  let PowerFailNum = 0;
  while (PowerFailIndex != -1) {
    console.log(PowerFailIndex.toString());
    PowerFailNum++;
    PowerFailIndex = PowerReport.indexOf('false', PowerFailIndex + 1);
  }
  let powerFailNum = (PowerFailNum).toString();
  let PowerPassIndex = PowerReport.indexOf('true ');
  let PowerPassNum = 0;
  while (PowerPassIndex != -1) {
    console.log(PowerPassIndex.toString());
    PowerPassNum++;
    PowerPassIndex = PowerReport.indexOf('true ', PowerPassIndex + 1);
  }
  let PowerTestNum = PowerFailNum + PowerPassNum;
  let powerTestNum = (PowerTestNum).toString();

  /**
   * Notification 通知
   */
  let NotificationFailIndex = NotificationReport.indexOf('false');
  let NotificationFailNum = 0;
  while (NotificationFailIndex != -1) {
    console.log(NotificationFailIndex.toString());
    NotificationFailNum++;
    NotificationFailIndex = NotificationReport.indexOf('false', NotificationFailIndex + 1);
  }
  let notificationFailNum = (NotificationFailNum).toString();
  let NotificationPassIndex = NotificationReport.indexOf('true ');
  let NotificationPassNum = 0;
  while (NotificationPassIndex != -1) {
    console.log(NotificationPassIndex.toString());
    NotificationPassNum++;
    NotificationPassIndex = NotificationReport.indexOf('true ', NotificationPassIndex + 1);
  }
  let NotificationTestNum = NotificationFailNum + NotificationPassNum;
  let notificationTestNum = (NotificationTestNum).toString();

  /**
   * Wifi 管理
   */
  let WifiFailIndex = WifiReport.indexOf('false');
  let WifiFailNum = 0;
  while (WifiFailIndex != -1) {
    console.log(WifiFailIndex.toString());
    WifiFailNum++;
    WifiFailIndex = WifiReport.indexOf('false', WifiFailIndex + 1);
  }
  let wifiFailNum = (WifiFailNum).toString();
  let WifiPassIndex = WifiReport.indexOf('true ');
  let WifiPassNum = 0;
  while (WifiPassIndex != -1) {
    console.log(WifiPassIndex.toString());
    WifiPassNum++;
    WifiPassIndex = WifiReport.indexOf('true ', WifiPassIndex + 1);
  }
  let WifiTestNum = WifiFailNum + WifiPassNum;
  let wifiTestNum = (WifiTestNum).toString();

  /**
   * Bluetooth 蓝牙管理
   */
  let BluetoothFailIndex = BluetoothReport.indexOf('false');
  let BluetoothFailNum = 0;
  while (BluetoothFailIndex != -1) {
    console.log(BluetoothFailIndex.toString());
    BluetoothFailNum++;
    BluetoothFailIndex = BluetoothReport.indexOf('false', BluetoothFailIndex + 1);
  }
  let bluetoothFailNum = (BluetoothFailNum).toString();
  let BluetoothPassIndex = BluetoothReport.indexOf('true ');
  let BluetoothPassNum = 0;
  while (BluetoothPassIndex != -1) {
    console.log(BluetoothPassIndex.toString());
    BluetoothPassNum++;
    BluetoothPassIndex = BluetoothReport.indexOf('true ', BluetoothPassIndex + 1);
  }
  let BluetoothTestNum = BluetoothFailNum + BluetoothPassNum;
  let bluetoothTestNum = (BluetoothTestNum).toString();

  /**
   * PCS
   */
  let PCSFailIndex = PCSReport.indexOf('false');
  let PCSFailNum = 0;
  while (PCSFailIndex != -1) {
    console.log(PCSFailIndex.toString());
    PCSFailNum++;
    PCSFailIndex = PCSReport.indexOf('false', PCSFailIndex + 1);
  }
  let pcsFailNum = (PCSFailNum).toString();
  let PCSPassIndex = PCSReport.indexOf('true ');
  let PCSPassNum = 0;
  while (PCSPassIndex != -1) {
    console.log(PCSPassIndex.toString());
    PCSPassNum++;
    PCSPassIndex = PCSReport.indexOf('true ', PCSPassIndex + 1);
  }
  let PCSTestNum = PCSFailNum + PCSPassNum;
  let pcsTestNum = (PCSTestNum).toString();

  /**
   * Interface
   */
  let InterfaceFailIndex = InterfaceReport.indexOf('false');
  let InterfaceFailNum = 0;
  while (InterfaceFailIndex != -1) {
    console.log(InterfaceFailIndex.toString());
    InterfaceFailNum++;
    InterfaceFailIndex = InterfaceReport.indexOf('false', InterfaceFailIndex + 1);
  }
  let interfaceFailNum = (InterfaceFailNum).toString();
  let InterfacePassIndex = InterfaceReport.indexOf('true ');
  let InterfacePassNum = 0;
  while (InterfacePassIndex != -1) {
    console.log(InterfacePassIndex.toString());
    InterfacePassNum++;
    InterfacePassIndex = InterfaceReport.indexOf('true ', InterfacePassIndex + 1);
  }
  let InterfaceTestNum = InterfaceFailNum + InterfacePassNum;
  let interfaceTestNum = (InterfaceTestNum).toString();

  /**
   * Aging
   */
  let AgingFailIndex = AgingReport.indexOf('false');
  let AgingFailNum = 0;
  while (AgingFailIndex != -1) {
    console.log(AgingFailIndex.toString());
    AgingFailNum++;
    AgingFailIndex = AgingReport.indexOf('false', AgingFailIndex + 1);
  }
  let agingFailNum = (AgingFailNum).toString();
  let AgingPassIndex = AgingReport.indexOf('true ');
  let AgingPassNum = 0;
  while (AgingPassIndex != -1) {
    console.log(AgingPassIndex.toString());
    AgingPassNum++;
    AgingPassIndex = AgingReport.indexOf('true ', AgingPassIndex + 1);
  }
  let AgingTestNum = AgingFailNum + AgingPassNum;
  let agingTestNum = (AgingTestNum).toString();

  let arrayBuffer = new ArrayBuffer(40960);
  let bufView = new DataView(arrayBuffer);
  let serializer = new xml.XmlSerializer(bufView);
  serializer.setDeclaration();
  serializer.startElement("testsuites");
  serializer.setAttributes("name", "进迭工程测试结果");
  serializer.setAttributes("starttime", starttime);
  serializer.setAttributes("endtime", endtime);
  //serializer.setAttributes("errors", "0");
  //serializer.setAttributes("disabled", "0");
  serializer.setAttributes("failures", failNum);
  serializer.setAttributes("tests", testNum);
  //serializer.setAttributes("ignored", "0");
  //serializer.setAttributes("unavailable", "0");
  //serializer.setAttributes("productinfo", "{ }");
  //serializer.setAttributes("modules", "ActsValidator");
  //serializer.setAttributes("runmodules", "ActsValidator");
  /*
   * ArkUI
   */
  serializer.startElement("testsuite");
  serializer.setAttributes("name", "ActsArkUITest");
  //serializer.setAttributes("time", "*");
  //serializer.setAttributes("errors", "0");
  //serializer.setAttributes("disabled", "0");
  serializer.setAttributes("failures", ArkuiFailNum);
  //serializer.setAttributes("ignored", "0");
  serializer.setAttributes("tests", ArkuiTestNum);
  //serializer.setAttributes("message", "*");
  //serializer.setAttributes("modulename", "ActsValidator");
  for (let i = 0; i < title1.length; i++) {
    serializer.startElement("testcase");
    serializer.setAttributes("name", String(title1[i]));
    //serializer.setAttributes("time", "*");
    //serializer.setAttributes("classname", "ActsArkUITest");
    serializer.setAttributes("result", String(result1[i]));
    //serializer.setAttributes("level", "*");
    //serializer.setAttributes("message", "*");
    serializer.endElement();
  }
  serializer.endElement();
  /*
   * Audio
   */
  serializer.startElement("testsuite");
  serializer.setAttributes("name", "ActsAudioTest");
  //serializer.setAttributes("time", "*");
  //serializer.setAttributes("errors", "0");
  //serializer.setAttributes("disabled", "0");
  serializer.setAttributes("failures", audioFailNum);
  //serializer.setAttributes("ignored", "0");
  serializer.setAttributes("tests", audioTestNum);
  //serializer.setAttributes("message", "*");
  //serializer.setAttributes("modulename", "ActsValidator");
  for (let i = 0; i < title2.length; i++) {
    serializer.startElement("testcase");
    serializer.setAttributes("name", String(title2[i]));
    //serializer.setAttributes("time", "*");
    //serializer.setAttributes("classname", "ActsAudioTest");
    serializer.setAttributes("result", String(result2[i]));
    //serializer.setAttributes("level", "*");
    //serializer.setAttributes("message", "*");
    serializer.endElement();
  }
  serializer.endElement();
  /*
   * Camera
   */
  serializer.startElement("testsuite");
  serializer.setAttributes("name", "ActsCameraTest");
  //serializer.setAttributes("time", "*");
  //serializer.setAttributes("errors", "0");
  //serializer.setAttributes("disabled", "0");
  serializer.setAttributes("failures", cameraFailNum);
  //serializer.setAttributes("ignored", "0");
  serializer.setAttributes("tests", cameraTestNum);
  //serializer.setAttributes("message", "*");
  //serializer.setAttributes("modulename", "ActsValidator");
  for (let i = 0; i < title3.length; i++) {
    serializer.startElement("testcase");
    serializer.setAttributes("name", String(title3[i]));
    //serializer.setAttributes("time", "*");
    //serializer.setAttributes("classname", "ActsCameraTest");
    serializer.setAttributes("result", String(result3[i]));
    //serializer.setAttributes("level", "*");
    //serializer.setAttributes("message", "*");
    serializer.endElement();
  }
  serializer.endElement();
  /*
* Player
*/
  serializer.startElement("testsuite");
  serializer.setAttributes("name", "ActsPlayerTest");
  //serializer.setAttributes("time", "*");
  //serializer.setAttributes("errors", "0");
  //serializer.setAttributes("disabled", "0");
  serializer.setAttributes("failures", playerFailNum);
  //serializer.setAttributes("ignored", "0");
  serializer.setAttributes("tests", playerTestNum);
  //serializer.setAttributes("message", "*");
  //serializer.setAttributes("modulename", "ActsValidator");
  for (let i = 0; i < title4.length; i++) {
    serializer.startElement("testcase");
    serializer.setAttributes("name", String(title4[i]));
    //serializer.setAttributes("time", "*");
    //serializer.setAttributes("classname", "ActsPlayerTest");
    serializer.setAttributes("result", String(result4[i]));
    //serializer.setAttributes("level", "*");
    //serializer.setAttributes("message", "*");
    serializer.endElement();
  }
  serializer.endElement();
  /*
* Experience
*/
  serializer.startElement("testsuite");
  serializer.setAttributes("name", "ActsExperienceTest");
  //serializer.setAttributes("time", "*");
  //serializer.setAttributes("errors", "0");
  //serializer.setAttributes("disabled", "0");
  serializer.setAttributes("failures", experienceFailNum);
  //serializer.setAttributes("ignored", "0");
  serializer.setAttributes("tests", experienceTestNum);
  //serializer.setAttributes("message", "*");
  //serializer.setAttributes("modulename", "ActsValidator");
  for (let i = 0; i < title5.length; i++) {
    serializer.startElement("testcase");
    serializer.setAttributes("name", String(title5[i]));
    //serializer.setAttributes("time", "*");
    //serializer.setAttributes("classname", "ActsExperienceTest");
    serializer.setAttributes("result", String(result5[i]));
    //serializer.setAttributes("level", "*");
    //serializer.setAttributes("message", "*");
    serializer.endElement();
  }
  serializer.endElement();

  /**
   * Sensor
   */
  serializer.startElement("testsuite");
  serializer.setAttributes("name", "ActsSensorTest");
  //serializer.setAttributes("time", "*");
  //serializer.setAttributes("errors", "0");
  //serializer.setAttributes("disabled", "0");
  serializer.setAttributes("failures", sensorFailNum);
  //serializer.setAttributes("ignored", "0");
  serializer.setAttributes("tests", sensorTestNum);
  //serializer.setAttributes("message", "*");
  //serializer.setAttributes("modulename", "ActsValidator");
  for (let i = 0; i < title6.length; i++) {
    serializer.startElement("testcase");
    serializer.setAttributes("name", String(title6[i]));
    //serializer.setAttributes("time", "*");
    //serializer.setAttributes("classname", "ActsSensorTest");
    serializer.setAttributes("result", String(result6[i]));
    //serializer.setAttributes("level", "*");
    //serializer.setAttributes("message", "*");
    serializer.endElement();
  }
  serializer.endElement();

  /**
   * Screen
   */
  serializer.startElement("testsuite");
  serializer.setAttributes("name", "ActsScreenTest");
  //serializer.setAttributes("time", "*");
  //serializer.setAttributes("errors", "0");
  //serializer.setAttributes("disabled", "0");
  serializer.setAttributes("failures", screenFailNum);
  //serializer.setAttributes("ignored", "0");
  serializer.setAttributes("tests", screenTestNum);
  //serializer.setAttributes("message", "*");
  //serializer.setAttributes("modulename", "ActsValidator");
  for (let i = 0; i < title8.length; i++) {
    serializer.startElement("testcase");
    serializer.setAttributes("name", String(title8[i]));
    //serializer.setAttributes("time", "*");
    //serializer.setAttributes("classname", "ActsScreenTest");
    serializer.setAttributes("result", String(result8[i]));
    //serializer.setAttributes("level", "*");
    //serializer.setAttributes("message", "*");
    serializer.endElement();
  }
  serializer.endElement();

  /**
   * MultimodalInput
   */
  serializer.startElement("testsuite");
  serializer.setAttributes("name", "ActsMultimodalInputTest");
  //serializer.setAttributes("time", "*");
  //serializer.setAttributes("errors", "0");
  //serializer.setAttributes("disabled", "0");
  serializer.setAttributes("failures", multimodalInputFailNum);
  //serializer.setAttributes("ignored", "0");
  serializer.setAttributes("tests", multimodalInputTestNum);
  //serializer.setAttributes("message", "*");
  //serializer.setAttributes("modulename", "ActsValidator");
  for (let i = 0; i < title9.length; i++) {
    serializer.startElement("testcase");
    serializer.setAttributes("name", String(title9[i]));
    //serializer.setAttributes("time", "*");
    //serializer.setAttributes("classname", "ActsMultimodalInputTest");
    serializer.setAttributes("result", String(result9[i]));
    //serializer.setAttributes("level", "*");
    //serializer.setAttributes("message", "*");
    serializer.endElement();
  }
  serializer.endElement();

  /**
   * Power
   */
  serializer.startElement("testsuite");
  serializer.setAttributes("name", "ActsPowerTest");
  //serializer.setAttributes("time", "*");
  //serializer.setAttributes("errors", "0");
  //serializer.setAttributes("disabled", "0");
  serializer.setAttributes("failures", powerFailNum);
  //serializer.setAttributes("ignored", "0");
  serializer.setAttributes("tests", powerTestNum);
  //serializer.setAttributes("message", "*");
  //serializer.setAttributes("modulename", "ActsValidator");
  for (let i = 0; i < title10.length; i++) {
    serializer.startElement("testcase");
    serializer.setAttributes("name", String(title10[i]));
    //serializer.setAttributes("time", "*");
    //serializer.setAttributes("classname", "ActsPowerTest");
    serializer.setAttributes("result", String(result10[i]));
    //serializer.setAttributes("level", "*");
    //serializer.setAttributes("message", "*");
    serializer.endElement();
  }
  serializer.endElement();

  /**
   * Notification 通知
   */
  serializer.startElement("testsuite");
  serializer.setAttributes("name", "ActsNotificationTest");
  //serializer.setAttributes("time", "*");
  //serializer.setAttributes("errors", "0");
  //serializer.setAttributes("disabled", "0");
  serializer.setAttributes("failures", notificationFailNum);
  //serializer.setAttributes("ignored", "0");
  serializer.setAttributes("tests", notificationTestNum);
  //serializer.setAttributes("message", "*");
  //serializer.setAttributes("modulename", "ActsValidator");
  for (let i = 0; i < title11.length; i++) {
    serializer.startElement("testcase");
    serializer.setAttributes("name", String(title11[i]));
    //serializer.setAttributes("time", "*");
    //serializer.setAttributes("classname", "ActsNotificationTest");
    serializer.setAttributes("result", String(result11[i]));
    //serializer.setAttributes("level", "*");
    //serializer.setAttributes("message", "*");
    serializer.endElement();
  }
  serializer.endElement();

  /**
   * Wifi 管理
   */
  serializer.startElement("testsuite");
  serializer.setAttributes("name", "ActsWifiTest");
  //serializer.setAttributes("time", "*");
  //serializer.setAttributes("errors", "0");
  //serializer.setAttributes("disabled", "0");
  serializer.setAttributes("failures", wifiFailNum);
  //serializer.setAttributes("ignored", "0");
  serializer.setAttributes("tests", wifiTestNum);
  //serializer.setAttributes("message", "*");
  //serializer.setAttributes("modulename", "ActsValidator");
  for (let i = 0; i < title12.length; i++) {
    serializer.startElement("testcase");
    serializer.setAttributes("name", String(title12[i]));
    //serializer.setAttributes("time", "*");
    //serializer.setAttributes("classname", "ActsWifiTest");
    serializer.setAttributes("result", String(result12[i]));
    //serializer.setAttributes("level", "*");
    //serializer.setAttributes("message", "*");
    serializer.endElement();
  }
  serializer.endElement();

  /**
   * Bluetooth
   */
  serializer.startElement("testsuite");
  serializer.setAttributes("name", "ActsBluetoothTest");
  //serializer.setAttributes("time", "*");
  //serializer.setAttributes("errors", "0");
  //serializer.setAttributes("disabled", "0");
  serializer.setAttributes("failures", bluetoothFailNum);
  //serializer.setAttributes("ignored", "0");
  serializer.setAttributes("tests", bluetoothTestNum);
  //serializer.setAttributes("message", "*");
  //serializer.setAttributes("modulename", "ActsValidator");
  for (let i = 0; i < title13.length; i++) {
    serializer.startElement("testcase");
    serializer.setAttributes("name", String(title13[i]));
    //serializer.setAttributes("time", "*");
    //serializer.setAttributes("classname", "ActsBluetoothTest");
    serializer.setAttributes("result", String(result13[i]));
    //serializer.setAttributes("level", "*");
    //serializer.setAttributes("message", "*");
    serializer.endElement();
  }
  serializer.endElement();

  /**
   * PCS
   */
  serializer.startElement("testsuite");
  serializer.setAttributes("name", "ActsPCSTest");
  //serializer.setAttributes("time", "*");
  //serializer.setAttributes("errors", "0");
  //serializer.setAttributes("disabled", "0");
  serializer.setAttributes("failures", pcsFailNum);
  //serializer.setAttributes("ignored", "0");
  serializer.setAttributes("tests", pcsTestNum);
  //serializer.setAttributes("message", "*");
  //serializer.setAttributes("modulename", "ActsValidator");
  for (let i = 0; i < title14.length; i++) {
    serializer.startElement("testcase");
    serializer.setAttributes("name", String(title14[i]));
    //serializer.setAttributes("time", "*");
    //serializer.setAttributes("classname", "ActsPCSTest");
    serializer.setAttributes("result", String(result14[i]));
    //serializer.setAttributes("level", "*");
    //serializer.setAttributes("message", "*");
    serializer.endElement();
  }
  serializer.endElement();

  /**
   * Interface
   */
  serializer.startElement("testsuite");
  serializer.setAttributes("name", "ActsInterfaceTest");
  //serializer.setAttributes("time", "*");
  //serializer.setAttributes("errors", "0");
  //serializer.setAttributes("disabled", "0");
  serializer.setAttributes("failures", interfaceFailNum);
  //serializer.setAttributes("ignored", "0");
  serializer.setAttributes("tests", interfaceTestNum);
  //serializer.setAttributes("message", "*");
  //serializer.setAttributes("modulename", "ActsValidator");
  for (let i = 0; i < title14.length; i++) {
    serializer.startElement("testcase");
    serializer.setAttributes("name", String(title14[i]));
    //serializer.setAttributes("time", "*");
    //serializer.setAttributes("classname", "ActsInterfaceTest");
    serializer.setAttributes("result", String(result14[i]));
    //serializer.setAttributes("level", "*");
    //serializer.setAttributes("message", "*");
    serializer.endElement();
  }
  serializer.endElement();

  /**
   * Aging
   */
  serializer.startElement("testsuite");
  serializer.setAttributes("name", "ActsAgingTest");
  //serializer.setAttributes("time", "*");
  //serializer.setAttributes("errors", "0");
  //serializer.setAttributes("disabled", "0");
  serializer.setAttributes("failures", agingFailNum);
  //serializer.setAttributes("ignored", "0");
  serializer.setAttributes("tests", agingTestNum);
  //serializer.setAttributes("message", "*");
  //serializer.setAttributes("modulename", "ActsValidator");
  for (let i = 0; i < title14.length; i++) {
    serializer.startElement("testcase");
    serializer.setAttributes("name", String(title14[i]));
    //serializer.setAttributes("time", "*");
    //serializer.setAttributes("classname", "ActsAgingTest");
    serializer.setAttributes("result", String(result14[i]));
    //serializer.setAttributes("level", "*");
    //serializer.setAttributes("message", "*");
    serializer.endElement();
  }
  serializer.endElement();

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
    fs.closeSync(xmlfd);
  }
}

