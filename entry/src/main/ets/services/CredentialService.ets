export type AddressType = 'Residential' | 'Mailing' | 'Business';
export type Gender = 'Male' | 'Female' | 'Non-binary' | 'Unspecified';
export type CredentialStatus = 'Active' | 'Expired' | 'Suspended' | 'Revoked' | 'Pending Review';
export type DocumentType = 'Professional License' | 'National ID' | `Driver's License` | 'Membership Card' | 'Access Permit';
export type BiometricType = 'Fingerprint' | 'FaceScan' | 'IrisScan';

export interface Address {
  type: AddressType;
  streetAddress: string;
  apartmentOrSuite?: string;
  city: string;
  stateOrProvince: string;
  postalCode: string;
  country: string;
}

export interface EmergencyContact {
  name: string;
  relationship: string;
  phone: string;
}

export interface DisciplinaryAction {
  date: string;
  actionTaken: string;
  reason: string;
  resolvingAuthority: string;
  caseNumber: string;
}

export interface TrainingRecord {
  courseName: string;
  completionDate: string;
  provider: string;
  certificateId?: string;
}

export interface PhysicalAttributes {
  heightCm: number;
  weightKg: number;
  eyeColor: string;
  hairColor: string;
  distinguishingMarks?: string;
}

export interface ContactInfo {
  primaryEmail: string;
  secondaryEmail?: string;
  phoneNumber: string;
}

export interface PersonalDetails {
  title?: 'Mr.' | 'Ms.' | 'Mrs.' | 'Dr.';
  fullName: string;
  firstName: string;
  middleName?: string;
  lastName: string;
  suffix?: 'Jr.' | 'Sr.' | 'III';
  dateOfBirth: string;
  placeOfBirth: string;
  nationality: string;
  gender: Gender;
  physicalAttributes: PhysicalAttributes;
  contactInfo: ContactInfo;
  emergencyContacts: EmergencyContact[];
}

export interface IssuanceDetails {
  issuer: string;
  issuingCountry: string;
  issuingAuthority: string;
  issuingOfficerId?: string;
  placeOfIssue: string;
  issueDate: string;
  validUntil: string;
  documentType: DocumentType;
  jurisdiction: string;
}

export interface LicenseSpecifics {
  category: string;
  subCategory?: string;
  levelOrGrade: string;
  status: CredentialStatus;
  statusReason?: string;
  endorsements: string[];
  restrictions?: string[];
  trainingHistory: TrainingRecord[];
  disciplinaryActions: DisciplinaryAction[];
}

export interface DigitalIdentity {
  photoUrl: string;
  signatureImageUrl: string;
  holographicOverlayUrl: string;
  issuerSignature: string;
  verificationPayload: string;
  holderPublicKey: string;
}

export interface BiometricTemplate {
  type: BiometricType;
  hash: string;
  timestamp: string;
}

export interface TamperDetectionStatus {
  lastChecked: string;
  status: 'OK' | 'Failed';
}

export interface SecurityDetails {
  biometricTemplates: BiometricTemplate[];
  securityLevel: 'Low' | 'Standard' | 'High' | 'Maximum';
  tamperDetection: TamperDetectionStatus;
}

export interface Metadata {
  createdAt: string;
  updatedAt: string;
  schemaVersion: string;
}

export interface Credential {
  id: string;
  licenseNumber: string;
  credentialVersion: string;
  replacesCredentialId?: string;
  personalDetails: PersonalDetails;
  issuanceDetails: IssuanceDetails;
  addresses: Address[];
  licenseSpecifics: LicenseSpecifics;
  digitalIdentity: DigitalIdentity;
  security: SecurityDetails;
  remarks?: string;
  metadata: Metadata;
}

class CredentialService {
  async loadCredential(): Promise<Credential> {
    const emergencyContacts: EmergencyContact[] = [
      { name: 'Anna Kovalenko', relationship: 'Spouse', phone: '+43 664 7654321' }
    ];

    const addresses: Address[] = [
      {
        type: 'Residential',
        streetAddress: '123 Sportlerweg',
        city: 'Vienna',
        stateOrProvince: 'Vienna',
        postalCode: '1010',
        country: 'Austria',
      },
      {
        type: 'Mailing',
        streetAddress: 'PO Box 500',
        city: 'Vienna',
        stateOrProvince: 'Vienna',
        postalCode: '1011',
        country: 'Austria',
      }
    ];

    const trainingHistory: TrainingRecord[] = [
      { courseName: 'Sports Psychology Seminar', completionDate: '2024-08-20', provider: 'Intl. Coaching Federation' },
      { courseName: 'Advanced Conditioning Techniques', completionDate: '2024-03-11', provider: 'Vienna Sports University' }
    ];

    const disciplinaryActions: DisciplinaryAction[] = [];

    const biometricTemplates: BiometricTemplate[] = [
      { type: 'Fingerprint', hash: 'a1b2c3d4e5f6...', timestamp: '2025-01-10T10:00:00Z' },
      { type: 'FaceScan', hash: 'f6e5d4c3b2a1...', timestamp: '2025-01-10T10:05:00Z' }
    ];

    const credentialData: Credential = {
      id: 'DOC-SN-9876543210-V2',
      licenseNumber: 'AT-2025-001',
      credentialVersion: '2.1.0',
      replacesCredentialId: 'DOC-SN-9876543210-V1',

      personalDetails: {
        title: 'Mr.',
        fullName: 'Igor Kovalenko',
        firstName: 'Igor',
        lastName: 'Kovalenko',
        dateOfBirth: '1990-05-15',
        placeOfBirth: 'Kyiv, Ukraine',
        nationality: 'Austrian',
        gender: 'Male',
        physicalAttributes: {
          heightCm: 185,
          weightKg: 82,
          eyeColor: 'Blue',
          hairColor: 'Brown',
          distinguishingMarks: 'Small scar above left eyebrow',
        },
        contactInfo: {
          primaryEmail: 'igor.k.coach@example.com',
          phoneNumber: '+43 664 1234567',
        },
        emergencyContacts: emergencyContacts,
      },

      issuanceDetails: {
        issuer: 'National Sport Authority',
        issuingCountry: 'AT',
        issuingAuthority: 'Federal Committee for Professional Athletics',
        issuingOfficerId: 'AUT-9876',
        placeOfIssue: 'Vienna',
        issueDate: '2025-01-15',
        validUntil: '2028-01-14',
        documentType: 'Professional License',
        jurisdiction: 'Republic of Austria',
      },

      addresses: addresses,

      licenseSpecifics: {
        category: 'Professional Fencing Coach',
        subCategory: 'Olympic Disciplines',
        levelOrGrade: 'Master Class V',
        status: 'Active',
        endorsements: [
          'Épée Mastery Level III',
          'Foil Mastery Level II',
          'Sabre Fundamentals Certified',
          'International Competition Adjudicator',
          'Advanced First Aid & CPR'
        ],
        restrictions: [
          'Requires 20 annual continuing education credits'
        ],
        trainingHistory: trainingHistory,
        disciplinaryActions: disciplinaryActions,
      },

      digitalIdentity: {
        photoUrl: 'https://example.com/path/to/igor_kovalenko_photo.jpg',
        signatureImageUrl: 'https://example.com/path/to/igor_signature.svg',
        holographicOverlayUrl: 'https://example.com/path/to/security_hologram.png',
        issuerSignature: 'BASE64_MOCK_SIGNATURE_f4a3b2c1d0...a1b2c3d4e5f6a7b8c9d0e1f2a3b4c5d6',
        verificationPayload: '{"docId":"DOC-SN-9876543210-V2","name":"Kovalenko,I","exp":"20280114","cat":"FNC"}',
        holderPublicKey: '04f5a2d1b3e4f6a7c8d9e0f1a2b3c4d5e6f7a8b9c0d1e2f3a4b5c6d7e8f9a0b1c2d3e4f5a6b7c8d9e0f1a2b3c4d5e6f7a8b9c0d1e2f3a4b5c6d7e8f9a0',
      },

      security: {
        biometricTemplates: biometricTemplates,
        securityLevel: 'High',
        tamperDetection: {
          lastChecked: '2025-01-15T08:00:00Z',
          status: 'OK',
        },
      },

      remarks: 'Holder is authorized to train athletes for Olympic-level events.',

      metadata: {
        createdAt: '2025-01-15T14:30:00Z',
        updatedAt: '2025-01-15T14:30:00Z',
        schemaVersion: '2.1.0',
      },
    };

    return credentialData;
  }
}

export const credentialService = new CredentialService();
