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
import vibrator from '@ohos.vibrator';

@Entry
@Component
struct Tfcard {
  @State FillColor: string = '#FF000000';
  @State name: string = 'Vibrator';
  @State StepTips: string = '测试目的：用于测试本机震动马达是否正常工作\n-点击开启震动马达\n-是否震动\n-点击关闭震动马达'
    + '\n-预期结果：震动马达能够震动，并能够正常关闭';
  private tag: string = 'Vibrator';
  @State Vue: boolean = false;
  @State isSensor: boolean = true;
  @State checkInfo: string = '！！';
  @State tfName: string = 'none';
  @State tfVolume: string = 'none';

  async aboutToAppear() {
    //await FirstDialog.ChooseDialog(this.StepTips, this.name)
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
            url: 'pages/Interface/Interface_index',
            params: { result: 'None' }
          })
        })

        Text("震动马达测试")
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
        Text('测试目的:\n设备的震动马达是否能够正常工作\n测试步骤：\n1. 点击开启震动马达, 观察是否有震动发生\n2. 点击关闭震动马达,观察震动是否停止\n3. 如果设备没有震动马达，点击设备无震动马达')
          .fontColor(Color.White)
          .fontSize('18fp')

        Blank()

        Button('开启震动马达')
          .width('40%')
          .height('60vp')
          .onClick(() => {
            try {
              vibrator.startVibration({
                type: 'time',
                duration: 20000,
              }, {
                id: 0,
                usage: 'simulateReality'
              }, (error) => {
                if (error) {
                  console.error('xxxxxxxxxxxxxxxx ohohohohohohohohohohoh error');
                  return;
                }
                console.error('xxxxxxxxxxxxxxxx ohohohohohohohohohohoh Callback returned to indicate a successful vibration');
              });
            } catch (err) {
              console.error('xxxxxxxxxxxxxxxx ohohohohohohohohohohoh error 2');
            }
            this.Vue = true;
          })

        Blank()

        Button('关闭震动马达')
          .width('40%')
          .height('60vp')
          .onClick(() => {
            try {
              // 按照VIBRATOR_STOP_MODE_TIME模式停止振动
              vibrator.stopVibration(vibrator.VibratorStopMode.VIBRATOR_STOP_MODE_TIME, (error) => {
                if (error) {
                  console.error('xxxxxxxxxxxxxxxx ohohohohohohohohohohoh error 3');
                  return;
                }
                console.error('xxxxxxxxxxxxxxxx ohohohohohohohohohohoh Callback returned to indicate successful');
              })
            } catch (err) {
              console.error('xxxxxxxxxxxxxxxx ohohohohohohohohohohoh error 4');
            } finally {
            }
            this.Vue = true;
          })

        Blank()

        Button('设备无震动马达')
          .width('40%')
          .height('60vp')
          .onClick(() => {
            this.Vue = true;
          })

        Blank()
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