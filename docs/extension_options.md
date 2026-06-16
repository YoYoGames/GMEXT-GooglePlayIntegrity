@title Extension Options

You can access the Extension Options by navigating to the **GMPlayIntegrity** extension asset in the [Asset Browser](https://manual.gamemaker.io/monthly/en/Introduction/The_Asset_Browser.htm) and double-clicking it.

## Options

### CLOUD_PROJECT_NUMBER

| | |
|---|---|
| **Type** | String |
| **Required** | Yes |
| **Platform** | Android only |

The Google Cloud project number that is linked to your Google Play Console app. This value is required for the Play Integrity API to bind tokens to the correct project.

**Where to find it:**

1. Open the [Google Play Console](https://play.google.com/console)
2. Select your app
3. Go to **App integrity → Play Integrity API**
4. The linked Cloud project and its project number are shown here

Alternatively, find it in the [Google Cloud Console](https://console.cloud.google.com) under **Home → Project info → Project number**.

[[Important: Without a valid `CLOUD_PROJECT_NUMBER`, all calls to ${func.play_integrity_request_token} will fail. Make sure this value matches the Google Cloud project that is linked to your Play Console app.]]
