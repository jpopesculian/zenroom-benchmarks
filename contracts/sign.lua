ECDH = require('ecdh')

Given("I have a message", function()
    ACK.message = IN.message
end)

Given("I have a private key", function()
    keyring = ECDH.new()
    keyring:private(OCTET.base64(IN.KEYS.private))
    ACK.keyring = keyring
end)

When("I sign the message", function()
    r, s = ACK.keyring:sign(ACK.message)
    OUT.r = r:base64()
    OUT.s = s:base64()
end)

ZEN:begin(0)

script = [[
    Scenario 'data': Sign Message
    Given I have a message
    And I have a private key
    When I sign the message
    Then print all data
]]

ZEN:parse(script)
ZEN:run()
