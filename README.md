# typok-lang
Typok is simple type-declaration compilable/interpretable programming language.
May be used for embedding, integrating into or code-generation for other platforms.


## Example of declaration
```typok
require timestamp
require str.pattern

userName: str(minlen(8)) //str type with custom limitation

taxNum: num(int & min(1000000) & max(9999999)) //number with limitations

role: 0 | "user" | "guest" //literals union. basic type is *

rules: {string} //array of dynamic values

isUnknown: bool(false) //bool literal type. equal to `false`

dateSql: str(required & pattern("/^\n\n\-\n\n\-\n{4}$/i")) //str with custom limitations

passwordVerificator: * -> bool //function from any to bool

return { //record type
    userName: userName
    taxNum: taxNum
    role: role
    rules: rules
    isUnknown: isUnknown
    dateSql: dateSql
    password: * | null
    passwordVerificator: passwordVerificator
    passwordHash: (comment(outer password hash value)) //equals to `any.comment` or `any`
    createdAt: timestamp
    sharding: num(int8)
} //module return type
```


## Example of usage
```lua
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
    return user
end

return printUser
-- limitations str.strlen, str.required, num.int, num.int8
-- was not implemented and will be ignored

```

## List of known typok-using tools


## Language specification

Typok is extendable type-declaration language. It has simplest syntaxis and bay me extended by outer interpretator. Here is list of rules, every typok-using tool must implements.


### Reserved keywords
- `return` - return type of module
- `require` - require outer type. Interrupt compilation if it had been not provided


### Comments
- Single-line comments define by `//` characters and not take a part in compilation


## Custom types
Any custom type, not includes in standart may be optional implemented in interpreter. Custom types, declared as `required` must be implemented or declared in interpreter.


### Basic types
Any typok interpreters and tools should implemet this basic types:

- `*` - any/dynamic/data value. Missed type declaration means any type. Any other type is considered an extension of `any` type
- `num` - any number type. Equals to `*.num`
- `str` - any string value. Equals to `*.str`
- `bool` - boolean value. Equals to `*.bool`
- `coll` - collection of some typed data. Equals to `*.coll(*)`
- `null` - null unit value type
- `{x: t1 y: str}` - open record/table type with properties `x` of type `t1` and `y` of type `str`


### Literals
Typok supports literal types. Any literal is considered as subset of its parent type. Any typok interpreters should implements this literals

- `number` - any number has "number" type. examples: 12, 13.2. 
- `string` - any string in quotes. example: "Hello, World!", ""
- `boolean` - values 'true' and 'false' refers to boolean type. examples: true, false
- `null` - null type may contains only null value.


### Type operations
- `|` - union infix operator. Declaring any of types. Result basic type is closest general parent.
- `&` - intersection infix operator. Declaring type is every of types. Result basic type is closest general parent.


### Open records
In Typok every record/table by default is considered an open-type and can't be closed. For Example Typok type:
```typok
pos: {x: 12}
```
is equals typescript type
```typescript
type pos<A extends {x: 12}> = A
```


### Type-containers and limitation types
Every type is also dynamic container that contains some result of limitation types. Container result may be getted by outer parser. For example:
```typok
dateSql = str(required & pattern("/^\n\n\-\n\n\-\n{4}$/i") & comment("sql date"))
```
Here `dateSql` type definition is equals to
```typok
//will hase basic type `str`
dateSql =
    | str.required
    | str.pattern."/^\n\n\-\n\n\-\n{4}$/i"
    | str.comment."sql date"
```
where str.required, str.pattern..., str.comment... is custom type limitations, thats will interpretated by compiler/interpretator. Type limitations is also containers, thats may contains deeper limitations or literals data, that only interpreter or outer tool will know how to use..


## Author
Anatoly Starodubtsev
tostar74@mail.ru


## License
MIT