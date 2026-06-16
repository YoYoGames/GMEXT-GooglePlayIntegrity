// ##### extgen :: Auto-generated file do not edit!! #####

// #####################################################################
// # Macros
// #####################################################################

// #####################################################################
// # Enums
// #####################################################################

// #####################################################################
// # Constructors
// #####################################################################

// #####################################################################
// # Codecs
// #####################################################################

// #####################################################################
// # Functions
// #####################################################################

/**
 * @param {String} _nonce
 * @param {Function} _callback
 * @returns {Bool} 
 */
function play_integrity_request_token(_nonce, _callback)
{
    static __dispatcher = __GMPlayIntegrity_get_dispatcher();

    var __args_buffer = __ext_core_get_args_buffer();

    // param: _nonce, type: String
    if (!is_string(_nonce)) show_error($"{_GMFUNCTION_} :: _nonce expected string", true);
    buffer_write(__args_buffer, buffer_u32, string_byte_length(_nonce));
    buffer_write(__args_buffer, buffer_string, _nonce);

    // param: _callback, type: Function
    if (!is_callable(_callback)) show_error($"{_GMFUNCTION_} :: _callback expected callable type", true);
    var _callback_handle = __ext_core_function_register(_callback, __dispatcher);
    buffer_write(__args_buffer, buffer_u64, _callback_handle);

    var _return_value = __play_integrity_request_token(buffer_get_address(__args_buffer), buffer_tell(__args_buffer));

    return _return_value;
}

/// @ignore
function __GMPlayIntegrity_get_decoders()
{
    static __decoders = [];
    return __decoders;
}
/// @ignore
function __GMPlayIntegrity_get_dispatcher()
{
    static __dispatcher = new __GMNativeFunctionDispatcher(__GMPlayIntegrity_invocation_handler, __GMPlayIntegrity_get_decoders());
    return __dispatcher;
}
