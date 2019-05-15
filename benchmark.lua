-- Zencode test

ECDH = require('ecdh')
verbosity = 1

-- benchmark
benchmark = require('benchmark')

function bench_start()
    start_ns = benchmark.ns()
end

function bench_label(label)
    print(label .. ": " .. (benchmark.ns() - start_ns))
end

function bench_end()
    diff_ns = benchmark.ns() - start_ns

    if diff_ns < 0
    then
        print("Ignoring trial")
        return
    end

    if bench_num == nil
    then
        bench_num = 1
        bench_avg = diff_ns
    else
        bench_num = bench_num + 1
        bench_avg = bench_avg + ((diff_ns - bench_avg) / bench_num)
    end

    print("Trial " .. bench_num .. ": " .. diff_ns)
end

function bench_final()
    print("Benchmark (" .. bench_num .. " trials): " .. bench_avg .. " ns")
    bench_num = nil
end

-- funcs

function add_message(message)
    m = message
end

function key_gen()
    ecdh = ECDH.keygen()
end

function sign()
    r, s = ecdh:sign(m)
end

function verify()
    assert(ecdh:verify(m, r, s))
end

-- steps

Given("I have the message ''", add_message)

Given("I have generated keys", key_gen)

Given("I have signed the message", sign)

When("I verify the signature", verify)

Then("print message signed", function ()
    -- print("message signed")
end)


-- execution

ZEN:begin(verbosity)

script = [[
Feature: Benchmark ECDH

  Scenario Outline: Gen keys, sign and verify
    Given I have the message 'Message to be signed'
    And I have generated keys
    And I have signed the message
    When I verify the signature
    Then print message signed ]]

ZEN:parse(script)

for i = 1,99
do
    bench_start()
    ZEN:run()
    bench_end()

    collectgarbage("collect")
end

bench_final()

