import {
  Credential,
  credentialService,
  PersonalDetails,
  PhysicalAttributes,
  ContactInfo,
  EmergencyContact,
  Address,
  LicenseSpecifics,
  DisciplinaryAction,
  IssuanceDetails,
  DigitalIdentity,
  Metadata,
  TrainingRecord,
  SecurityDetails,
  BiometricTemplate
} from '../services/CredentialService';
import { MainViewModel } from '../viewmodel/MainViewModel';
import { CoreModule } from 'core';

@Component
struct CredentialPage {
  mainViewModel: MainViewModel = new MainViewModel();
  coreModule: CoreModule = new CoreModule();
  @State credential: Credential | null = null;

  async aboutToAppear() {
    this.credential = await credentialService.loadCredential();
  }

  @Builder
  SectionHeader(title: string) {
    Text(title)
      .fontSize(this.coreModule.commonFloats.normal_font_size)
      .fontWeight(FontWeight.Bold)
      .fontColor(this.coreModule.commonColors.textPrimary)
      .margin({ top: 16, bottom: 4 })
  }

  @Builder
  DetailRow(label: string, value: string | number | null | undefined) {
    if (value) {
      Text(`${label}: ${value}`)
        .fontSize(this.coreModule.commonFloats.normal_font_size)
        .fontColor(this.coreModule.commonColors.textSecondary)
        .lineHeight(20)
        .align(Alignment.Start)
        .width('100%')
    }
  }

  @Builder
  DetailText(content: string) {
    Text(content)
      .fontSize(this.coreModule.commonFloats.normal_font_size)
      .fontColor(this.coreModule.commonColors.textSecondary)
      .lineHeight(20)
      .align(Alignment.Start)
      .width('100%')
  }

  @Builder
  PersonalDetailsSection(details: PersonalDetails) {
    this.SectionHeader('Personal Details')
    this.DetailRow('Name', details.fullName)
    this.DetailRow('Title', details.title)
    this.DetailRow('Date of Birth', details.dateOfBirth)
    this.DetailRow('Place of Birth', details.placeOfBirth)
    this.DetailRow('Nationality', details.nationality)
    this.DetailRow('Gender', details.gender)
  }

  @Builder
  PhysicalAttributesSection(attributes: PhysicalAttributes) {
    this.SectionHeader('Physical Attributes')
    this.DetailRow('Height', attributes.heightCm ? `${attributes.heightCm} cm` : null)
    this.DetailRow('Weight', attributes.weightKg ? `${attributes.weightKg} kg` : null)
    this.DetailRow('Eye Color', attributes.eyeColor)
    this.DetailRow('Hair Color', attributes.hairColor)
    this.DetailRow('Distinguishing Marks', attributes.distinguishingMarks)
  }

  @Builder
  ContactInfoSection(contactInfo: ContactInfo) {
    this.SectionHeader('Contact Information')
    this.DetailRow('Primary Email', contactInfo.primaryEmail)
    this.DetailRow('Secondary Email', contactInfo.secondaryEmail)
    this.DetailRow('Phone Number', contactInfo.phoneNumber)
  }

  @Builder
  EmergencyContactsSection(contacts: EmergencyContact[]) {
    this.SectionHeader('Emergency Contacts')
    ForEach(contacts, (contact: EmergencyContact) => {
      this.DetailText(`${contact.name} (${contact.relationship}): ${contact.phone}`)
    }, (contact: EmergencyContact) => contact.name + contact.phone)
  }

  @Builder
  AddressesSection(addresses: Address[]) {
    this.SectionHeader('Addresses')
    ForEach(addresses, (addr: Address) => {
      Column() {
        Text(`${addr.type} Address:`)
          .fontWeight(FontWeight.Medium)
          .fontColor(this.coreModule.commonColors.textSecondary)
          .margin({ bottom: 2 })
          .align(Alignment.Start)
          .width('100%')
        this.DetailText(`${addr.streetAddress}${addr.apartmentOrSuite ? ', ' + addr.apartmentOrSuite : ''}`)
        this.DetailText(`${addr.city}, ${addr.stateOrProvince}, ${addr.postalCode}`)
        this.DetailText(addr.country)
      }.margin({ bottom: 8 })
    }, (addr: Address) => addr.type)
  }

  @Builder
  LicenseSpecificsSection(license: LicenseSpecifics, licenseNumber: string) {
    this.SectionHeader('License Details')
    this.DetailRow('License Number', licenseNumber)
    this.DetailRow('Category', license.category)
    this.DetailRow('Sub-Category', license.subCategory)
    this.DetailRow('Level/Grade', license.levelOrGrade)
    this.DetailRow('Status', license.status)
    this.DetailRow('Status Reason', license.statusReason)

    if (license.endorsements?.length > 0) {
      Text('Endorsements:').fontWeight(FontWeight.Medium).margin({ top: 4 })
      ForEach(license.endorsements, (item: string) => this.DetailText(`- ${item}`),
        (item: string, index: number) => `${item}_${index}}`)
    }

    if (license?.restrictions && license.restrictions.length > 0) {
      Text('Restrictions:').fontWeight(FontWeight.Medium).margin({ top: 4 })
      ForEach(license.restrictions, (item: string) => this.DetailText(`- ${item}`),
        (item: string, index: number) => `${item}_${index}}`)
    }
  }

  @Builder
  TrainingHistorySection(history: TrainingRecord[]) {
    this.SectionHeader('Training History')
    ForEach(history, (tr: TrainingRecord) => {
      this.DetailText(`${tr.courseName} — Completed: ${tr.completionDate} (Provider: ${tr.provider})`)
    }, (tr: TrainingRecord, index: number) => `${tr.courseName}_${index}}`)
  }

  @Builder
  DisciplinaryActionsSection(actions: DisciplinaryAction[]) {
    this.SectionHeader('Disciplinary Actions')
    if (actions.length === 0) {
      this.DetailText('None')
    } else {
      ForEach(actions, (action: DisciplinaryAction) => {
        Column({ space: 2 }) {
          this.DetailRow('Date', action.date)
          this.DetailRow('Action Taken', action.actionTaken)
          this.DetailRow('Reason', action.reason)
          this.DetailRow('Authority', action.resolvingAuthority)
          this.DetailRow('Case #', action.caseNumber)
        }
        .padding(8)
        .border({ width: 1, color: this.coreModule.commonColors.textSecondary, radius: 4 })
        .margin({ bottom: 8 })
      }, (action: DisciplinaryAction, index: number) => `${action.actionTaken}_${index}}`)
    }
  }

  @Builder
  IssuanceDetailsSection(details: IssuanceDetails) {
    this.SectionHeader('Issuance Details')
    this.DetailRow('Issuer', details.issuer)
    this.DetailRow('Issuing Country', details.issuingCountry)
    this.DetailRow('Issuing Authority', details.issuingAuthority)
    this.DetailRow('Issuing Officer ID', details.issuingOfficerId)
    this.DetailRow('Place of Issue', details.placeOfIssue)
    this.DetailRow('Issue Date', details.issueDate)
    this.DetailRow('Valid Until', details.validUntil)
    this.DetailRow('Document Type', details.documentType)
    this.DetailRow('Jurisdiction', details.jurisdiction)
  }

  @Builder
  DigitalIdentitySection(identity: DigitalIdentity) {
    this.SectionHeader('Digital Identity')
    this.DetailRow('Photo URL', identity.photoUrl)
    this.DetailRow('Signature URL', identity.signatureImageUrl)
    this.DetailRow('Holographic Overlay URL', identity.holographicOverlayUrl)
    this.DetailRow('Issuer Signature', identity.issuerSignature ? 'Provided' : 'Not Provided')
    this.DetailRow('Verification Payload', identity.verificationPayload ? 'Provided' : 'Not Provided')
    this.DetailRow('Holder Public Key', identity.holderPublicKey ? 'Provided' : 'Not Provided')
  }

  @Builder
  SecuritySection(security: SecurityDetails) {
    this.SectionHeader('Security Details')
    this.DetailRow('Security Level', security.securityLevel)
    if (security.biometricTemplates?.length > 0) {
      Text('Biometric Templates:').fontWeight(FontWeight.Medium).margin({ top: 4 })
      ForEach(security.biometricTemplates, (bio: BiometricTemplate) => {
        this.DetailText(`- Type: ${bio.type}, Hash: ${bio.hash}, Timestamp: ${bio.timestamp}`)
      }, (bio: BiometricTemplate, index: number) => `${bio.timestamp}_${index}}`)
    }
    this.DetailRow('Tamper Detection Last Checked', security.tamperDetection.lastChecked)
    this.DetailRow('Tamper Detection Status', security.tamperDetection.status)
  }

  @Builder
  MetadataSection(metadata: Metadata, remarks?: string) {
    if (remarks) {
      this.SectionHeader('Remarks')
      this.DetailText(remarks)
    }
    this.SectionHeader('Metadata')
    this.DetailRow('Created At', metadata.createdAt)
    this.DetailRow('Updated At', metadata.updatedAt)
    this.DetailRow('Schema Version', metadata.schemaVersion)
  }

  build() {
    NavDestination() {
      Scroll() {
        Column({ space: 8 }) {
          Text('Athlete License')
            .fontSize(this.coreModule.commonFloats.header_font_size)
            .fontWeight(FontWeight.Bold)
            .fontColor(this.coreModule.commonColors.textPrimary)
            .textAlign(TextAlign.Center)
            .margin({ bottom: 16 })

          if (this.credential) {
            this.PersonalDetailsSection(this.credential.personalDetails)
            this.PhysicalAttributesSection(this.credential.personalDetails.physicalAttributes)
            this.ContactInfoSection(this.credential.personalDetails.contactInfo)
            this.EmergencyContactsSection(this.credential.personalDetails.emergencyContacts)
            this.AddressesSection(this.credential.addresses)
            this.LicenseSpecificsSection(this.credential.licenseSpecifics, this.credential.licenseNumber)
            this.TrainingHistorySection(this.credential.licenseSpecifics.trainingHistory)
            this.DisciplinaryActionsSection(this.credential.licenseSpecifics.disciplinaryActions)
            this.IssuanceDetailsSection(this.credential.issuanceDetails)
            this.DigitalIdentitySection(this.credential.digitalIdentity)
            this.SecuritySection(this.credential.security)
            this.MetadataSection(this.credential.metadata, this.credential.remarks)

          } else {
            Text('Loading credential...')
              .fontSize(this.coreModule.commonFloats.normal_font_size)
              .fontColor('#999999')
              .margin({ top: 40 })
          }
        }
        .width('100%')
        .padding({ left: 16, right: 16, bottom: 32 })
      }
      .width('100%')
      .height('100%')
      .linearGradient({
        direction: GradientDirection.Bottom,
        colors: [
          [this.coreModule.commonColors.baseBackgroundGradientStart, 0.0],
          [this.coreModule.commonColors.baseBackgroundGradientEnd, 1.0]
        ]
      })
      .padding({ top: 20 })
    }.hideTitleBar(true)
  }
}

export { CredentialPage };