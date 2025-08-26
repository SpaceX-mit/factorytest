import common from '@ohos.app.ability.common';
import fs from '@ohos.file.fs';
import util from '@ohos.util';
const filePath = '/system/etc/factorytest_config.json';

export interface ConfigData {
  first_menu: number[];
  ArkUI_menu: number[];
  Audio_menu: number[];
  Camera_menu: number[];
  Player_menu: number[];
  Sensor_menu: number[];
  Screen_menu: number[];
  MultimodalInput_menu: number[];
  Power_menu: number[];
  Wifi_menu: number[];
  Interface_menu: number[];
  _comment: string[];
}

export interface ResultData {
  final_result: number[];
  ArkUI_result: number[];
  Audio_result: number[];
  Camera_result: number[];
  Player_result: number[];
  Sensor_result: number[];
  Screen_result: number[];
  MultimodalInput_result: number[];
  Power_result: number[];
  Wifi_result: number[];
  Interface_result: number[];
}

export class FactorytestData {
  private static ins: FactorytestData;
  public configData: ConfigData = {
    first_menu: [0,1,2,3,4,5,6,7,8,9,10,11,12,13],
    ArkUI_menu: [0,1,7,8,15,18,28],
    Audio_menu: [0,2],
    Camera_menu: [0],
    Player_menu: [0,1],
    Sensor_menu: [0,1,3,4,5,12],
    Screen_menu: [1,3],
    MultimodalInput_menu: [0,1,2],
    Power_menu: [0,1],
    Wifi_menu: [0],
    Interface_menu: [0,1,2,3],
    _comment: ['用于注释'],
  };

  public resultData: ResultData = {
    final_result: [0,0],
    ArkUI_result: [0,0],
    Audio_result: [0,0],
    Camera_result: [0,0],
    Player_result: [0,0],
    Sensor_result: [0,0],
    Screen_result: [0,0],
    MultimodalInput_result: [0,0],
    Power_result: [0,0],
    Wifi_result: [0,0],
    Interface_result: [0,0],
  };

  private constructor() {
  }

  public static getInstance(): FactorytestData {
    if (!FactorytestData.ins) {
      FactorytestData.ins = new FactorytestData();
    }

    return FactorytestData.ins;
  }

  public static loadConfigs() {
    console.error('bububububububu');
    try {
      let file = fs.openSync(filePath, fs.OpenMode.READ_ONLY);
      console.error('bububububu 1');
      let buff = new ArrayBuffer(8192);
      console.error('bububububu 2');
      const content = fs.readSync(file.fd, buff);
      console.error('bububububu 3');
      let array = new Uint8Array(buff);
      console.error('bububububu 4 array = ' + array);
      fs.close(file.fd);
      console.error('bububububu 5');
      let decoder = new util.TextDecoder('utf-8');
      console.error('bububububu 6');
      const jsonStr = decoder.decode(array);
      console.error('bububububu 7 jsonStr = ' + jsonStr);
      FactorytestData.getInstance().configData = JSON.parse(jsonStr);
    } catch (err) {
      console.error(`bububububu 访问失败: ${err.code}, ${err.message}`);
    }
    console.error('bububububu xxxxxxxxxxxxxxxx first_menu = ' + FactorytestData.getInstance().configData.first_menu);
  }

  public static getConfig(): ConfigData {
    return FactorytestData.getInstance().configData;
  }

  public static getResult(): ResultData {
    return FactorytestData.getInstance().resultData;
  }
}
