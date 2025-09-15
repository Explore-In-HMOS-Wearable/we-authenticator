import { router } from '@kit.ArkUI';

@Entry
@Component
struct Index {
  @State message: string = 'Hello World';

  build() {
    RelativeContainer() {
      Column(){
        Text('We Authenticator')
          .margin(2)
          .fontWeight(FontWeight.Bold)
          .fontColor(Color.Red)
        this.button('Strong Password Generator', this.strongPasswordGenerator)
        this.button('Digit Generator', this.numberGenerator)
        this.button('QR Code Generator', this.qrCodeGenerator)
        Text(' "Smart, safe, and cryptographically strong!" ')
          .margin(2)
          .fontSize(14)
          .fontWeight(FontWeight.Bold)
          .fontStyle(FontStyle.Italic)
      }
      .alignRules({
        center: { anchor: '__container__', align: VerticalAlign.Center },
        middle: { anchor: '__container__', align: HorizontalAlign.Center }
      })
    }
    .height('100%')
    .width('100%')
    .padding({
      bottom: 10
    })
  }

  private strongPasswordGenerator = () => {
    router.pushUrl({ url: 'pages/StrongPasswordGenerator' });
  }
  private numberGenerator = () => {
    router.pushUrl({ url: 'pages/DigitGenerator' });
  }
  private qrCodeGenerator = () => {
    router.pushUrl({ url: 'pages/QRCodeGenerator' });
  }

  @Builder
  button(text: string, onClick: () => void) {
    Button({ type: ButtonType.Normal }) {
      Text(text)
        .fontSize(14)
        .fontWeight(FontWeight.Bold)
    }
    .width('70%')
    .height('15%')
    .backgroundColor(Color.Pink)
    .borderRadius(24)
    .borderColor(Color.White)
    .onClick(onClick)
    .margin(2)
  }
}