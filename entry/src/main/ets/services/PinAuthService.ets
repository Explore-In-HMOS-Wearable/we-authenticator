import { Context } from '@kit.AbilityKit';
import { preferences } from '@kit.ArkData';

export class PinAuthService {
  private attemptsRemaining: number = 5;
  private isLocked: boolean = false;
  private prefs: preferences.Preferences | null = null;
  private readonly PIN_CODE_KEY: string = 'secure_pin_code';
  private readonly LOCKOUT_TIMER_KEY: string = 'lockout_timer';
  private readonly MAX_ATTEMPTS: number = 5;
  private readonly LOCKOUT_DURATION: number = 30000; // 30 seconds

  async initialize(context: Context): Promise<void> {
    try {
      // Initialize preferences with provided context
      this.prefs = await preferences.getPreferences(context, 'PinAuthPreferences');

      // Check lockout status
      const lockoutUntil = await this.prefs.get(this.LOCKOUT_TIMER_KEY, '0');
      if (Date.now() < Number(lockoutUntil)) {
        this.isLocked = true;
      }
    } catch (error) {
      console.error('Failed to initialize PIN service:', JSON.stringify(error));
    }
  }

  async isPinSet(): Promise<boolean> {
    if (!this.prefs) {
      throw new Error('Preferences not initialized');
    }

    try {
      const pin = await this.prefs.get(this.PIN_CODE_KEY, '');
      return pin !== '';
    } catch (error) {
      console.error('Failed to check PIN:', JSON.stringify(error));
      return false;
    }
  }

  async setPin(newPin: string): Promise<boolean> {
    if (newPin.length !== 4) {
      return false;
    }

    try {
      if (!this.prefs) {
        throw new Error('Preferences not initialized');
      }

      await this.prefs.put(this.PIN_CODE_KEY, newPin);
      await this.prefs.flush();
      return true;
    } catch (error) {
      console.error('Failed to set PIN:', JSON.stringify(error));
      return false;
    }
  }

  async verifyPin(enteredPin: string): Promise<boolean> {

    if (!this.prefs) {
      throw new Error('Preferences not initialized');
    }

    if (this.isLocked) {
      const lockoutUntil = await this.prefs.get(this.LOCKOUT_TIMER_KEY, '0');
      if (Date.now() < Number(lockoutUntil)) {

        throw new Error(`Account locked. Try again in ${Math.ceil((Number(lockoutUntil) - Date.now())) /
          1000} seconds.`);

      } else {
        this.isLocked = false;
        this.attemptsRemaining = this.MAX_ATTEMPTS;
      }
    }

    const storedPin = await this.prefs.get(this.PIN_CODE_KEY, '');
    if (enteredPin === storedPin) {
      this.attemptsRemaining = this.MAX_ATTEMPTS;
      return true;
    }

    this.attemptsRemaining--;
    if (this.attemptsRemaining <= 0) {
      const lockoutTime = Date.now() + this.LOCKOUT_DURATION;
      await this.prefs.put(this.LOCKOUT_TIMER_KEY, lockoutTime.toString());
      await this.prefs.flush();
      this.isLocked = true;
      throw new Error(`Too many attempts. Try again in ${this.LOCKOUT_DURATION / 1000} seconds.`);
    }

    return false;
  }

  getAttemptsRemaining(): number {
    return this.attemptsRemaining;
  }

  async clearPin(): Promise<void> {
    try {
      if (!this.prefs) {
        throw new Error('Preferences not initialized');
      }

      await this.prefs.delete(this.PIN_CODE_KEY);
      await this.prefs.delete(this.LOCKOUT_TIMER_KEY);
      await this.prefs.flush();
      this.attemptsRemaining = this.MAX_ATTEMPTS;
      this.isLocked = false;
    } catch (error) {
      console.error('Failed to clear PIN:', JSON.stringify(error));
      throw new Error(typeof error === 'string' ? error : JSON.stringify(error));
    }
  }
}

export const pinAuthService = new PinAuthService();