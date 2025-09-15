import { cryptoFramework } from '@kit.CryptoArchitectureKit';

@Entry
@Component
export default struct DigitGenerator {
  @State randomValue: string = '000000';
  @State digitNumber: number = 0;
  private intervalId: number | undefined = undefined;

  async doRand() {
    let rand = cryptoFramework.createRandom();
    let seed = new Uint8Array([1, 2, 3]);
    rand.setSeed({ data: seed });

    let len = this.digitNumber > 0 ? this.digitNumber : 6;
    let randOutput = await rand.generateRandom(len);

    let digits = Array.from(randOutput.data)
      .map(n => (n % 10).toString())
      .join('');

    this.randomValue = digits;
  }

  aboutToAppear() {
    this.doRand();
    this.intervalId = setInterval(() => {
      this.doRand();
    }, 60000);
  }

  aboutToDisappear() {
    if (this.intervalId) {
      clearInterval(this.intervalId);
    }
  }

  build() {
    Column() {
      Text('How many digits for the Authenticator code?')
        .margin(2)

      TextInput({ text: this.digitNumber.toString(), placeholder: 'your digit number' })
        .placeholderColor(Color.Gray)
        .placeholderFont({ size: 14, weight: 500 })
        .caretColor(Color.Pink)
        .fontColor(Color.White)
        .fontSize(14)
        .margin(2)
        .onChange((value: string) => {
          let num = parseInt(value);
          if (!isNaN(num)) {
            this.digitNumber = num;
          }
        })

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

      Text('It will be updated in 60 seconds')
        .margin(2)

      if (this.digitNumber > 12) {
        Text('Max length is 12!')
          .margin(2)
          .fontWeight(FontWeight.Bold)
          .fontColor(Color.Red)
      } else {
        Text(this.randomValue)
          .margin(2)
          .fontWeight(FontWeight.Bold)
      }
    }
    .alignRules({
      center: { anchor: '__container__', align: VerticalAlign.Center },
      middle: { anchor: '__container__', align: HorizontalAlign.Center }
    })
    .padding({
      top: 40,
      left: 20,
      right: 20
    })
  }
}
