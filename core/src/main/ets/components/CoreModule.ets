import { CommonColors } from '../constants/CommonColors';
import { CommonFloats } from '../constants/CommonFloats';

export class CoreModule {
  static _instance: CoreModule;
  commonColors: CommonColors = new CommonColors();
  commonFloats: CommonFloats = new CommonFloats();

  static getInstance() {
    if (!CoreModule._instance) {
      CoreModule._instance = new CoreModule();
    }
    return CoreModule._instance;
  }
}
