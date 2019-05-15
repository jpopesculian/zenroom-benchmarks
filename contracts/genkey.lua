ECDH = require('ecdh')


When("I generate keys", function()
    keyring = ECDH.new()
    keyring:keygen()
    OUT['private'] = keyring:private():base64()
    OUT['public'] = keyring:public():base64()
end)

ZEN:begin(0)

script = [[
    Scenario 'data': Generate keys
    When I generate keys
    Then print all data
]]

ZEN:parse(script)
ZEN:run()
