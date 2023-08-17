fx_version 'cerulean'
version '1.1.0'
game 'gta5'
author 'wx / woox'
description 'Advanced job garage system via ox_target and ox_lib'
lua54 'yes'

client_scripts {'client/*.lua'}
shared_scripts {
    '@ox_lib/init.lua',
    'locales/*.lua',
    'configs/*.lua'
}
