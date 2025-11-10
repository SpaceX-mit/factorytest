// TouchFillTest.ets
import { display } from '@kit.ArkUI';
import router from '@ohos.router';
import promptAction from '@ohos.promptAction';
import window from '@ohos.window';
import common from '@ohos.app.ability.common';
@Entry
@Component
struct TouchFillTest {
  private settings: RenderingContextSettings = new RenderingContextSettings(true);
  private ctx: CanvasRenderingContext2D = new CanvasRenderingContext2D(this.settings);

  // 方格参数
  private gridSize: number = 80;
  private gridColor: string = '#ffff00';
  private arrayIndex: number = 0;
  private timerId: number = -1;
  private fillColor: Array<string> = ['#ff0000', '#0000ff', '#00ff00', '#ffffff', '#808080'];
  @State private filledCells: Map<string, boolean> = new Map();
  @State StepTips: string = '操作步骤：手指触摸屏幕并滑动' + '\n' + '预期结果：在手指触摸过的方格区域被填充成红蓝绿白灰五种颜色交替显示0.5秒';
  @State  Vue: boolean = false;
  private Url: string = 'pages/Screen/Screen_index';
  @State private name: string = 'TouchFill';
  @State private yPosArray: Array<string> = ['30%', '60%', '90%'];
  @State private yPosArrayIndex: number = 2;
  context: common.UIAbilityContext = getContext(this) as common.UIAbilityContext;
  async setSystemBar() {
    let windowClass = await window.getLastWindow(this.context);
    //设置导航栏，状态栏不可见
    await windowClass.setWindowSystemBarEnable([]);
  }

  aboutToAppear() {
    //this.startIntervalTimer();
    this.setSystemBar();
    let currentOrientation: display.Orientation = display.getDefaultDisplaySync().orientation;
    console.log(`ohtest 当前屏幕方向: ${currentOrientation}`); //0 2竖屏 ，13横屏
    if (currentOrientation === 0 || currentOrientation === 2) {
      this.gridSize = 80;
    }else
      this.gridSize = 60;
  }

  @Builder
  PassBtn(text: Resource, isFullScreen: boolean) {
    if (this.Vue == false) {
      Button({ stateEffect: this.Vue }) {
        Image($r('app.media.ic_public_pass'))
          .width('20vp')
          .height('20vp')
      }
      .width('22%')
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
      .width('22%')
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
    .width('22%')
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
      Canvas(this.ctx)
        .width('100%')
        .height('100%')
        .backgroundColor('#ffffff')
        .onReady(() => {
          this.drawGrid();
        })
        .onTouch((event: TouchEvent) => {
          let x = event.touches[0].x;
          let y = event.touches[0].y;
          if (event.type === TouchType.Down) {
            console.log("ohtest down: timerId = " + this.timerId);
            this.startIntervalTimer();
            this.handleTouch(x, y);
          }
          else if (event.type === TouchType.Move) {

            this.stopIntervalTimer();
            this.handleTouch(x, y);
          }
          else if (event.type === TouchType.Up) {
            console.log("ohtest uppppp: timerId = " + this.timerId);
            this.startIntervalTimer();
            this.handleTouch(x, y);
          }
        })

      // 统计信息
      // Text(`已填充格子: ${this.filledCells.size}`)
      //   .fontSize(14)
      //   .fontColor('#666')
      //   .margin(5)

      // Button('重新开始')
      //   .width('60%')
      //   .backgroundColor('#ff4444')
      //   .fontColor('#ffffff')
      //   .margin(10)
      //   .onClick(() => {
      //     this.stopIntervalTimer();
      //     this.filledCells.clear();
      //     this.drawGrid();
      //   })
      // Blank()
      Row() {
        this.PassBtn($r('app.string.btn_fullscreen'), true);
        Button() {
          Image($r('app.media.ic_public_help'))
            .width('20vp')
            .height('20vp')
        }
        .width('22%')
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

        Button($r('app.string.btn_move'))
        .width('22%')
        .height('60vp')
        .backgroundColor(Color.Grey)
        .onClick(() => {
          if (this.yPosArrayIndex === 3) {
            this.yPosArrayIndex = 0;
          }
          this.yPosArrayIndex++;

        })
      }
      .width('100%')
      .position({ x: '0%', y: this.yPosArray[this.yPosArrayIndex % 3]})
      .justifyContent(FlexAlign.SpaceEvenly)
      .backgroundColor(Color.White);

    }
    .width('100%')
    .height('100%')
    .backgroundColor(Color.Black)
  }

  // 处理触摸点
  handleTouch(x: number, y: number) {
    const col = Math.floor(x / this.gridSize);
    const row = Math.floor(y / this.gridSize);
    const cellKey = `${row},${col}`;

    // 检查边界
    const maxCol = Math.floor(this.ctx.width / this.gridSize);
    const maxRow = Math.floor(this.ctx.height / this.gridSize);
   // console.log("ohtest x: "+ x + " y: " + y + " col: "+ col + " row: " + row + " isDragging: " + this.isDragging + " maxCol: "+ maxCol + " maxRow:" + maxRow);
    if (col >= 0 && col <= maxCol && row >= 0 && row <= maxRow) {
      if (!this.filledCells.has(cellKey)) {
        this.filledCells.set(cellKey, true);
        this.fillCellImmediately(row, col);
      }
    }
  }

  fillCellImmediately(row: number, col: number) {
    this.Vue = true;
    const x = col * this.gridSize;
    const y = row * this.gridSize;

    this.ctx.fillStyle = this.fillColor[this.arrayIndex % 5];
    console.log("ohtest x: "+ x + " y: " + y + " gridSize: "+ this.gridSize);
    this.ctx.fillRect(x, y, this.gridSize, this.gridSize);

    // 重新绘制网格线（保持网格线在顶部）
    this.ctx.strokeStyle = this.gridColor;
    this.ctx.lineWidth = 0.5;
    this.ctx.strokeRect(x, y, this.gridSize, this.gridSize);
  }

  // 绘制基础网格
  drawGrid() {
    const width = this.ctx.width;
    const height = this.ctx.height;
    this.ctx.clearRect(0, 0, width, height);
    this.ctx.fillStyle = this.fillColor[this.arrayIndex % 5];
    this.filledCells.forEach((value, cellKey) => {
      const parts: string[] = cellKey.split(',');
      const row: number = Number(parts[0]);
      const col: number = Number(parts[1]);

      const x = col * this.gridSize;
      const y = row * this.gridSize;
      this.ctx.fillRect(x, y, this.gridSize, this.gridSize);
    })
    // 绘制网格线
    this.ctx.strokeStyle = this.gridColor;
    this.ctx.lineWidth = 0.5;
    this.ctx.beginPath();

    for (let x = 0; x <= width; x += this.gridSize) {
      this.ctx.moveTo(x, 0);
      this.ctx.lineTo(x, height);
    }
    for (let y = 0; y <= height; y += this.gridSize) {
      this.ctx.moveTo(0, y);
      this.ctx.lineTo(width, y);
    }
    this.ctx.stroke();
  }

  startIntervalTimer() {
  //  console.log("ohtest this.timerId "+ this.timerId + " startIntervalTimer.");
    // 每隔0.5秒执行一次
    if (this.timerId == -1) {
      this.timerId = setInterval(() => {
        if (this.arrayIndex === 5) {
          this.arrayIndex = 0;
        }
        this.arrayIndex++;
        //  绘制所有已填充的格子
        this.ctx.fillStyle = this.fillColor[this.arrayIndex % 5];
        this.filledCells.forEach((value, cellKey) => {
          const parts: string[] = cellKey.split(',');
          const row: number = Number(parts[0]);
          const col: number = Number(parts[1]);

          const x = col * this.gridSize;
          const y = row * this.gridSize;
          this.ctx.fillRect(x, y, this.gridSize, this.gridSize);

          // 重新绘制网格线（保持网格线在顶部）
          this.ctx.strokeStyle = this.gridColor;
          this.ctx.lineWidth = 0.5;
          this.ctx.strokeRect(x, y, this.gridSize, this.gridSize);
        })
      }, 500);
     // console.log("ohtest after start timerId: " + this.timerId);
    }
  }

  stopIntervalTimer() {
    if (this.timerId !== -1) {
  //    console.log("ohtest this.timerId "+ this.timerId + " will stop.");
      clearInterval(this.timerId);
      this.timerId = -1;
    }
  }

}