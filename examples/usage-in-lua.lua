typoki = require "typok-interpreter" --pseudo lib
typoki = typoki.load({
    loadPath = "",
    string={
        min={
            validate=function(val, subvar)
                return val >= typoki.subvar.first(subvar)
            end,
            msg="Value $val should be not lesser then $params[1]",
        },
        max={
            validate=function(val, subvar)
                return val <=  typoki.subvar.first(subvar)
            end,
            msg="Value $val should be not more then $params[1]",
        },
        pattern=function(val, subvar)
            return string.match(val, typoki.subvar.first(subvar))
        end
    },
    timestamp={
        validate=function(v, subvar)
            return type(v) != type(12)
        end,
        generator=typoki.generators.int
    }
})
local userTypok = typoki.laod("user")

function printUser(user)
    userTypok.assert(user)
    print(user.userName)
end

return printUser
-- limitations str.strlen, str.required, num.int, num.int8
-- was not implemented and will be ignored