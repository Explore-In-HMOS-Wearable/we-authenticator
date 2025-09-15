import { cryptoFramework } from '@kit.CryptoArchitectureKit';

@Entry
@Component
export default struct QRCodeGenerator {
  @State qrValue: string = '';

  async doRand() {
    let rand = cryptoFramework.createRandom();
    let seed = new Uint8Array([1, 2, 3]);
    rand.setSeed({ data: seed });

    let randOutput = await rand.generateRandom(6);
    let digits = Array.from(randOutput.data)
      .map(n => (n % 10).toString())
      .join('');

    this.qrValue = digits;
  }

  build() {
    RelativeContainer() {
      Column() {
        Text('Do you want to generate new QR code?')
          .margin(2)

        QRCode(this.qrValue)
          .width('50%')
          .height('50%')
          .margin(2)

        Button('Generate')
          .width('100')
          .height('25')
          .backgroundColor(Color.Pink)
          .fontSize(14)
          .fontWeight(FontWeight.Bold)
          .borderColor(Color.White)
          .margin(2)
          .onClick(async () => {
            await this.doRand();
          });
      }
      .alignRules({
        center: { anchor: '__container__', align: VerticalAlign.Center },
        middle: { anchor: '__container__', align: HorizontalAlign.Center }
      })
      .padding(30)
    }
    .width('100%')
  }
}