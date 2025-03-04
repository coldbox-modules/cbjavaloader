# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

* * *

## [Unreleased]

## [2.2.0] - 2025-02-19

### Added

- Github actions updated
- ColdBox 7 Auto testing
- Syntax formatting

## [2.1.1] => 2022-MAR-09

### Fixed

- Updated the `setup-commandbox` command to avoid having the `box.zip` included in the repo
- Removal of `server-*.json` files on the final build
- Updated github actions to latests module standards

## [2.1.0] => 2022-FEB-04

### Added

- More formatting rules
- Migration to github actions
- Updates from new module template

## [2.0.0] => 2020-MAY-14

### Added

- New module template support
- ColdBox 5-6 Support
- Modern Formatting

### Removed

- Lucee 4.5 Support
- ACF11 Support

## [1.5.0] => 2018-MAR-16

- Updated interfaces for Coldbox 5 support
- More local testing updates
- Updated dependencies
- Dropped cf10 support

## [1.4.0]

- Updated internal core Javaloader library to latest 1.2 release
- Added automatic dynamic proxy class loading
- Deprecating support for cf10

## [1.3.3]

- Cleanup of testing Application.cfc

## [1.3.2]

- Removal of security issues with Javaloader `tags` directory
- Securing execution of Javaloader models
- Updated to unified workbench

## [1.3.1]

- Travis Update Builds
- Adobe CF 2016,11,10 compatiblity fixes

## [1.3.0]

- Adobe CF Compatiblity

## [1.2.0]

- Travis Updates
- Changing the array of locations check so that it doesn't fail if a JAR file is passed in the array.
- Readme Updates
- ForgeBox2 Updates

## [1.1.0]

- Travis Integration
- DocBox update
- Build updates
- CCM-17 Error handling broken in javaloader
- CCM-12 loadpaths setting doesn't allow directory
- Better documentation

## [1.0.0]

- Create first module version

[unreleased]: https://github.com/coldbox-modules/cbjavaloader/compare/v2.2.0...HEAD
[2.2.0]: https://github.com/coldbox-modules/cbjavaloader/compare/768425a02713cf6d17ebae745a4d15cc1e8b603a...v2.2.0
