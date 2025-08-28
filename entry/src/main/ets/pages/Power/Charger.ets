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
import batteryInfo from '@ohos.batteryInfo';

@Entry
@Component
struct Charger {
  @State FillColor: string = '#FF000000';
  @State name: string = 'Charger';
  @State StepTips: string = '测试目的：用于测试本机能否正常充电\n-插入适配器\n-进入测试应用\n-看是否正常充电\n-检测结果绿色为通过'
    + '\n-预期结果：设备正常充电，正常显示电量\n注意：进入该界面后才插入适配器，请点击刷新';
  private tag: string = 'Charger';
  @State Vue: boolean = false;
  @State isSensor: boolean = true;
  @State checkInfo: string = '设备未充电！！！';
  @State batteryLevel: string = 'none';
  @State tfVolume: string = 'none';

  async aboutToAppear() {
    //await FirstDialog.ChooseDialog(this.StepTips, this.name)
  }

  startCheck() {
    try {
      let chargingStatus = batteryInfo.chargingStatus;
      if(chargingStatus === 1 || chargingStatus === 3) {
        this.Vue = true;
      } else {
        this.Vue = false;
      }
      console.error('++++++++++++++++++++++++++ tf = ' + this.Vue);
      if(this.Vue) {
        this.checkInfo = '设备正在充电！！！！';
      } else {
        this.checkInfo = '设备未充电！！！';
      }
      this.batteryLevel = batteryInfo.batterySOC.toString();
      if(this.batteryLevel === '100') {
        this.checkInfo = '设备满电！！！！';
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
            url: 'pages/Power/Power_index',
            params: { result: 'None' }
          })
        })

        Text("充电测试")
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
          .margin({ bottom: 36 })
        Text('电池电量: ' + this.batteryLevel)
          .fontColor(Color.White)
          .fontSize('18fp')
          .textAlign(TextAlign.Start)
          .width('100%')
          .margin({ bottom: 36 })

        Line()
          .width('100%')
          .height(3)
          .backgroundColor('#FFFFFF')
          .margin({ bottom: 24 })

        Button('刷新')
          .width('40%')
          .height('60vp')
          .onClick(() => {
            this.startCheck();
          })
      }
      .width('80%')
      .height('70%')

      CustomContainer({
        title: this.name,
        Url: 'pages/Power/Power_index',
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
      url: 'pages/Power/Power_index'
    })
  }
}