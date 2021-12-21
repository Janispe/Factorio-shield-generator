data:extend({
    {
        type = 'int-setting',
        name = 'joules per shield hit point',
        setting_type = 'startup',
        default_value = 2000,
        minimum_value = 1,
        order = 'a',
    },
    {
        type = 'double-setting',
        name = 'shield generator range multiplier',
        setting_type = 'startup',
        default_value = 1,
        minimum_value = 0,
        order = 'ab',
    }, 
    {
        type = 'int-setting',
        name = 'shield generator hitpoints',
        setting_type = 'startup',
        default_value = 10000,
        minimum_value = 0,
        order = 'av',
    },
})