ECDH = require('ecdh')

Given("I have a message", function()
    ACK.message = IN.message
end)

Given("I have a public key", function()
    keyring = ECDH.new()
    keyring:public(OCTET.base64(IN.KEYS.public))
    ACK.keyring = keyring
end)

Given("I have a signature", function()
    ACK.r = OCTET.base64(IN.r)
    ACK.s = OCTET.base64(IN.s)
end)

When("I verify the message", function()
    verified = ACK.keyring:verify(ACK.message, ACK.r, ACK.s)
    OUT.verified = verified
end)

ZEN:begin(0)

script = [[
    Scenario 'data': Sign Message
    Given I have a message
    And I have a public key
    And I have a signature
    When I verify the message
    Then print all data
]]

ZEN:parse(script)
ZEN:run()
