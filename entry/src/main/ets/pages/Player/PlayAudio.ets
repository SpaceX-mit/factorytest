/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
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

import { CustomContainer } from '../common/AudioContainer';
import FirstDialog from '../model/FirstDialog';
import router from '@ohos.router';

@Entry
@Component
struct playAudio {
  @State routers: Record<string, string | number> = router.getParams() as Record<string, string | number>;
  @State FillColor: string = '#FF000000';
  @State name: string = this.routers.audioTitle as string;
  @State StepTips: string = '测试目的：用于测试音频播放暂停seek\n预期结果：音频播放暂停seek功能正常';
  private tag: string = 'qlw';
  @State Vue: boolean = false;
  @State audioSrc: string = this.routers.audioUrl as string;
  @State isAutoPlay: boolean = true;
  @State showControls: boolean = true;
  controller: VideoController = new VideoController();

  @State currentTime: number = 0;
  @State duration: number = 180;
  @State isPlaying: boolean = true;
  async aboutToAppear() {
    //await FirstDialog.ChooseDialog(this.StepTips, this.name);
  }

  formatTime(seconds: number): string {
    const min = Math.floor(seconds / 60);
    const sec = Math.floor(seconds % 60);
    return `${min.toString().padStart(2, '0')}:${sec.toString().padStart(2, '0')}`;
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
        .size({ width: '40vp', height: '30vp' })
        .onClick(() => {
          router.back({
            url: 'pages/Player/PlayAudioList',
            params: { result: 'None', }
          })
        })

        Text(this.name)
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

      Flex({ alignItems: ItemAlign.Center, justifyContent: FlexAlign.Center }) {
        Video({
          src: this.audioSrc,
          controller: this.controller
        })
          .width('100%')
          .height('60%')
          .backgroundColor(Color.Black)
          .autoPlay(this.isAutoPlay)
          .controls(false)
          .onFinish(() => {
            this.Vue = true;
            this.isPlaying = false;
            this.currentTime = 0
          })
          .onUpdate((e) => {
            this.currentTime = e.time;
          })
          .onPrepared((e) => {
            this.duration = e.duration;
          })
      }
      .width('100%')
      .height('68%')
      Row() {
        Button({ type: ButtonType.Circle }) {
          Image(this.isPlaying ? $r('app.media.icon_play') : $r('app.media.icon_pause'))
            .width(20)
            .height(20)
        }
        .margin({ left: '20vp' })
        .width(30)
        .height(30)
        .onClick(() => {
          if (this.isPlaying) {
            this.controller.pause();
            this.isPlaying = false;
          } else {
            this.controller.start();
            this.isPlaying = true;
          }
        })

        Text(this.formatTime(this.currentTime))
          .fontSize(14)
          .width(50)
          .textAlign(TextAlign.End)
          .fontColor(Color.White)
          .padding(5)

        Slider({
          value: this.currentTime,
          min: 0,
          max: this.duration,
          step: 1,
          style: SliderStyle.OutSet
        })
          .width('80%')
          .trackColor('#ADD8E6')
          .selectedColor('#4169E1')
          .blockColor('#191970')
          .blockBorderColor('#FF0000')
          .trackThickness(4)
          .showTips(true)
          .onChange((value: number) => {
            this.currentTime = value;
            this.controller.setCurrentTime(value);
          })

        Text(this.formatTime(this.duration))
          .fontSize(14)
          .width(50)
          .textAlign(TextAlign.End)
          .fontColor(Color.White)
      }
      .width('100%')
      .margin({ bottom: 20 })
      CustomContainer({
        title: this.name,
        Url: 'pages/Player/PlayAudioList',
        StepTips: this.StepTips,
        name: $name,
        Vue: $Vue
      })
        .height('14%')
        .width('100%')
    }
    .width('100%')
    .height('100%')
    .backgroundColor(Color.Black)
  }

  onBackPress() {
    router.replaceUrl({
      url: 'pages/Player/PlayAudioList',
    })
  }
}