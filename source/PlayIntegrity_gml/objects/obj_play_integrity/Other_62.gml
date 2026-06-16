
var _id = async_load[? "id"];
var _status = async_load[? "status"];
var _result = async_load[? "result"];

show_debug_message("HTTP id: " + string(_id));
show_debug_message("HTTP status: " + string(_status));
show_debug_message("HTTP result: " + string(_result));

if (variable_global_exists("play_integrity_http_request_id")) {
    if (_id != global.play_integrity_http_request_id) {
        exit;
    }
}

if (_status != 0) {
    show_message_async("HTTP failed. Status: " + string(_status));
    exit;
}

var _data = json_parse(_result);

if (!is_struct(_data)) {
    show_message_async("Invalid JSON from Firebase.");
    exit;
}

if (!_data.success) {
    var _error = "";
    
    if (variable_struct_exists(_data, "error")) {
        _error = _data.error;
    }

    show_message_async("Firebase verification failed:\n" + string(_error));
    exit;
}

var _passed = _data.passed;
var _checks = _data.checks;
var _verdicts = _data.verdicts;

var _msg = "Firebase verification result"
    + "\npassed: " + string(_passed)
    + "\nnonceOk: " + string(_checks.nonceOk)
    + "\nappOk: " + string(_checks.appOk)
    + "\nlicenseOk: " + string(_checks.licenseOk)
    + "\nexpectedNonce: " + string(_verdicts.expectedNonce)
    + "\nrequestNonce: " + string(_verdicts.requestNonce)
    + "\nappRecognitionVerdict: " + string(_verdicts.appRecognitionVerdict)
    + "\nappLicensingVerdict: " + string(_verdicts.appLicensingVerdict);

show_debug_message(_msg);
show_message_async(_msg);

show_message_async(_msg);

show_debug_message(_msg);

