# GMEXT-GooglePlayIntegrity
Repository for GameMaker's Google Play Integrity Extension

This repository was created with the intent of presenting users with the latest version available of the extension (even previous to marketplace updates) and also provide a way for the community to contribute with bug fixes and feature implementation.

This extension will work on Android.

* Android: `source/PlayIntegrity_gml/extensions/GMPlayIntegrity/AndroidSource/Java/`

## Requirements

In order to use this extension you will need:

* A Google Play Console app with the [Play Integrity API](https://developer.android.com/google/play/integrity) enabled
* A Google Cloud project linked to your Play Console app
* A backend server to verify Play Integrity tokens (see the [Getting Started](../../wiki) guide for a reference implementation)

> [!IMPORTANT]
> To set up the extension in the IDE, double-click on it and complete the necessary information in the [Extension Options](https://manual.gamemaker.io/monthly/en/The_Asset_Editors/Extensions.htm).
>
> Set **CLOUD_PROJECT_NUMBER** to the Google Cloud project number linked to your Play Console app.

## Documentation

* Check [the documentation](../../wiki)

The online documentation is regularly updated to ensure it contains the most current information. For those who prefer a different format, we also offer a HTML version. This HTML is directly converted from the GitHub Wiki content, ensuring consistency, although it may follow slightly behind in updates.

We encourage users to refer primarily to the GitHub Wiki for the latest information and updates. The HTML version, included with the extension and within the demo project's data files, serves as a secondary, static reference.

Additionally, if you're contributing new features through PR (Pull Requests), we kindly ask that you also provide accompanying documentation for these features, to maintain the comprehensiveness and usefulness of our resources.
