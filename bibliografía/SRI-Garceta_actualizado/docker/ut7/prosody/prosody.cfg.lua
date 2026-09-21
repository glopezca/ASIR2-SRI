admins = { }
modules_enabled = {
    "roster";
    "saslauth";
    "tls";
    "dialback";
    "disco";
    "ping";
    "version";
}
allow_registration = false
c2s_require_encryption = false
s2s_require_encryption = false
VirtualHost "asirlab.local"
    authentication = "internal_hashed"
