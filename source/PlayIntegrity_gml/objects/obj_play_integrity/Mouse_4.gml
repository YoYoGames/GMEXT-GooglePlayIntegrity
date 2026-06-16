
function generate_nonce() {
    var byte_count = 24;
    var buf = buffer_create(byte_count, buffer_fixed, 1);

    for (var i = 0; i < byte_count; i++) {
        buffer_poke(buf, i, buffer_u8, irandom(255));
    }

    var byte_string = "";

    for (var i = 0; i < byte_count; i++) {
        var byte_val = buffer_peek(buf, i, buffer_u8);
        byte_string += chr(byte_val);
    }

    var nonce_base64 = base64_encode(byte_string);

    // Play Integrity needs Base64 web-safe no-wrap.
    nonce_base64 = string_replace_all(nonce_base64, "+", "-");
    nonce_base64 = string_replace_all(nonce_base64, "/", "_");
    nonce_base64 = string_replace_all(nonce_base64, "=", "");
    nonce_base64 = string_replace_all(nonce_base64, "\n", "");
    nonce_base64 = string_replace_all(nonce_base64, "\r", "");

    buffer_delete(buf);

    return nonce_base64;
}

/*var*/ _nonce = generate_nonce();
function play_integrity_test_full() {
    

    show_debug_message("Play Integrity nonce: " + _nonce);

    play_integrity_request_token(_nonce, function(_success, _token, _error) {
        if (!_success) {
            show_debug_message("Play Integrity token failed: " + string(_error));
            show_message_async("Token failed:\n" + string(_error));
            return;
        }

        show_debug_message("Play Integrity token length: " + string(string_length(_token)));
        show_debug_message("Play Integrity token preview: " + string_copy(_token, 1, 80) + "...");

        var _payload_struct = {
            token: _token,
            nonce: _nonce
        };

        var _payload = json_stringify(_payload_struct);

        var _headers = ds_map_create();
        ds_map_add(_headers, "Content-Type", "application/json");

		//var PLAY_INTEGRITY_VERIFY_URL = "https://us-central1-YOUR_PROJECT_ID.cloudfunctions.net/verifyPlayIntegrity";
		var PLAY_INTEGRITY_VERIFY_URL = "https://YOUR_CLOUD_RUN_URL.a.run.app";
		
        var _request_id = http_request(
            PLAY_INTEGRITY_VERIFY_URL,
            "POST",
            _headers,
            _payload
        );

        ds_map_destroy(_headers);

        show_debug_message("Firebase verify request id: " + string(_request_id));

        // Optional: store request id if you have many HTTP calls.
        play_integrity_http_request_id = _request_id;
    });
}

// Run test:
play_integrity_test_full();

