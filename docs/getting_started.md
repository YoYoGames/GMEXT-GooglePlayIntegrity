@title Getting Started

This guide walks you through integrating the Google Play Integrity extension into your GameMaker project. By the end you will be able to request an integrity token on Android and verify it server-side.

## Prerequisites

Before using this extension you will need:

* A Google Play Console app with the [Play Integrity API](https://developer.android.com/google/play/integrity/overview) enabled
* A Google Cloud project linked to your Play Console app (found under **App integrity → Play Integrity API → Linked Cloud Project** in the Play Console)
* A backend server capable of calling the Google Play Integrity API to verify tokens (see [Server-Side Verification](#server-side-verification) below)

## Extension Setup

1. Add the **GMPlayIntegrity** extension to your GameMaker project.
2. Open the [Extension Options](extension_options) and set **CLOUD_PROJECT_NUMBER** to the project number of your linked Google Cloud project.

## Generating a Nonce

Before requesting an integrity token you must generate a cryptographic nonce - a one-time random value that binds the token to a specific request. The Play Integrity API requires a Base64 web-safe no-wrap encoded string.

```gml
function play_integrity_generate_nonce() {
    var _byte_count = 24;
    var _buf = buffer_create(_byte_count, buffer_fixed, 1);

    for (var _i = 0; _i < _byte_count; _i++) {
        buffer_poke(_buf, _i, buffer_u8, irandom(255));
    }

    var _bytes = "";
    for (var _i = 0; _i < _byte_count; _i++) {
        _bytes += chr(buffer_peek(_buf, _i, buffer_u8));
    }
    buffer_delete(_buf);

    var _nonce = base64_encode(_bytes);
    _nonce = string_replace_all(_nonce, "+", "-");
    _nonce = string_replace_all(_nonce, "/", "_");
    _nonce = string_replace_all(_nonce, "=", "");
    _nonce = string_replace_all(_nonce, "\n", "");
    _nonce = string_replace_all(_nonce, "\r", "");

    return _nonce;
}
```

[[Note: Store the nonce value - you will need to send it alongside the token to your backend server so it can validate the request.]]

## Requesting a Token

Call ${func.play_integrity_request_token} with the generated nonce and a callback function. The callback is invoked asynchronously with the result:

```gml
var _nonce = play_integrity_generate_nonce();

play_integrity_request_token(_nonce, function(_success, _token, _error) {
    if (!_success) {
        show_debug_message("Play Integrity token request failed: " + _error);
        return;
    }

    show_debug_message("Token received. Sending to server for verification...");
    play_integrity_send_to_server(_nonce, _token);
});
```

[[Note: On local APK builds and GameMaker runs (not installed from the Play Store), the verdict will reflect that the app is not recognised. This is expected during development. See [Testing](#testing) below.]]

## Sending the Token to Your Server

Once you have the token, send it along with the original nonce to your backend server using `http_request`:

```gml
function play_integrity_send_to_server(_nonce, _token) {
    var _payload = json_stringify({
        token: _token,
        nonce: _nonce
    });

    var _headers = ds_map_create();
    ds_map_add(_headers, "Content-Type", "application/json");

    http_request("https://YOUR_BACKEND_URL/verify", "POST", _headers, _payload);

    ds_map_destroy(_headers);
}
```

## Handling the Server Response

Listen for the result in an **Async - HTTP** event. Your server should return a JSON object indicating whether the integrity check passed:

```gml
// Async - HTTP event
if (async_load[? "status"] == 0) {
    var _response = json_parse(async_load[? "result"]);

    if (_response.success && _response.passed) {
        show_debug_message("Integrity check passed.");
        // Allow the action or grant access
    } else {
        show_debug_message("Integrity check failed.");
        // Reject the action or deny access
    }
}
```

## Server-Side Verification

Your backend server receives the token and nonce, calls the Google Play Integrity API (`playintegrity.v1.decodeIntegrityToken`), and validates:

* **Nonce match** - the nonce in the decoded token matches the nonce your game sent
* **App recognition** - `appRecognitionVerdict == "PLAY_RECOGNIZED"`
* **Licensing** - `appLicensingVerdict == "LICENSED"`

A reference Firebase Cloud Function implementation is included in the project's `ServerDocs` note asset (`source/PlayIntegrity_gml/notes/ServerDocs/ServerDocs.txt`).

## Testing

| Build type | Expected app verdict | Expected license verdict |
|---|---|---|
| Local APK / GameMaker run | `UNRECOGNIZED_VERSION` | `UNEVALUATED` |
| Google Play Internal Testing | `PLAY_RECOGNIZED` | `LICENSED` |

To test the full flow:

1. Export an Android AAB from GameMaker
2. Upload to Google Play Console under **Internal testing**
3. Add your test account as a tester
4. Install the build from the Play Store testing link
5. Run the integrity check - all verdicts should pass
