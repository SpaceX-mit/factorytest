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
import CameraService from '../model/CameraService';

interface ResolutionItem {
  value: string;
}

@Entry
@Component
struct playVideo {
  @State routers: Record<string, string | number> = router.getParams() as Record<string, string | number>;
  @State FillColor: string = '#FF000000';
  @State name: string = 'Normal';
  @State StepTips: string = '测试目的：用于测试视频播放暂停seek\n预期结果：视频播放暂停seek功能正常';
  private tag: string = 'qlw';
  private mXComponentController: XComponentController = new XComponentController();
  @State surfaceId: number = 0;
  @State Vue: boolean = true;
  @State videoSrc: string = 'h264Mp3.mp4';
  @State isAutoPlay: boolean = true;
  @State showControls: boolean = true;
  controller: VideoController = new VideoController();
  @State cameraDeviceIndex: number = 0;
  @State resolution: ResolutionItem[] = [];
  @State testingFrequency: number = 0;
  @State clickFrequency: number = 0;
  @State cameraListLength: number = 0;
  @State cameraList: SelectOption[] = [];
  @State resolutionSelectVal: string = '';
  @State nextEnabled: boolean = true;
  @State formatVal: SelectOption[] = [];
  private swiperController: SwiperController = new SwiperController()
  private imgList: Resource[] = [  $r('app.media.logo1'),
    $r('app.media.logo2'),
    $r('app.media.logo3')]


  async aboutToAppear() {
    //await FirstDialog.ChooseDialog(this.StepTips, this.name);
  }

  onPageHide() {
    CameraService.releaseCamera()
  }

  cameraListFn() {
    this.cameraList = []
    this.cameraListLength = CameraService.cameras.length
    for (let index = 0; index < this.cameraListLength; index++) {
      this.cameraList.push({ value: `Camera ${index}` })
    }
    // 测试总次数 = 摄像头0的分辨率 + 摄像头1的分辨率 优先以RK为主
    this.testingFrequency = this.resolution.length
  }

  async cameraInit(obj?: ESObject) {
    CameraService.initCamera(this.surfaceId, this.cameraDeviceIndex, undefined, undefined, obj).then(() => {
      this.resolution = CameraService.resolution
      this.resolutionSelectVal = String(this.resolution[this.clickFrequency].value)
      this.cameraListFn()
    })
  }

  onPageShow() {
    this.surfaceId = Number(this.mXComponentController.getXComponentSurfaceId());
    CameraService.initCamera(this.surfaceId, this.cameraDeviceIndex).then(() => {
      this.cameraListFn()
    })
  }

  build() {
    Column() {
      Row() {
        Button() {
          Image($r('app.media.ic_public_back')).width('20vp').height('18vp').margin({ left: '20vp' })
        }.backgroundColor(Color.Black).size({ width: '40vp', height: '30vp' })
        .onClick(() => {
          router.back({
            url: 'pages/Aging/Aging_index',
            params: { result: 'None', }
          })
        })

        Text('综合老化测试')
          .fontColor(Color.White)
          .fontSize('18fp')
          .margin({ left: '-20vp' })
        Text('hello')
          .fontColor(Color.White)
          .visibility(Visibility.Hidden)
      }.backgroundColor(Color.Black).height('10%').width('100%').justifyContent(FlexAlign.SpaceBetween)

      Blank().height(20)
      Line()
        .width('100%')
        .height(3)
        .backgroundColor('#FFFFFF')

      Row() {
        Flex({ alignItems: ItemAlign.Center, justifyContent: FlexAlign.Center }) {
          Video({
            src: $rawfile(this.videoSrc),
            controller: this.controller
          })
            .width('100%')
            .height('60%')
            .loop(true)
            .autoPlay(this.isAutoPlay)
            .controls(this.showControls)
            .onFinish(() => {
              this.Vue = true;
            })
        }.width('50%').height('38%').onClick(() => {
          this.showControls = !this.showControls
        })

        Flex({ alignItems: ItemAlign.Center, justifyContent: FlexAlign.SpaceAround, direction: FlexDirection.Column }) {
          XComponent({
            id: 'componentId',
            type: 'surface',
            controller: this.mXComponentController
          })
            .onLoad(async () => {
              this.surfaceId = Number(this.mXComponentController.getXComponentSurfaceId());
              //this.cameraInit()
            })
            .size({ width: '100%', height: '60%' })
        }.width('50%').height('38%')
      }
/*
      XComponent({
        id: 'cube',
        type: 'surface',
        //controller: this.cube_controller
      })
        .width('100%')
        .height('40%')
        .onLoad(() => {
          //this.cube_controller.startAnimation()
        })
*/
      Swiper(this.swiperController) {
        ForEach(this.imgList, (item: Resource) => {
          Image(item)
            .width('100%')
            .height('100%')
            .objectFit(ImageFit.Contain)
        })
      }
      .loop(true)
      .autoPlay(true)
      .interval(2000)
      .indicator(false)
      .width('80%')
      .height('38%')

      Blank().height(20)

      CustomContainer({
        title: this.name,
        Url: 'pages/Aging/Aging_index',
        StepTips: this.StepTips,
        name: $name,
        Vue: $Vue
      }).height('14%').width('100%')
    }.width('100%').height('100%').backgroundColor(Color.Black)
  }

  onBackPress() {
    router.replaceUrl({
      url: 'pages/Aging/Aging_index',
    })
  }
}