//import Testing
//
//import ComposableArchitecture
//import Dependencies
//import SnapshotTesting
//import Tagged
//
//@MainActor
//struct PresetsListTests {
//
//  func initialize(_ body: (Array<SoundFont>, TestStoreOf<PresetsList>) async throws -> Void) async throws {
//    try await TestSupport.initialize { soundFonts, presets in
//      @Shared(.activeState) var activeState
//      $activeState.withLock {
//        $0.selectedSoundFontId = soundFonts[0].id
//      }
//      try await body(soundFonts, TestStore(initialState: PresetsList.State()) {
//        PresetsList()
//      })
//    }
//  }
//
//  @Test func creationWithNilSoundFont() async throws {
//    try await TestSupport.initialize { soundFonts, presets in
//      let store = TestStore(initialState: PresetsList.State()) { PresetsList() }
//      #expect(store.state.sections.count == 0)
//      await store.send(.onAppear)
//      await store.receive(\.selectedSoundFontIdChanged)
//      #expect(store.state.sections.count == 0)
//      await store.send(.stop)
//      await store.finish()
//    }
//  }
//
//  @Test func creation() async throws {
//    try await initialize { soundFonts, store in
//      #expect(store.state.sections.count == 24)
//      await store.send(.onAppear)
//      await store.receive(\.selectedSoundFontIdChanged)
//      #expect(store.state.sections.count == 24)
//      await store.send(.stop)
//      await store.finish()
//    }
//  }
//
//  @Test func detectSoundFontIdChange() async throws {
//    try await initialize { soundFonts, store in
//      await store.send(.onAppear)
//      await store.receive(\.selectedSoundFontIdChanged)
//
//      @Shared(.activeState) var activeState
//      $activeState.withLock {
//        $0.selectedSoundFontId = soundFonts[1].id
//      }
//
//      await store.receive(\.selectedSoundFontIdChanged) {
//        $0.sections = PresetsFeature.generatePresetSections(searchText: nil, editing: false)
//      }
//
//      await store.send(.stop)
//      await store.finish()
//    }
//  }
//
//  @Test func seesButtonTap() async throws {
//    try await initialize { soundFonts, store in
//      let preset = soundFonts[0].presets[3]
//      await store.send(.sections(.element(id: 0, action: .rows(.element(id: 4, action: .buttonTapped)))))
//      await store.receive(.sections(.element(id: 0, action: .rows(.element(id: 4, action: .delegate(.selectPreset(preset)))))))
//    }
//  }
//
//  @Test func editButtonTapped() async throws {
//    try await initialize { soundFonts, store in
//      let preset = soundFonts[0].presets[3]
//      await store.send(.sections(.element(id: 0, action: .rows(.element(id: 4, action: .editButtonTapped)))))
//      await store.receive(.sections(.element(id: 0, action: .rows(.element(id: 4, action: .delegate(.editPreset(preset))))))) {
//        $0.destination = .edit(PresetEditor.State(preset: preset))
//      }
//      await store.send(.destination(.presented(.edit(.acceptButtonTapped))))
//      await store.receive(.destination(.dismiss)) {
//        $0.destination = nil
//      }
//    }
//  }
//
//  @Test func fetchPresets() async throws {
//    try await initialize { soundFonts, store in
//      let sections = store.state.sections.count
//
//      @Dependency(\.defaultDatabase) var database
//      let presets = soundFonts[0].presets
//      for preset in presets[0..<15] {
//        try await database.write {
//          var preset = preset
//          preset.visible = false
//          try preset.save($0)
//        }
//      }
//
//      store.exhaustivity = .off
//      await store.send(.fetchPresets)
//      #expect(store.state.sections.count < sections)
//      await store.send(.visibilityEditMode(true)) {
//        $0.editingVisibility = true
//      }
//      #expect(store.state.sections.count == sections)
//      await store.send(.visibilityEditMode(false)) {
//        $0.editingVisibility = false
//      }
//      #expect(store.state.sections.count < sections)
//    }
//  }
//
//  @Test func hidePreset() async throws {
//    try await initialize { soundFonts, store in
//      var preset = soundFonts[0].presets[0]
//      #expect(preset.visible == true)
//
//      @Shared(.stopConfirmingPresetHiding) var stopConfirmingPresetHiding
//      $stopConfirmingPresetHiding.withLock { $0 = true }
//      #expect(store.state.sections[0].rows[0].preset.displayName == "Piano 1")
//
//      await store.send(.sections(.element(id: 0, action: .rows(.element(id: 1, action: .hideButtonTapped)))))
//      store.exhaustivity = .off
//      await store.receive(.sections(.element(id: 0, action: .rows(.element(id: 1, action: .delegate(.hidePreset(preset)))))))
//
//      preset = try await TestSupport.fetchPreset(presetId: preset.id)
//      #expect(preset.visible == false)
//
//      await store.receive(.fetchPresets)
//      #expect(store.state.sections[0].rows[0].preset.displayName == "Piano 2")
//    }
//  }
//
//  @Test func presetListViewPreview() async throws {
//    withSnapshotTesting(record: .failed) {
//      let view = PresetsListView.preview
//      assertSnapshot(of: view, as: .image(layout: .device(config: .iPhoneSe), traits: .init(userInterfaceStyle: .dark)))
//    }
//  }
//
//  @Test func presetListViewPreviewEditing() async throws {
//    withSnapshotTesting(record: .failed) {
//      let view = PresetsListView.previewEditing
//      assertSnapshot(of: view, as: .image(layout: .device(config: .iPhoneSe), traits: .init(userInterfaceStyle: .dark)))
//    }
//  }
//}
