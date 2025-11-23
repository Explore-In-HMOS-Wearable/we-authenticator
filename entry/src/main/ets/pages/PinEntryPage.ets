import { pinAuthService } from '../services/PinAuthService';
import { Context } from '@kit.AbilityKit';
import { CoreModule } from 'core';
import { MainViewModel } from '../viewmodel/MainViewModel';

@Component
struct PinEntryPage {
  private context?: Context = this.getUIContext().getHostContext();
  mainViewModel: MainViewModel = new MainViewModel();
  coreModule: CoreModule = new CoreModule();
  @State pin: string = '';
  @State errorMessage: string = '';
  @State isPinSet: boolean = true;

  async aboutToAppear() {
    if (this.context) {
      await pinAuthService.initialize(this.context);
      this.isPinSet = await pinAuthService.isPinSet();
    }
  }

  async onButtonClick() {
    if (!this.pin || this.pin.length < 4) {
      this.errorMessage = '';
      return;
    }

    let errMsg = '';
    if (!this.isPinSet) {
      const success = await pinAuthService.setPin(this.pin);
      if (success) {
        this.isPinSet = true;
        this.pin = '';
        errMsg = 'PIN set successfully! Repeat the PIN';
      } else {
        errMsg = 'Failed to set PIN';
      }
    } else {
      try {
        const isValid = await pinAuthService.verifyPin(this.pin);
        if (isValid) {
          console.info('✅ PIN verified successfully!');
          this.mainViewModel.replacePage('Credential');
        } else {
          errMsg = `❌ Invalid PIN. ${pinAuthService.getAttemptsRemaining()} attempts left`;
        }
      } catch (error) {
        errMsg = (error instanceof Error) ? error.message : JSON.stringify(error);
      }
    }

    this.errorMessage = errMsg;
  }

  build() {
    NavDestination() {
      Column() {
        Text(this.isPinSet ? 'Enter PIN' : 'Set New PIN')
          .fontSize(this.coreModule.commonFloats.header_font_size)
          .fontWeight(FontWeight.Medium)
          .fontColor(this.coreModule.commonColors.textSecondary)
          .margin({ bottom: this.coreModule.commonFloats.medium_margin })
          .alignRules({
            center: { anchor: '__container__', align: VerticalAlign.Top },
            middle: { anchor: '__container__', align: HorizontalAlign.Center }
          })

        TextInput({ text: this.pin })
          .width(this.coreModule.commonFloats.input_width)
          .height(this.coreModule.commonFloats.input_height)
          .fontSize(this.coreModule.commonFloats.normal_font_size)
          .type(InputType.Number)
          .maxLength(6)
          .borderRadius(12)
          .border({ width: 1, color: '#888888' })
          .padding({ left: 12, right: 12 })
          .backgroundColor($r('sys.color.white'))
          .fontColor('#000')
          .alignRules({
            center: { anchor: '__container__', align: VerticalAlign.Center },
            middle: { anchor: '__container__', align: HorizontalAlign.Center }
          })
          .onChange((value: string) => this.pin = value.trim())

        Button(this.isPinSet ? 'Verify' : 'Set PIN')
          .width(this.coreModule.commonFloats.button_width)
          .height(this.coreModule.commonFloats.button_height)
          .fontSize(this.coreModule.commonFloats.normal_font_size)
          .borderRadius(22)
          .backgroundColor(this.coreModule.commonColors.accent)
          .fontColor(this.coreModule.commonColors.textOnAccent)
          .margin({ top: this.coreModule.commonFloats.medium_margin })
          .alignRules({
            center: { anchor: '__container__', align: VerticalAlign.Center },
            middle: { anchor: '__container__', align: HorizontalAlign.Center }
          })
          .onClick(() => this.onButtonClick())

        if (this.errorMessage) {
          Text(this.errorMessage)
            .fontSize(this.coreModule.commonFloats.normal_font_size)
            .fontColor('#cc0000')
            .margin({ top: this.coreModule.commonFloats.small_margin })
            .textAlign(TextAlign.Center)
            .alignRules({
              center: { anchor: '__container__', align: VerticalAlign.Center },
              middle: { anchor: '__container__', align: HorizontalAlign.Center }
            })
        }
      }
      .justifyContent(FlexAlign.Center)
      .height('100%')
      .width('100%')
      .padding({
        left: this.coreModule.commonFloats.screen_padding,
        right: this.coreModule.commonFloats.screen_padding
      })
      .linearGradient({
        direction: GradientDirection.Bottom,
        colors: [
          [this.coreModule.commonColors.baseBackgroundGradientStart, 0.0],
          [this.coreModule.commonColors.baseBackgroundGradientEnd, 1.0]
        ]
      })
    }.hideTitleBar(true)
  }
}

export { PinEntryPage };
