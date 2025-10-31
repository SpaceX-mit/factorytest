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
import fs from '@ohos.file.fs';
import router from '@ohos.router';
import Logger from '../model/Logger'
import FirstDialog from '../model/FirstDialog';
import { BusinessError } from '@ohos.base';
import componentUtils from '@ohos.arkui.componentUtils';

const TAG = '[ElectromagneticTouch]';

@Component
struct CustomContainer1 {
  @Link x: number;
  @Link y: number;
  @Link isshow: Visibility;
  @Link name: string;
  title: string = '';
  StepTips: string = '';
  Url: string = '';
  @Link Vue: boolean;
  @BuilderParam content: () => void;

  // 监听位置变化，刷新页面
  @State @Watch('drawPath') touchPosition: Position = {
    x: 0,
    y: 0,
  };
  private lastTouchPosition: Position = {
    x: 0,
    y: 0,
  };

  private settings: RenderingContextSettings = new RenderingContextSettings(true);
  private canvasContext: CanvasRenderingContext2D = new CanvasRenderingContext2D(this.settings);
  private offset_x: number = 0;
  private offset_y: number = 138;

  @Builder
  PassBtn(text: Resource, isFullScreen: boolean) {
    if (this.Vue == false) {
      Button({ stateEffect: this.Vue }) {
        Image($r('app.media.ic_public_pass'))
          .width('20vp')
          .height('20vp')
      }
      .width('30%')
      .height('60vp')
      .backgroundColor(Color.Grey)
      .opacity(0.4)
      .onClick(() => {

      })
    }
    else {
      Button({ stateEffect: this.Vue }) {
        Image($r('app.media.ic_public_pass'))
          .width('20vp')
          .height('20vp')
      }
      .width('30%')
      .height('60vp')
      .backgroundColor(Color.Grey)
      .onClick(() => {
        router.back({
          url: this.Url,
          params: {
            result: 'true ', title: this.name,
          }
        })
        promptAction.showToast({
          message: '通过', duration: 1000
        });
      })
    }
  }

  @Builder
  FailBtn(text: Resource, isFullScreen: boolean) {
    Button() {
      Image($r('app.media.ic_public_fail'))
        .width('20vp')
        .height('20vp')
    }
    .width('30%')
    .height('60vp')
    .backgroundColor(Color.Grey)
    .onClick(() => {
      router.back({
        url: this.Url,
        params: {
          result: 'false', title: this.name,
        }
      })
      promptAction.showToast({
        message: '失败', duration: 1000
      });
    })
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
            url: this.Url,
            params: { result: 'None', title: this.name, }
          })
        })

        Text(this.title)
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

      //this.content();
      Row() {
        Canvas(this.canvasContext)
          .id('canvasView')
          .width('100%')
          .height('100%')
          .backgroundColor('#D5D5D5')
          .onReady(() => {
            let id = 'canvasView';
            let componentInfo = componentUtils.getRectangleById(id);
            this.offset_x = componentInfo.screenOffset.x;
            //this.offset_y = componentInfo.screenOffset.y;
            console.warn("bububu offset", this.offset_x, this.offset_y)
            this.drawPath()
          })
          .onTouch(event => {
            if (event.type === TouchType.Down) {
              this.touchPosition = {
                x: event.touches[0].displayX - this.offset_x,
                y: event.touches[0].displayY - this.offset_y
              }
              this.isshow = Visibility.Visible;
            } else if (event.type === TouchType.Move) {
              this.touchPosition = {
                x: event.changedTouches[0].displayX - this.offset_x,
                y: event.changedTouches[0].displayY - this.offset_y
              }
              this.isshow = Visibility.Visible;
            } else {
              this.lastTouchPosition = {
                x: 0,
                y: 0
              }
              this.touchPosition = {
                x: 0,
                y: 0
              }
              this.isshow = Visibility.None;
            }
            this.Vue = true;
          })
      }
      .height('70%')
      .width('100%')
      //.justifyContent(FlexAlign.Center)

      Blank()
      Row() {
        this.PassBtn($r('app.string.btn_fullscreen'), true);
        Button() {
          Image($r('app.media.ic_public_help'))
            .width('20vp')
            .height('20vp')
        }
        .width('30%')
        .height('60vp')
        .backgroundColor(Color.Grey)
        .onClick(() => {
          AlertDialog.show(
            {
              title: '操作提示',
              message: this.StepTips,
              confirm: {
                value: 'OK',
                action: () => {
                }
              }
            }
          )
        })

        this.FailBtn($r('app.string.btn_fullscreen'), true);
      }
      .width('100%')
      .justifyContent(FlexAlign.SpaceEvenly)
      .backgroundColor(Color.Black)
    }
    .height('98%')
    .width('100%')
  }

  // 绘制轨迹线
  drawPath() {
    let lineWidth = 2
    //this.canvasContext.clearRect(0, 0, this.sw, this.sh);
    this.canvasContext.lineWidth = lineWidth
    this.canvasContext.strokeStyle = '#ff1a5cae'

    // console.warn("bububu x y ls ly ", this.touchPosition.x, this.touchPosition.y,
    //   this.lastTouchPosition.x, this.lastTouchPosition.y)

    // 画出轨迹线
    if (this.lastTouchPosition.x != 0 && this.lastTouchPosition.y != 0) {
      this.canvasContext.beginPath();
      this.canvasContext.lineWidth = 0.7;
      this.canvasContext.moveTo(this.lastTouchPosition.x, this.lastTouchPosition.y);
      this.canvasContext.lineTo(this.touchPosition.x, this.touchPosition.y);
      this.canvasContext.stroke();
    }
    this.lastTouchPosition.x = this.touchPosition.x;
    this.lastTouchPosition.y = this.touchPosition.y;
  }
}

@Entry
@Component
struct ElectromagneticTouch {
  @State x: number = 0;
  @State y: number = 0;
  @State Vue: boolean = false;
  @State isshow: Visibility = Visibility.None;
  @State name: string = 'ElectromagneticTouch';
  @State StepTips: string = '操作步骤：电磁笔触碰屏幕并滑动' + '\n' + '预期结果：在电磁笔滑动处出现滑动轨迹线';

  async aboutToAppear() {
    //await FirstDialog.ChooseDialog(this.StepTips, this.name);
  }

  build() {
    Column() {
      CustomContainer1({
        title: "电磁触控测试",
        Url: 'pages/Screen/Screen_index',
        StepTips: this.StepTips,
        x: $x,
        y: $y,
        isshow: $isshow,
        name: $name,
        Vue: $Vue,
      })
    }
    .width('100%')
    .height('100%')
    .backgroundColor(Color.Black)
  }

  onBackPress() {
    router.replaceUrl({
      url: 'pages/Screen/Screen_index',
    })
  }
}

export interface Position {
  x: number;
  y: number;
}
