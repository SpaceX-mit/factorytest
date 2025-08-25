/*
* Copyright (c) 2023 Hunan OpenValley Digital Industry Development Co., Ltd.
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

import Logger from '../model/Logger'
import { CustomContainer } from '../common/CameraFlashContainer';
import FirstDialog from '../model/FirstDialog';
import router from '@ohos.router';
import sensor from '@ohos.sensor';
import BusinessError from "@ohos.base";
import volumeManager from '@ohos.file.volumeManager';
import fs from '@ohos.file.fs';
import process from '@ohos.process';
import util from '@ohos.util';

@Entry
@Component
struct Gmac {
  @State FillColor: string = '#FF000000';
  @State name: string = 'Gmac';
  @State StepTips: string = '测试目的：用于测试本机能否连接以太网\n-先插入网线\n-进入测试应用\n-看能否识别以太网卡'
    + '\n-预期结果：检测到以太网卡';
  private tag: string = 'Gmac';
  @State Vue: boolean = false;
  @State isSensor: boolean = true;
  @State checkInfo: string = '未检测到以太网！！';
  @State tfName: string = 'none';
  @State tfVolume: string = 'none';

  async aboutToAppear() {
    //await FirstDialog.ChooseDialog(this.StepTips, this.name)
  }

  async startCheck() {
    let child: process.ChildProcess | undefined = undefined;
    try {
      let textDecoder = new util.TextDecoder();
      child = process.runCmd('ifconfig');
      let childResult = child.wait();
      childResult.then(val => {
        console.error('++++++++++++++++++++ runCmd result =' + val);
      })
      await child.getOutput().then(val=> {
        let text = textDecoder.decode(val);
        console.error('++++++++++++++++++++ runCmd output =' + text);
        this.Vue = text.includes('eth')
      })


      console.error('++++++++++++++++++++++++++ gmac = ' + this.Vue);
      if(this.Vue) {
        this.checkInfo = '检测到以太网！！！！';
      } else {
        this.checkInfo = '未检测到以太网！！';
      }
      if(this.Vue) {
        console.error('++++++++++++++++++++++++++ 1');
        let opt = fs.openSync('/sys/block/mmcblk0/device/name', fs.OpenMode.READ_ONLY);
        let buff = new ArrayBuffer(40960);
        let RD = fs.readSync(opt.fd, buff);
        let uint8Array = new Uint8Array(buff, 0, RD);
        this.tfName = String.fromCharCode(...uint8Array);
        console.error('++++++++++++++++++++++++++ 2 = ' + this.tfName);
        fs.closeSync(opt);
      }
    } catch (err) {
      console.error('no +++++++++++++++++++++++++');
    }
  }

  onPageShow() {
    this.startCheck();
  }

  onPageHide() {
  }

  build() {
    Column() {
      Row() {
        Button() {
          Image($r('app.media.ic_public_back'))
            .width('20vp')
            .height('18vp')
            .margin({ left: '20vp' })
        }
        .backgroundColor(Color.Black)
        .size({ width: '40vp', height: '60vp' })
        .onClick(() => {
          router.back({
            url: 'pages/Interface/Interface_index',
            params: { result: 'None' }
          })
        })

        Text("TF卡接口测试")
          .fontColor(Color.White)
          .fontSize('18fp')
          .margin({ left: '-20vp' })
        Text('hello')
          .fontColor(Color.White)
          .visibility(Visibility.Hidden)
      }
      .backgroundColor(Color.Black)
      .height('10%')
      .width('100%')
      .justifyContent(FlexAlign.SpaceBetween)

      Blank().height(20)
      Line()
        .width('100%')
        .height(3)
        .backgroundColor('#FFFFFF')
      Blank().height(20)

      Column() {
        Text('检测结果: ' + this.checkInfo)
          .fontColor((this.Vue ? Color.Green : Color.Red))
          .fontSize('32fp')
          .textAlign(TextAlign.Start)
          .width('100%')
          .margin({ bottom: 24 })
        Text('网卡名称: ' + this.tfName)
          .fontColor(Color.White)
          .fontSize('18fp')
          .textAlign(TextAlign.Start)
          .width('100%')
          .margin({ bottom: 24 })
        Text('网卡IP: ' + this.tfVolume)
          .fontColor(Color.White)
          .fontSize('18fp')
          .textAlign(TextAlign.Start)
          .width('100%')
          .margin({ bottom: 24 })

        Line()
          .width('100%')
          .height(3)
          .backgroundColor('#FFFFFF')
          .margin({ bottom: 24 })

        Button('刷新')
          .width('30%')
          .height('60vp')
          .onClick(() => {
            this.startCheck();
          })
      }
      .width('100%')
      .height('70%')

      CustomContainer({
        title: this.name,
        Url: 'pages/Interface/Interface_index',
        StepTips: this.StepTips,
        FillColor: $FillColor,
        name: $name,
        Vue: $Vue,
        isFlash: $isSensor
      })
        .height('10%')
        .width('100%')
    }
    .width('100%')
    .height('100%')
    .backgroundColor(Color.Black)
  }

  onBackPress() {
    router.replaceUrl({
      url: 'pages/Interface/Interface_index'
    })
  }
}