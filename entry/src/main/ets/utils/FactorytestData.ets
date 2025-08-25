import common from '@ohos.app.ability.common';
import fs from '@ohos.file.fs';
import util from '@ohos.util';
const filePath = '/system/etc/factorytest_config.json';

export interface ConfigData {
  first_menu: number[];
}

export class FactorytestData {
  private static ins: FactorytestData;
  public configData: ConfigData = {
    first_menu: [0,1,2,3,4,5,6,7,8,9,10,11,12,13],
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
      let buff = new ArrayBuffer(1024);
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
}
