import { CoreModule } from 'core';
import { PinEntryPage } from './PinEntryPage';
import { CredentialPage } from './CredentialPage';
import { MainViewModel } from '../viewmodel/MainViewModel';

@Entry
@Component
struct Index {
  coreModule: CoreModule = new CoreModule();
  mainViewModel: MainViewModel = new MainViewModel();

  @Builder
  routeMap(name: string) {
    if (name === 'Credential') {
      CredentialPage();
    } else {
      PinEntryPage();
    }
  }

  aboutToAppear(): void {
    this.mainViewModel.navigateToPage('PinEntry');
  }

  build() {
    Navigation(this.mainViewModel.navigationService.pageInfos) {
      // empty
    }
    .linearGradient({
      direction: GradientDirection.Bottom,
      colors: [
        [this.coreModule.commonColors.baseBackgroundGradientStart, 0.0],
        [this.coreModule.commonColors.baseBackgroundGradientEnd, 1]
      ]
    })
    .navDestination(this.routeMap)
    .ignoreLayoutSafeArea()
    .hideNavBar(true)
    .width('100%')
    .height('100%')
  }
}