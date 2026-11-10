export const PHYSICALSTATUS2ICON = {
  Active: 'person-running',
  Debilitated: 'crutch',
  Unconscious: 'moon-o',
  Deceased: 'skull',
};

export const PHYSICALSTATUS2COLOR = {
  Active: 'green',
  Debilitated: 'purple',
  Unconscious: 'orange',
  Deceased: 'red',
} as const;

export const PHYSICALSTATUS2DESC = {
  Active: 'Active. Individual is conscious and healthy.',
  Debilitated: 'Debilitated. Individual is conscious, but unhealthy.',
  Unconscious: 'Unconscious. Individual may require medical attention.',
  Deceased: 'Temporarily non-living. Individual has become temporarily non-living and begun to decay.',
} as const;

export const MENTALSTATUS2ICON = {
  'Certified Inclusive': 'face-smile-o',
  'Under Observation': 'eye-o',
  'Differently Stable': 'scale-unbalanced-flip',
  'Unconventionally Perspective': 'head-side-virus',
};

export const MENTALSTATUS2COLOR = {
  'Certified Inclusive': 'green',
  'Under Observation': 'purple',
  'Differently Stable': 'orange',
  'Unconventionally Perspective': 'red',
} as const;

export const MENTALSTATUS2DESC = {
  'Certified Inclusive':
    'Certified Inclusive. Individual is inclusive and free from unapproved language.',
  'Under Observation':
    'Under Observation. Individual has been observed. This is not a penalty.',
  'Differently Stable':
    'Differently Stable. Individual has one or more alternative psychological experiences.',
  'Unconventionally Perspective':
    'Unconventionally Perspective. Individual exhibits a bold, self-authored relationship with consensus reality.',
} as const;
