// FUNCTIONS

/**
 * @func play_integrity_request_token
 * @desc This function requests a Google Play Integrity token from the device for the provided nonce. The result is delivered asynchronously through the provided callback function.
 *
 * The typical flow is: generate a nonce, request a token using this function, then send the token and nonce to your backend server for verification against the Google Play Integrity API.
 *
 * [[Note: This function is only available on Android. On all other platforms it returns `false` immediately.]]
 *
 * @param {String} nonce A Base64 web-safe no-wrap encoded nonce string. The nonce must be at least 16 bytes of random data encoded as Base64 with `+` replaced by `-`, `/` replaced by `_`, and `=` padding removed. See the ${page.getting_started} guide for a GML nonce generation example.
 * @param {Function} callback A callback function that is invoked asynchronously with the result of the token request. The callback receives three arguments:
 * * `_success` {bool}: `true` if the token was obtained successfully, `false` otherwise.
 * * `_token` {string}: The integrity token returned by Google Play. Empty string if unsuccessful.
 * * `_error` {string}: An error message describing what went wrong. Empty string on success.
 * @returns {Bool} Returns `true` if the request was successfully initiated, or `false` if the nonce is empty, the callback is undefined, or an error occurred before the request could be sent.
 *
 * @example
 * The following example shows how to generate a nonce, request a Play Integrity token, and send it to a backend server for verification:
 *
 * ```gml
 * // Step 1: Generate a cryptographic nonce
 * var _byte_count = 24;
 * var _buf = buffer_create(_byte_count, buffer_fixed, 1);
 * for (var _i = 0; _i < _byte_count; _i++) {
 *     buffer_poke(_buf, _i, buffer_u8, irandom(255));
 * }
 * var _bytes = "";
 * for (var _i = 0; _i < _byte_count; _i++) {
 *     _bytes += chr(buffer_peek(_buf, _i, buffer_u8));
 * }
 * buffer_delete(_buf);
 *
 * var _nonce = base64_encode(_bytes);
 * _nonce = string_replace_all(_nonce, "+", "-");
 * _nonce = string_replace_all(_nonce, "/", "_");
 * _nonce = string_replace_all(_nonce, "=", "");
 * _nonce = string_replace_all(_nonce, "\n", "");
 * _nonce = string_replace_all(_nonce, "\r", "");
 *
 * // Step 2: Request an integrity token
 * play_integrity_request_token(_nonce, function(_success, _token, _error) {
 *     if (!_success) {
 *         show_debug_message("Token request failed: " + _error);
 *         return;
 *     }
 *
 *     // Step 3: Send the token and nonce to your backend server
 *     var _payload = json_stringify({ token: _token, nonce: _nonce });
 *     var _headers = ds_map_create();
 *     ds_map_add(_headers, "Content-Type", "application/json");
 *     http_request("https://YOUR_BACKEND_URL/verify", "POST", _headers, _payload);
 *     ds_map_destroy(_headers);
 * });
 * ```
 * @func_end
 */

// MODULES

/**
 * @module home
 * @title Google Play Integrity
 * @desc The Google Play Integrity API allows you to check whether interactions and server requests from your game originate from your genuine app binary running on a genuine Android device. This helps protect your game from tampering, fraud, and abuse.
 *
 * The extension provides a single function to request an integrity token from the device. This token is then sent to your backend server, which verifies it against the Google Play Integrity API and returns the result to your game.
 *
 * ## How It Works
 *
 * 1. Your game generates a cryptographic nonce (a one-time random value)
 * 2. The extension requests an integrity token from Google Play using that nonce
 * 3. Your game sends the token and nonce to your backend server via HTTP
 * 4. Your server calls the Google Play Integrity API to decode and verify the token
 * 5. Your server returns the verdict to your game
 *
 * [[Note: This extension only works on Android.]]
 *
 * @section Guides
 * @desc The following guides will help you get set up and start using the extension.
 * @reference page.getting_started
 * @reference page.extension_options
 * @section_end
 *
 * @section_func
 * @desc The following function is provided by this extension:
 * @ref play_integrity_request_token
 * @section_end
 *
 * @module_end
 */
