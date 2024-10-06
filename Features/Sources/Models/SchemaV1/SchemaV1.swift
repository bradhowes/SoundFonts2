// Copyright © 2024 Brad Howes. All rights reserved.

import AudioToolbox
import SwiftData

public enum SchemaV1: VersionedSchema {
  public static var versionIdentifier: Schema.Version { .init(1, 0, 0) }

  public static var models: [any PersistentModel.Type] {
    [
      AudioSettingsModel.self,
      DelayConfigModel.self,
      FavoriteModel.self,
      PresetModel.self,
      ReverbConfigModel.self,
      SoundFontModel.self,
      TagModel.self
    ]
  }
}
