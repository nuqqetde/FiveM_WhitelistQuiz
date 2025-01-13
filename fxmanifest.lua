fx_version 'cerulean'
game 'gta5'

author 'nuqqeT.de'
description 'Whitelist Quiz System'
version '1.0.0'

client_scripts {
    'client/main.lua',
    'client/nui.lua'
}

server_scripts {
    'server/questions.lua',
    'server/main.lua'
}

ui_page 'html/index.html'

files {
    'html/index.html',
    'html/style.css',
    'html/script.js'
} 