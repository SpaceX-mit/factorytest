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
import display from '@ohos.display';
import systemParameter from '@ohos.systemparameter';
import power from '@ohos.power';
import { FactorytestData } from '../../utils/FactorytestData';

@Entry
@Component
struct Reboot {
  @State FillColor: string = '#FF000000';
  @State name: string = 'Reboot';
  @State StepTips: string = '测试目的：重启老化测试\n-点击开启测试\n-是否能够多次重启\n-重启无异常'
    + '\n-预期结果：多次重启无异常';
  private tag: string = 'Reboot';
  @State Vue: boolean = false;
  @State isSensor: boolean = true;
  @State checkInfo: string = '！！';
  @State tfName: string = 'none';
  @State tfVolume: string = 'none';
  @State info: string = '未测试';
  @State timeLeft: number = 15;
  private intervalId: number | null = null
  private reboot_times: number = 1000;
  private current_times: number = 0;

  async aboutToAppear() {
    //await FirstDialog.ChooseDialog(this.StepTips, this.name)
    FactorytestData.loadConfigs();
    this.reboot_times = FactorytestData.getConfig().reboot_times;
    if (systemParameter.getSync('persist.factorytest.reboottest.enabled', '0') === '1') {
      let currentValue = systemParameter.getSync('persist.factorytest.rebootnum');
      this.current_times = parseInt(currentValue) + 1;

      if(this.current_times < this.reboot_times) {
        this.info = '测试中... 勿动！！'
        let newValue = this.current_times;
        systemParameter.setSync('persist.factorytest.rebootnum', newValue.toString());

        this.intervalId = setInterval(() => {
          if (this.timeLeft > 0) {
            this.timeLeft--
          } else {
            power.rebootDevice("reboot_reason");
          }
        }, 1000)
      } else {
        this.info = '恭喜你！测试通过！！'
        systemParameter.setSync('persist.factorytest.reboottest.enabled', '0');
        systemParameter.setSync('persist.factorytest.rebootnum', '0');
        this.Vue = true;
      }
    }
  }

  onPageShow() {
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
            url: 'pages/Aging/Aging_index',
            params: { result: 'None' }
          })
        })

        Text("重启老化测试")
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
      Blank().height(10)

      Column() {
        Text('测试目的：重启老化测试\n-点击开启测试\n-是否能够多次重启\n-重启无异常')
          .fontColor(Color.White)
          .fontSize('18fp')

        Blank()

        Row() {
          Text('总测试次数：')
            .fontSize(40)
            .fontColor(Color.White)

          Text(this.reboot_times.toString())
            .fontSize(50)
            .fontColor(Color.Red)
        }
        Blank()

        Row() {
          Text('当前测试次数：')
            .fontSize(40)
            .fontColor(Color.White)

          Text(this.current_times.toString())
            .fontSize(50)
            .fontColor(Color.Red)
        }
        Blank()

        Row() {
          Text('倒计时：')
            .fontSize(40)
            .fontColor(Color.White)

          Text(this.timeLeft.toString())
            .fontSize(50)
            .fontColor(Color.Red)
        }
        Blank()

        Row() {
          Text(this.info)
            .fontSize(60)
            .fontColor(this.Vue? Color.Green:Color.Red)
        }
        Blank()

        Button('开始测试')
          .width('40%')
          .height('60vp')
          .onClick(() => {
            try {
              this.info = '测试中 ... 勿动 ！！！'
              this.current_times = 0
              this.Vue = false
              systemParameter.setSync('persist.factorytest.reboottest.enabled', '1');
              if(systemParameter.getSync('persist.factorytest.reboottest.enabled', '0') === '1') {
                this.intervalId = setInterval(() => {
                  if (this.timeLeft > 0) {
                    this.timeLeft--
                  } else {
                    power.rebootDevice("reboot_reason");
                  }
                }, 1000)
              }
            } catch (err) {
              console.error('xxxxxxxxxxxxxxxx ohohohohohohohohohohoh error 2');
            }
            //this.Vue = true;
          })

        Blank()

        Button('结束测试')
          .width('40%')
          .height('60vp')
          .onClick(() => {
            this.info = '你停止了测试！！'
            systemParameter.setSync('persist.factorytest.reboottest.enabled', '0');
            clearInterval(this.intervalId);
            //this.Vue = true;
          })

        Blank()
      }
      .width('100%')
      .height('70%')

      CustomContainer({
        title: this.name,
        Url: 'pages/Aging/Aging_index',
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
      url: 'pages/Aging/Aging_index'
    })
  }
}