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

import fs from '@ohos.file.fs';
import promptAction from '@ohos.promptAction';
import router from '@ohos.router';
import Logger from '../model/Logger';
import { BusinessError } from '@ohos.base';
import { DisplayData } from '../../utils/DisplayData';

@Component
export struct CustomContainer {
  @Link FillColor: string;
  @Link name: string;
  @Link Vue: boolean;
  Url: string = '';
  title: string = '';
  StepTips: string = '';
  btnWidth: string = '';
  btnHeight: string = '';
  imgSize: string = '';

  @Builder
  PassBtn(text: Resource, isFullScreen: boolean) {
    if (this.Vue == false) {
      Button({ stateEffect: this.Vue }) {
        Image($r('app.media.ic_public_pass'))
          .width(this.imgSize)
          .height(this.imgSize)
      }
      .width(this.btnWidth)
      .height(this.btnHeight)
      .backgroundColor(Color.Grey)
      .opacity(0.4)
      .onClick(() => {

      })
    }
    else {
      Button({ stateEffect: this.Vue }) {
        Image($r('app.media.ic_public_pass'))
          .width(this.imgSize)
          .height(this.imgSize)
      }
      .width(this.btnWidth)
      .height(this.btnHeight)
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
        .width(this.imgSize)
        .height(this.imgSize)
    }
    .width(this.btnWidth)
    .height(this.btnHeight)
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
      Flex({
        justifyContent: FlexAlign.SpaceEvenly, alignItems: ItemAlign.Center
      }) {
        this.PassBtn($r('app.string.btn_fullscreen'), true);
        Button() {
          Image($r('app.media.ic_public_help'))
            .width(this.imgSize)
            .height(this.imgSize)
        }
        .width(this.btnWidth)
        .height(this.btnHeight)
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
      .height('98%')
      .width('100%')
      .backgroundColor(Color.Black)
    }
    .height('98%')
    .width('100%')
  }
}
