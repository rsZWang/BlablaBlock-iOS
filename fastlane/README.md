fastlane documentation
----

# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```sh
xcode-select --install
```

For _fastlane_ installation instructions, see [Installing _fastlane_](https://docs.fastlane.tools/#installing-fastlane)

# Available Actions

## iOS

### ios harry

```sh
[bundle exec] fastlane ios harry
```

Clear build directory, get certificates, build and upload to testflight, download dsyms on store, upload store and local dsyms, clear

### ios clear_dir

```sh
[bundle exec] fastlane ios clear_dir
```

Clear build directory

### ios build

```sh
[bundle exec] fastlane ios build
```

Build

### ios upload_submit_testflight

```sh
[bundle exec] fastlane ios upload_submit_testflight
```

Upload to testflight and submit beta review

### ios upload_dsyms

```sh
[bundle exec] fastlane ios upload_dsyms
```

Upload dSYMs

### ios upload_store_dsyms

```sh
[bundle exec] fastlane ios upload_store_dsyms
```

Upload store dSYMs

### ios upload_local_dsyms

```sh
[bundle exec] fastlane ios upload_local_dsyms
```

Upload local dSYMs

### ios notify_slack_success

```sh
[bundle exec] fastlane ios notify_slack_success
```

Notify slack build uploaded successfully message

### ios fetch_cert

```sh
[bundle exec] fastlane ios fetch_cert
```

Fetch certificates

### ios register_fetch_cert

```sh
[bundle exec] fastlane ios register_fetch_cert
```

Register devices and fetch certificates

----

This README.md is auto-generated and will be re-generated every time [_fastlane_](https://fastlane.tools) is run.

More information about _fastlane_ can be found on [fastlane.tools](https://fastlane.tools).

The documentation of _fastlane_ can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
