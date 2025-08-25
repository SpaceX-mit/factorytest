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
import router from '@ohos.router';
import { CustomContainer } from '../common/CanvasCustomContainer1';
import FirstDialog from '../model/FirstDialog';
import inputConsumer from '@ohos.multimodalInput.inputConsumer';

@Entry
@Component
struct Key {
  @State FillColor: string = '#FF000000';
  @State name: string = 'KeyTest';
  @State StepTips: string = '操作步骤：分别按设备的POWER键，音量+，音量-键' + '\n' + '预期结果：原本默认红色的填色区域会变成绿色';
  @State Vue: boolean = false;
  @State color_power: Color = Color.Red;
  @State color_volume_up: Color = Color.Red;
  @State color_volume_down: Color = Color.Red;

  // 配置按键参数
  keyOptions_power: inputConsumer.KeyOptions = {
    preKeys: [],          // 前置按键（组合键时使用）
    finalKey: 18,         // VOLUME_UP
    isFinalKeyDown: true, // 监听按下事件
    finalKeyDownDuration: 0 // 立即触发回调
  };

  // 定义回调函数
  callback_power = (keyOptions: inputConsumer.KeyOptions) => {
    // 业务逻辑处理（如关机操作）
    this.color_power = Color.Green;
    if(this.color_power == Color.Green && this.color_volume_up == Color.Green && this.color_volume_down == Color.Green) {
      this.Vue = true;
    }
    console.error('bbbbbbbbbbbbbbbbbbbbbbbbbbbb  volume up')
  };

  // 配置按键参数
  keyOptions_up: inputConsumer.KeyOptions = {
    preKeys: [],          // 前置按键（组合键时使用）
    finalKey: 16,         // VOLUME_UP
    isFinalKeyDown: true, // 监听按下事件
    finalKeyDownDuration: 0 // 立即触发回调
  };

  // 定义回调函数
  callback_up = (keyOptions: inputConsumer.KeyOptions) => {
    // 业务逻辑处理（如关机操作）
    this.color_volume_up = Color.Green;
    if(this.color_power == Color.Green && this.color_volume_up == Color.Green && this.color_volume_down == Color.Green) {
      this.Vue = true;
    }
    console.error('bbbbbbbbbbbbbbbbbbbbbbbbbbbb  volume up')
  };

  // 配置按键参数
  keyOptions_down: inputConsumer.KeyOptions = {
    preKeys: [],          // 前置按键（组合键时使用）
    finalKey: 17,         // VOLUME_UP
    isFinalKeyDown: true, // 监听按下事件
    finalKeyDownDuration: 0 // 立即触发回调
  };

  // 定义回调函数
  callback_down = (keyOptions: inputConsumer.KeyOptions) => {
    // 业务逻辑处理（如关机操作）
    this.color_volume_down = Color.Green;
    if(this.color_power == Color.Green && this.color_volume_up == Color.Green && this.color_volume_down == Color.Green) {
      this.Vue = true;
    }
    console.error('bbbbbbbbbbbbbbbbbbbbbbbbbbbb  volume down')
  };

  async aboutToAppear() {
    //await FirstDialog.ChooseDialog(this.StepTips, this.name);
  }

  async onPageShow() {
    try {
      console.error('bbbbbbbbbbbbbbbbbbbbbbb');
      inputConsumer.on("key", this.keyOptions_up, this.callback_up);
      inputConsumer.on("key", this.keyOptions_down, this.callback_down);
      inputConsumer.on("key", this.keyOptions_power, this.callback_power);
    } catch (error) {
      console.error('bbbbbbbbbbbbbbbbbbbbbbb 监听失败: ${JSON.stringify(error)}');
    }
  }

  onPageHide() {
    inputConsumer.off("key", this.keyOptions_up, this.callback_up);
    inputConsumer.off("key", this.keyOptions_down, this.callback_down);
    inputConsumer.off("key", this.keyOptions_power, this.callback_power);
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

        Text("按键测试")
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

      Row() {
        Blank()
        Button() {
          Text('电源键').fontSize(20)
        }
        .width('30%')
        .height('60vp')
        .backgroundColor(this.color_power)
        .opacity(1.0)
        .borderRadius(0)
        .onClick(() => {

        })

        Blank().width(20)

        Button() {
          Text('音量+').fontSize(20)
        }
        .width('30%')
        .height('60vp')
        .backgroundColor(this.color_volume_up)
        .opacity(1.0)
        .borderRadius(0)
        .onClick(() => {

        })

        Blank().width(20)

        Button() {
          Text('音量-').fontSize(20)
        }
        .width('30%')
        .height('60vp')
        .backgroundColor(this.color_volume_down)
        .opacity(1.0)
        .borderRadius(0)
        .onClick(() => {

        })

        Blank()

      }.width('100%').height('35%')

      Row() {
        Text('测试目的:\n系统能够正确识别到电源键，音量+键，音量-键等按键\n测试步骤：\n1. 按键图像的初始颜色为红色\n2. 分别按下按键\n3. 观察按键图像颜色\n4. 按键颜色变为绿色则表示通过\n5. 所有按键图像颜色变为绿色，该测试用例通过')
          .fontColor(Color.White)
          .fontSize('18fp')
      }.width('80%').height('35%')

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
            url: 'pages/MultimodalInput/MultimodalInput_index',
            params: { result: 'true ', title: this.name,
            }
          })
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
        })

        Blank()
      }.width('100%').height('14%').backgroundColor(Color.Black).justifyContent(FlexAlign.Center)
    }
    .width('100%')
    .height('100%')
    .backgroundColor(Color.Black)
  }

  onBackPress() {
    router.replaceUrl({
      url: 'pages/MultimodalInput/MultimodalInput_index',
    })
  }
}

