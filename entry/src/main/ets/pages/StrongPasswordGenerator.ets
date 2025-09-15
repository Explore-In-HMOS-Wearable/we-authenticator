import { cryptoFramework } from '@kit.CryptoArchitectureKit';

@Entry
@Component
export default struct StrongPasswordGenerator {
  @State randomValue: string = '000000';
  @State digitNumber: number = 0;
  @State includeNumber: boolean = false;
  @State includeSpecialChar: boolean = false;
  @State upperCaseSensitivity: boolean = false;

  async doRand() {
    let rand = cryptoFramework.createRandom();
    let seed = new Uint8Array([1, 2, 3]);
    rand.setSeed({ data: seed });

    let len = this.digitNumber > 0 ? this.digitNumber : 6;
    let randOutput = await rand.generateRandom(len);

    let chars = 'abcdefghijklmnopqrstuvwxyz';
    if (this.upperCaseSensitivity) {
      chars += 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    }
    if (this.includeNumber) {
      chars += '0123456789';
    }
    if (this.includeSpecialChar) {
      chars += '!@#$%^&*()?' ;
    }

    let password = Array.from(randOutput.data)
      .map(n => chars[n % chars.length])
      .join('');

    console.error('password', password)

    this.randomValue = password;
  }

  build() {
    Column() {
      Row(){
        Checkbox({ name: 'checkbox1', group: 'checkboxGroup' })
          .selectedColor(Color.Pink)
          .shape(CheckBoxShape.ROUNDED_SQUARE)
          .onChange((value: boolean) => {
            this.includeSpecialChar = value
            console.info('Checkbox1 change is'+ value)
          })
          .unselectedColor(Color.Gray)
          .width('5%')
        Text('Special Character')
          .fontSize(14)
      }

      Row(){
        Checkbox({ name: 'checkbox2', group: 'checkboxGroup' })
          .selectedColor(Color.Pink)
          .shape(CheckBoxShape.ROUNDED_SQUARE)
          .onChange((value: boolean) => {
            this.includeNumber = value
            console.info('Checkbox2 change is'+ value)
          })
          .unselectedColor(Color.Gray)
          .width('5%')
        Text('Includes Numbers')
          .fontSize(14)
      }

      Row(){
        Checkbox({ name: 'checkbox3', group: 'checkboxGroup' })
          .selectedColor(Color.Pink)
          .shape(CheckBoxShape.ROUNDED_SQUARE)
          .onChange((value: boolean) => {
            this.upperCaseSensitivity = value
            console.info('Checkbox3 change is'+ value)
          })
          .unselectedColor(Color.Gray)
          .width('5%')
        Text('Upper Case Sensitivity')
          .fontSize(14)
      }

      Row(){
        Text('How many digits for the Authenticator code?')
          .margin(2)

        TextInput({ text: this.digitNumber.toString(), placeholder: 'your digit number' })
          .placeholderColor(Color.Gray)
          .placeholderFont({ size: 14, weight: 500 })
          .caretColor(Color.Pink)
          .fontColor(Color.White)
          .fontSize(14)
          .margin(2)
          .width('18%')
          .onChange((value: string) => {
            let num = parseInt(value);
            if (!isNaN(num)) {
              this.digitNumber = num;
            }
          })
      }

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
      left: 10,
      right: 10
    })
  }
}