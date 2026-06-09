#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint fvp.podspec` to validate before publishing.
# Run `flutter clean` and rebuild to sync podspec changes
#
Pod::Spec.new do |s|
  s.name             = 'fvp'
  s.version          = '0.35.2'
  s.summary          = 'libmdk based Flutter video player plugin'
  s.description      = <<-DESC
Flutter video player plugin.
                       DESC
  s.homepage         = 'https://mediadevkit.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Wang Bin' => 'wbsecg1@gmail.com' }

  s.compiler_flags   = '-Wno-documentation', '-std=c++20'
  s.frameworks       = 'AVFoundation'
  s.osx.frameworks    = 'FlutterMacOS'
  #s.osx.pod_target_xcconfig  =  { 'OTHER_LDFLAGS'  =>  '-framework FlutterMacOS'  }
  s.source           = { :path => '.' }
  s.source_files     = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.ios.dependency 'Flutter'
  s.osx.dependency 'FlutterMacOS'
  s.ios.deployment_target = '12.0'
  s.osx.deployment_target = '10.13'
  # Bumped 0.35.1 -> 0.36.0: 0.35.x's VideoToolbox decoder hard-crashes
  # (EXC_BAD_ACCESS in VideoToolboxDecoder::open() -> OutputFormat ->
  # CFDictionaryGetValueIfPresent) on streams where VT can't create a
  # decode session (e.g. hvc1/HEVC with missing/late codec params, common
  # in live IPTV). The segfault aborts the process before the FFmpeg
  # software fallback can run. mdk 0.36.0 "Ignore session create error for
  # hvc1, fix decoder open error on macOS" makes VT fail gracefully, so the
  # ['VT','FFmpeg'] chain keeps hardware-first and only drops to software
  # for the streams VT can't handle, instead of crashing.
  s.dependency 'mdk', '~> 0.36.0'

#  s.platform = :osx, '10.11'
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES' }
  s.resource_bundles = {'fvp_privacy' => ['PrivacyInfo.xcprivacy']}
#  s.swift_version = '5.0'
  s.prepare_command = <<-CMD
    FVP_VERSION=`grep 'version: ' ../pubspec.yaml | head -1 | awk '{print $2}'`
    echo '#pragma once\n#define FVP_VERSION "'$FVP_VERSION'"' > ../lib/src/version.h
  CMD
end
